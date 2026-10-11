Here is why our market database satisfies 3NF:

1NF: All atomic values and no repeating groups

Every column holds a single value (no comma-separated lists or repeated columns like product1, product2), and every table has a primary key. Many-to-many relationships are modeled with junction tables (market_vendor, market_product, preorder_item) rather than multi-valued columns.

2NF: There are no partial dependencies

This only matters for tables with composite keys, so there are four to check:

market_vendor (market_id, vendor_id) has no non-key columns, so there is nothing that could depend on part of the key.
market_product (market_id, product_id): price and available_quantity describe a specific product at a specific market. Neither is determined by market_id alone or product_id alone, so both depend on the whole key.
preorder_item (preorder_id, product_id): quantity and unit_price describe a specific product within a specific preorder, so they depend on the full key.

All other tables have single-column surrogate keys, so no other partial dependencies exist.

3NF: There are no transitive dependencies

Every non-key column depends on the key:

market, vendor, product, customer: name, address, email, and category each describe only the entity identified by the primary key. For example, category is a plain attribute of the product, not something determined by another non-key column.
preorder: customer_id, market_id, status, and placed_at are all facts about the preorder itself. Customer details and market details are stored in their own tables and referenced by foreign key, not copied here.