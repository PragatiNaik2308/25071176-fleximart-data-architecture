# FlexiMart Data Architecture Project

**Student Name:** Pragati Naik
**Student ID:** bitsom_ba_25071176
**Email:** pragati.naik143@gmail.com
**Date:** 8 Jan 2026

---

## Project Overview

The FlexiMart Data Architecture Project demonstrates an end-to-end data solution covering **transactional databases, NoSQL systems, and data warehousing with analytics**. The project includes building an ETL pipeline, evaluating MongoDB for a flexible product catalog, and designing a star-schema-based data warehouse to support OLAP reporting and business intelligence use cases.

---

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

---

## Technologies Used

- **Programming:** Python 3.14.2
- **Libraries:** pandas, sqlalchemy, psycopg2-binary  
- **Relational Databases:** PostgreSQL 17  
- **NoSQL Database:** MongoDB 8.2.3 
- **Query Languages:** SQL, MongoDB Query Language 

---

## Setup Instructions

### Database Setup (PostgreSQL)

# Step 1: Create Databases 
psql -U postgres -c "CREATE DATABASE fleximart;"
psql -U postgres -c "CREATE DATABASE fleximart_dw;"

# Step 2: Run Part 1 – ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Step 3: Run Part 1 - Business Queries
psql -U postgres -d fleximart -f part1-database-etl/business_queries.sql

# Step 4: Run Part 3 - Create Data Warehouse Schemas
psql -U postgres -d fleximart_dw -f part3-datawarehouse/warehouse_schema.sql

# Step 5: Load Data Warehouse Tables
psql -U postgres -d fleximart_dw -f part3-datawarehouse/warehouse_data.sql

# Step 6: Run OLAP Analytics Queries
psql -U postgres -d fleximart_dw -f part3-datawarehouse/analytics_queries.sql

### MongoDB Setup

mongosh < part2-nosql/mongodb_operations.js

---

## Key Learnings

- Gained hands-on experience in designing and implementing ETL pipelines for structured transactional data.

- Understood when and why NoSQL databases (MongoDB) are suitable for flexible and evolving data models.

- Learned dimensional modeling concepts such as star schema, surrogate keys, and fact/dimension separation.

- Developed analytical SQL queries to perform drill-down, roll-up, product performance, and customer segmentation analysis.

---

## Challenges Faced

**1. Handling schema flexibility vs consistency**
**Solution:** Used MongoDB for dynamic product attributes while maintaining structured schemas in relational databases.

**2. Foreign key violations during data warehouse loading**
**Solution:** Ensured dimension tables were populated first and aligned all fact records with valid surrogate keys.

**3. Designing realistic analytical data**
**Solution:** Introduced weekend-heavy sales patterns, varied pricing, and diverse customer segments to better simulate real-world scenarios.


