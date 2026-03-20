-- Q1: Total sales revenue by product category for each month
SELECT
    d.year,
    d.month,
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    d.year, d.month, p.category
ORDER BY
    d.year, d.month, p.category;

-- Q2: Top 2 performing stores by total revenue


SELECT TOP 2
    s.store_key,
    s.store_name,
    s.store_city,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_store s
    ON f.store_key = s.store_key
GROUP BY
    s.store_key, s.store_name, s.store_city
ORDER BY
    total_revenue DESC;

	
WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        SUM(f.sales_amount) AS total_revenue
    FROM fact_sales f
    JOIN dim_date d
        ON f.date_key = d.date_key
    GROUP BY d.year, d.month
)
SELECT
    year,
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year, month) AS prev_month_revenue,
    total_revenue - LAG(total_revenue) OVER (ORDER BY year, month) AS mom_change
FROM monthly_sales
ORDER BY year, month;
