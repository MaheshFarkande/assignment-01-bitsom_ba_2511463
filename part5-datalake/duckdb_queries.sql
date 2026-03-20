
-- part5-datalake/duckdb_queries.sql
-- DuckDB cross-format queries (CSV + JSON + Parquet)
-- NOTE: Reads directly from raw files; no pre-loaded tables.

------------------------------------------------------------
-- Q1: List all customers along with the total number of orders they have placed
------------------------------------------------------------
SELECT
    c.customer_id,
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM read_csv_auto('customers.csv') AS c
LEFT JOIN read_json_auto('orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC, customer_name;

------------------------------------------------------------
-- Q2: Find the top 3 customers by total order value
------------------------------------------------------------
SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(o.total_amount) AS total_order_value
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_order_value DESC
LIMIT 3;

------------------------------------------------------------
-- Q3: List all products purchased by customers from Bangalore
-- ASSUMPTION: products.parquet includes order-level line items:
--   (order_id, product_id, product_name, quantity)
------------------------------------------------------------
SELECT DISTINCT
    p.product_id,
    p.product_name
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p
    ON o.order_id = p.order_id
WHERE c.city = 'Bangalore'
ORDER BY p.product_name;

------------------------------------------------------------
-- Q4: Join all three files to show:
--     customer name, order date, product name, and quantity
------------------------------------------------------------
SELECT
    c.name AS customer_name,
    o.order_date,
    p.product_name,
    p.quantity
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p
    ON o.order_id = p.order_id
ORDER BY o.order_date, customer_name, p.product_name;
