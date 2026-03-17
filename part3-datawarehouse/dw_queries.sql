-- Q1: Total sales revenue by product category for each month
SELECT d.month, p.category, SUM(f.total_revenue) as monthly_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY d.month, p.category;

-- Q2: Top 2 performing stores by total revenue
SELECT s.store_name, SUM(f.total_revenue) as store_revenue
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.store_name
ORDER BY store_revenue DESC
LIMIT 2;

-- Q3: Month-over-month sales trend across all stores
SELECT d.year, d.month, SUM(f.total_revenue) as total_monthly_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
