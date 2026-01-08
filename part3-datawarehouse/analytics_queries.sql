-- Query 1: Monthly Sales Drill-Down
-- Business Scenario: The CEO wants to see sales performance broken down by time periods. Start with yearly total, then quarterly, then monthly sales for 2024.
-- Demonstrates: Drill-down from Year to Quarter to Month

SELECT 
	dim_date.year,
	dim_date.quarter,
	dim_date.month_name,
	SUM(fact_sales.total_amount) AS total_sales,
	SUM(fact_sales.quantity_sold) AS total_quantity 
FROM fact_sales
JOIN dim_date
	ON fact_sales.date_key = dim_date.date_key
WHERE dim_date.year = 2024
GROUP BY 
	dim_date.year,
	dim_date.quarter,
	dim_date.month,
	dim_date.month_name
ORDER BY 
	dim_date.year,
	dim_date.quarter,
	dim_date.month;

-----------------------------------------------------------------------------------------

-- Query 2: Top 10 Products by Revenue
-- Business Scenario: The product manager needs to identify top-performing products. Show the top 10 products by revenue, along with their category, total units sold, and revenue contribution percentage.
-- Includes: Revenue percentage calculation

SELECT 
	dim_product.product_name,
	dim_product.category,
	SUM(fact_sales.quantity_sold) AS units_sold ,
	SUM(fact_sales.total_amount) AS revenue ,
	ROUND(
        SUM(fact_sales.total_amount) * 100.0 /
        SUM(SUM(fact_sales.total_amount)) OVER (),
        2
    ) AS revenue_percentage
FROM fact_sales
JOIN dim_product
	ON fact_sales.product_key = dim_product.product_key
GROUP BY dim_product.category, dim_product.product_name
ORDER BY revenue DESC
LIMIT 10;

-----------------------------------------------------------------------------------------

-- Query 3: Customer Segmentation
-- Business Scenario: Marketing wants to target high-value customers. Segment customers into 'High Value' (>₹50,000 spent), 'Medium Value' (₹20,000-₹50,000), and 'Low Value' (<₹20,000). Show count of customers and total revenue in each segment.
-- Segments: High/Medium/Low value customers

WITH customer_spending AS (
    SELECT
        SUM(fact_sales.total_amount) AS total_spending,
		dim_customer.customer_key
    FROM fact_sales
	JOIN dim_customer
	ON fact_sales.customer_key = dim_customer.customer_key
	GROUP BY dim_customer.customer_key
)
SELECT 
	CASE
		WHEN total_spending > 50000 THEN 'High Value'
		WHEN total_spending BETWEEN 20000 AND 50000  THEN 'Medium Value'
		ELSE 'Low Value'
	END AS customer_segment,
	COUNT(*) AS customer_count,
	SUM(total_spending) AS total_revenue,
	ROUND(AVG(total_spending),2) AS avg_revenue
FROM 
	customer_spending
GROUP BY 
	customer_segment;

-----------------------------------------------------------------------------------------
