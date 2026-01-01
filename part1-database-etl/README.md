# Part 1 - FlexiMart Database Design and ETL Pipeline

## Overview

This project implements a **ETL pipeline** to clean, transform, and load raw customer, product, and sales data into a **PostgreSQL database**. It ensures data quality, generates a **data quality report**, and supports analytical queries to answer key business questions.

---

## Project Components

### 1. ETL Pipeline (`etl_pipeline.py`)

|          Step           |                                          Description                                                    |
|-----------------------------------------------------------------------------------------------------------------------------------|
| **Extract**             | - Reads `customers_raw.csv`, `products_raw.csv`, and `sales_raw.csv`. Logs success and errors.          |
| **Transform**           | - Removes duplicate records<br>- Handles missing values (default emails, median prices, null stock → 0)  <br>- Standardizes phone numbers (`+91-XXXXXXXXXX`)<br>- Standardizes product category names<br>- Converts dates to `YYYY-MM-DD` 
format                                                                                                                              |
| **Load**                | - Inserts transformed data into tables: `customers`, `products`, `orders`, `order_items`<br>- Uses auto-increment surrogate keys<br>- Logs successful loading and errors                                                               |
| **Logging**             | All ETL steps and errors are logged in `etl_pipeline.log` inside `part1-database-etl/`                  |
| **Data Quality Report** | Generated as `data_quality_report.txt` detailing records processed, duplicates removed, missing values handled, and records loaded successfully                                                                                            |

---

### 2. Database Schema (`fleximart`)

| Table | Purpose | Key Attributes | Relationships |
|-------|---------|----------------|---------------|
| **customers** | Stores customer information | `customer_id` (PK), `first_name`, `last_name`, `email`, `phone`, `city`, `registration_date` | 1:M with `orders` |
| **products** | Stores product information | `product_id` (PK), `product_name`, `category`, `price`, `stock_quantity` | 1:M with `order_items` |
| **orders** | Stores customer orders | `order_id` (PK), `customer_id` (FK), `order_date`, `total_amount`, `status` | 1:1 with `customers`, 1:M with `order_items` |
| **order_items** | Stores product details per order | `order_item_id` (PK), `order_id` (FK), `product_id` (FK), `quantity`, `unit_price`, `subtotal` | M:1 with `orders`, M:1 with `products` |

**Normalization:**  
- Schema is in **Third Normal Form (3NF)** to avoid redundancy and anomalies.  
- Eliminates update, insert, and delete anomalies.  
- Surrogate keys ensure unique identification for all tables.

---

### 3. Data Quality Report (`data_quality_report.txt`)

- Tracks:
  - Number of records processed per file
  - Duplicates removed
  - Missing values handled
  - Records successfully loaded into each table

---

### 4. Business Queries (`business_queries.sql`)

| Query | Business Question | Output Columns |
|-------|-----------------|----------------|
| **Query 1: Customer Purchase History** | Expected to return customers with 2+ orders and >5000 spent | `customer_name`, `email`, `total_orders`, `total_spent` |
| **Query 2: Product Sales Analysis** | Expected to return categories with >10000 revenue | `category`, `num_products`, `total_quantity_sold`, `total_revenue` |
| **Query 3: Monthly Sales Trend** | Expected to show monthly and cumulative revenue for year 2024 | `month_name`, `total_orders`, `monthly_revenue`, `cumulative_revenue` |

---
