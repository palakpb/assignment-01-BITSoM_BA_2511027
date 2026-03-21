-- Q1: List all customers along with the total number of orders they have placed
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM read_csv('customers.csv', header=True) AS c
LEFT JOIN read_json_auto('orders.json') AS o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- Q2: Find the top 3 customers by total order value
SELECT c.name, SUM(o.total_amount) AS total_order_value
FROM read_csv('customers.csv', header=True) AS cduckdb -c ".read part5-datalake/duckdb_queries.sql"
JOIN read_json_auto('orders.json') AS o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_order_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
-- Note: This assumes 'product_id' exists in 'orders.json' to link with the parquet file
SELECT DISTINCT p.product_name
FROM read_parquet('products.parquet') AS p
JOIN read_json_auto('orders.json') AS o ON p.product_id = o.product_id
JOIN read_csv('customers.csv', header=True) AS c ON o.customer_id = c.customer_id
WHERE c.city = 'Bangalore';

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT 
    c.name AS customer_name, 
    o.order_date, 
    p.product_name, 
    o.num_items AS quantity
FROM read_csv('customers.csv', header=True) AS c
JOIN read_json_auto('orders.json') AS o ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p ON o.product_id = p.product_id;
