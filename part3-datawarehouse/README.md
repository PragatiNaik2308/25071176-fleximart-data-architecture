# Part 3 - Data Warehouse and Analytics

## Project Overview
The objective is to design a **star schema**, populate it with realistic data, and perform **OLAP analytics** to analyze historical sales patterns.

The solution demonstrates practical knowledge of:
- Dimensional modeling
- Star schema design
- Data warehousing concepts
- Analytical SQL queries for business reporting

---

## Components

### 1: Star Schema Design Documentation

**File:** `star_schema_design.md`

This document explains the conceptual and logical design of the data warehouse using a star schema approach.The data warehouse follows a **star schema** with one central fact table and three dimension tables.

#### Sections Covered

- **Section 1: Schema Overview**
  - Fact table: `fact_sales` with transaction line-item grain
  - Dimension tables: `dim_date`, `dim_product`, `dim_customer`
  - Measures such as quantity sold, unit price, discount, and total amount
  - Foreign key relationships between fact and dimensions

- **Section 2: Design Decisions**
  - Justification for transaction-level granularity
  - Use of surrogate keys instead of natural keys
  - Support for drill-down and roll-up analysis across time, product, and customer dimensions

- **Section 3: Sample Data Flow**
  - Demonstrates how a source sales transaction is transformed into fact and dimension records in the data warehouse

---

### 2: Star Schema Implementation

**Files:**
- `warehouse_schema.sql`
- `warehouse_data.sql`

#### Implementation Details

- Creates the data warehouse schema exactly as specified
- Loads realistic sample data:
  - 30 dates across January–February 2024
  - 15 products across 3 categories
  - 12 customers across 4 cities
  - 40 sales transactions with weekend-heavy patterns
- Ensures data integrity using primary and foreign key constraints

**Key Features:**
- Weekday and weekend dates included
- Product prices range from ₹100 to ₹100,000
- Weekend-heavy sales patterns
- No foreign key violations

---

### 3: OLAP Analytics Queries

**File:** `analytics_queries.sql`

#### Implemented Analytical Scenarios

1. **Monthly Sales Drill-Down Analysis**
   - Year → Quarter → Month sales breakdown
   - Displays total sales and total quantity
   - Demonstrates drill-down capability using date dimensions

2. **Product Performance Analysis**
   - Top 10 products by revenue
   - Includes category, units sold, revenue, and revenue contribution percentage
   - Uses aggregation and window functions

3. **Customer Segmentation Analysis**
   - Segments customers into High, Medium, and Low value groups
   - Calculates customer count, total revenue, and average revenue per customer
   - Uses CASE expressions and grouping logic

---

