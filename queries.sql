

#   1. Browse active markets

SELECT
    market_id,
    name,
    address
FROM market
ORDER BY name;


/* 
   2. View a market's details
   Returns the market's basic information (ID, name, and address)

    */
SELECT
    market_id,
    name,
    address
FROM market
WHERE market_id = '';


/* 
   3. List vendors at a market

   Uses the market_vendor table to find vendors connected 
   with the selected market.
    */
SELECT
    v.vendor_id,
    v.name AS vendor_name,
    v.email
FROM vendor AS v
JOIN market_vendor AS mv
    ON mv.vendor_id = v.vendor_id
WHERE mv.market_id = ''
ORDER BY v.name;


/* 
   4. List products available at a market
   Returns products, prices, and current available quantities for
   the a market.
    */
SELECT
    p.product_id,
    p.name,
    p.category,
    mp.price,
    mp.available_quantity
FROM market_product AS mp
JOIN product AS p
    ON p.product_id = mp.product_id
WHERE mp.market_id = ?
ORDER BY p.category, p.name;


/* 
   5. Search products across all markets

   Returns each matching product-market listing. It includes the
   market, price, and available quantity. 
    */
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
WHERE p.name LIKE ('')
ORDER BY p.name, m.name;



#   6. Find a customer by email

SELECT
    customer_id,
    name,
    email
FROM customer
WHERE email = ?;


/* 
   7. List a customer's preorders

   Returns order information.
    */
SELECT
    po.preorder_id,
    po.market_id,
    m.name AS market_name,
    po.status,
    po.placed_at
FROM preorder AS po
JOIN market AS m
    ON m.market_id = po.market_id
WHERE po.customer_id = ?
ORDER BY po.placed_at DESC;


/* 
   8. View preorder details
   Returns each item in a pre-order.
    */
SELECT
    po.preorder_id,
    po.status,
    po.placed_at,
    c.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    m.market_id,
    m.name AS market_name,
    p.product_id,
    p.name AS product_name,
    pi.quantity,
    pi.unit_price,
    (pi.quantity * pi.unit_price) AS total
FROM preorder AS po
JOIN customer AS c
    ON c.customer_id = po.customer_id
JOIN market AS m
    ON m.market_id = po.market_id
JOIN preorder_item AS pi
    ON pi.preorder_id = po.preorder_id
JOIN product AS p
    ON p.product_id = pi.product_id
WHERE po.preorder_id = ?
ORDER BY p.name;


