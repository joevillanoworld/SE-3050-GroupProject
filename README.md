# SE-3050-GroupProject
Group project repository

**MEMBERS**
-------
Luis Medina-Macias, 
Raina Stofft, 
Joseph Villano

**Farmers Market Directory: Project Proposal**

Overview:

Farmers markets often have little online presence beyond a Facebook page and often do not publish exactly what their vendors sell. This project designs and builds a database-backed web application that lets users discover markets, find vendors, search for products across all markets, and reserve products for pickup.

Core features:

1. Browse markets. Shoppers see a list of active farmer’s markets with name and city.
2. View market details. Each market page shows its address and the list of vendors who sell there.
3. Search products across markets. Shoppers search by product name or category. Each result shows the vendor and every market where that product can be bought.
4. Place a pre-order. A shopper selects products from a single vendor, chooses a market and pickup date, and submits the order. The system verifies that the vendor sells at that market, checks stock, reserves the quantities, and records the order.

Data design:

The schema contains eight entities: market, vendor, product, market_vendor, market_product, customer, preorder, and preorder_item. Attributes of these entities and the relationships between them are detailed in the ERD.

Transaction handling:

Placing a pre-order must either fully succeed or leave no trace. The operation runs as a single database transaction that validates the vendor-market relationship, creates the order, and decrements product stock. Any failure, such as insufficient stock, rolls back the entire transaction.

Technology stack:

The application will use MySQL for the database, and Python with Flask for the backend.

Scope:

* The application has no payment processing; pre-orders are reserved online and paid at pickup.
* There is no user authentication; customers are identified by id or email.
* Vendors sell the same set of products at every market they attend.

Deliverables:

* An Entity Relationship Diagram
* Seed data covering several markets, vendors, and products
* A working web application implementing the four features
* A written report covering design decisions

**SCREENSHOT OF PROJECT BOARD**
<img width="1431" height="715" alt="project board" src="https://github.com/user-attachments/assets/b30404c4-6101-4ca4-9165-323101eb2d69" />
