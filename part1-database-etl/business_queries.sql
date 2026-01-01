-- Query 1: Customer Purchase History
-- Business Question: Generate a detailed report showing each customer's name, email, total number of orders placed, and total amount spent. Include only customers who have placed at least 2 orders and spent more than ₹5,000. Order by total amount spent in descending order.
-- Expected to return customers with 2+ orders and >5000 spent

SELECT 
    concat(customers.first_name, '', customers.last_name) AS customer_name, 
    email, 
    COUNT(DISTINCT orders.order_id) AS total_orders, 
    SUM(order_items.subtotal) AS total_spent
FROM customers 
JOIN orders 
    ON customers.customer_id = orders.customer_id
JOIN order_items 
    ON orders.order_id = order_items.order_id
GROUP BY 
    customers.customer_id
HAVING 
    COUNT(DISTINCT orders.order_id) >= 2 AND SUM(order_items.subtotal) > 5000
ORDER BY 
    total_spent DESC;

-----------------------------------------------------------------------------------------

-- Query 2: Product Sales Analysis
-- Business Question: For each product category, show the category name, number of different products sold, total quantity sold, and total revenue generated. Only include categories that have generated more than ₹10,000 in revenue. Order by total revenue descending.
-- Expected to return categories with >10000 revenue

SELECT 
	category, 
	COUNT(DISTINCT products.product_id) AS num_products, 
	SUM(order_items.quantity) AS total_quantity_sold, 
	SUM(order_items.subtotal) AS total_revenue
FROM 
	products 
JOIN order_items 
	ON products.product_id = order_items.product_id
GROUP BY 
	category
HAVING 
	SUM(order_items.subtotal) > 10000
ORDER BY 
	total_revenue DESC;

-----------------------------------------------------------------------------------------

-- Query 3: Monthly Sales Trend
-- Business Question: "Show monthly sales trends for the year 2024. For each month, display the month name, total number of orders, total revenue, and the running total of revenue (cumulative revenue from January to that month).
-- Expected to show monthly and cumulative revenue

--- NOTE:
--- I am using PostgreSQL database. 
----DATE_FORMAT() and MONTHNAME() exists in MySQL, does not exist in PostgreSQL.
--- PostgreSQL uses TO_CHAR(). 
--- So Iam using TO_CHAR() to extract month from date.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(total_amount) AS monthly_revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    TRIM(TO_CHAR(month, 'Month')) AS month_name,
    total_orders,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY month
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;

-----------------------------------------------------------------------------------------
