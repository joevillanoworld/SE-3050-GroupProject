from flask import Flask, render_template, request
from database import get_db_connection


app = Flask(__name__)




@app.route('/', methods=['GET', 'POST'])
def index():


   connection = get_db_connection()
   cursor = connection.cursor(dictionary=True)


   cursor.execute("""
       SELECT market_id, name, address
       FROM market
       ORDER BY name;
   """)


   markets = cursor.fetchall()


   for market in markets:
       cursor.execute("""
           SELECT
               v.vendor_id,
               v.name AS vendor_name,
               v.email
           FROM vendor AS v
           JOIN market_vendor AS mv
               ON mv.vendor_id = v.vendor_id
           WHERE mv.market_id = %s
           ORDER BY v.name;
       """, (market['market_id'],))


       market['vendors'] = cursor.fetchall()


   cursor.execute("""
    SELECT * FROM product;
    """)
   products = cursor.fetchall()
   search_query = request.args.get('q', '').strip()
   search_results = []


   if search_query:
       cursor.execute("""
           SELECT
               p.product_id,
               p.name,
               p.category,
               m.market_id,
               m.name AS market_name,
               m.address,
               mp.price,
               mp.available_quantity
           FROM product AS p
           JOIN market_product AS mp
               ON mp.product_id = p.product_id
           JOIN market AS m
               ON m.market_id = mp.market_id
           WHERE p.name LIKE %s
           ORDER BY p.name, m.name;
       """, ('%' + search_query + '%',))


       search_results = cursor.fetchall()




   message = None
   if request.method == 'POST':
       try:
           connection.rollback()
           connection.start_transaction()


           customer_name = request.form.get('customer_name', '').strip()
           customer_email = request.form.get('customer_email', '').strip()
           market_id = int(request.form.get('market_id'))
           product_id = int(request.form.get('product_id'))
           quantity = int(request.form.get('quantity'))


           if not customer_name or not customer_email:
               raise ValueError("Please enter your name and email.")


           if quantity <= 0:
               raise ValueError("Quantity must be greater than zero.")


           cursor.execute("""
               SELECT price, available_quantity
               FROM market_product
               WHERE market_id = %s AND product_id = %s
               FOR UPDATE;
           """, (market_id, product_id))


           stock = cursor.fetchone()


           if stock is None:
               raise ValueError(
                   "This product is not available at the selected market."
               )


           if quantity > stock['available_quantity']:
               raise ValueError(
                   f"Only {stock['available_quantity']} units are available."
               )


           cursor.execute("""
               SELECT customer_id
               FROM customer
               WHERE email = %s;
           """, (customer_email,))


           customer = cursor.fetchone()


           if customer is None:
               cursor.execute("""
                   INSERT INTO customer (name, email)
                   VALUES (%s, %s);
               """, (customer_name, customer_email))


               customer_id = cursor.lastrowid
           else:
               customer_id = customer['customer_id']


           cursor.execute("""
               INSERT INTO preorder (customer_id, market_id)
               VALUES (%s, %s);
           """, (customer_id, market_id))


           preorder_id = cursor.lastrowid


           cursor.execute("""
               INSERT INTO preorder_item
                   (preorder_id, product_id, quantity, unit_price)
               VALUES (%s, %s, %s, %s);
           """, (
               preorder_id,
               product_id,
               quantity,
               stock['price']
           ))


           cursor.execute("""
               UPDATE market_product
               SET available_quantity = available_quantity - %s
               WHERE market_id = %s AND product_id = %s;
           """, (quantity, market_id, product_id))


           connection.commit()


           message = "Your preorder was successfully placed!"


       except (ValueError, TypeError) as e:
           connection.rollback()
           message = str(e)


       except Exception as e:
           connection.rollback()
           import traceback


           print("\n========== PREORDER ERROR ==========")
           print("Error type:", type(e).__name__)
           print("Error message:", repr(e))
           traceback.print_exc()
           print("===================================\n")


           message = "Something went wrong while placing your preorder."




   cursor.close()
   connection.close()


   return render_template('index.html',
                          markets=markets,
                          products=products,
                          search_query=search_query,
                          search_results=search_results,
                          message=message,)




if __name__ == '__main__':
   app.run(debug=True)