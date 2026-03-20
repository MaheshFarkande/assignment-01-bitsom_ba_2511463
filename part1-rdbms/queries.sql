-- Q1: List all customers from Mumbai along with their total order value
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_city,
    COALESCE(SUM(oi.quantity * oi.unit_price_at_order), 0) AS total_order_value
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
LEFT JOIN order_items oi
    ON oi.order_id = o.order_id
WHERE c.customer_city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name, c.customer_city
ORDER BY total_order_value DESC, c.customer_name;

-- Q2: Find the top 3 products by total quantity sold
SELECT TOP 3
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_qty_sold
FROM products p
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_qty_sold DESC, p.product_id;


-- Q3: List all sales representatives and the number of unique customers they have handled
SELECT
    sr.sales_rep_id,
    sr.sales_rep_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers_handled
FROM sales_reps sr
LEFT JOIN orders o
    ON o.sales_rep_id = sr.sales_rep_id
GROUP BY sr.sales_rep_id, sr.sales_rep_name
ORDER BY unique_customers_handled DESC, sr.sales_rep_name;

-- Q4: Find all orders where the total value exceeds 10,000, sorted by value descending
SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.sales_rep_id,
    SUM(oi.quantity * oi.unit_price_at_order) AS order_total_value
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_date, o.customer_id, o.sales_rep_id
HAVING SUM(oi.quantity * oi.unit_price_at_order) > 10000
ORDER BY order_total_value DESC, o.order_id;


-- Q5: Identify any products that have never been ordered
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM products p
LEFT JOIN order_items oi
    ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL
ORDER BY p.product_id;
