# Part 2 - NoSQL Database Analysis

## Overview

This part focuses on evaluating the suitability of **MongoDB** for managing FlexiMart’s highly diverse and evolving product catalog. As FlexiMart plans to expand into multiple product categories with varying attributes and nested data such as customer reviews, this part analyzes the limitations of traditional relational databases and demonstrates how a NoSQL database can better address these challenges.

---

## Components

### 1: NoSQL Justification Report

**File:** `nosql_analysis.md`

This document provides a theoretical comparison between SQL/relational databases (like MySQL/PostgreSQL) and NOSQL databases (like MongoDB).

#### Sections Covered

- **Section A: Limitations of RDBMS**
  - Difficulty handling products with different attributes
  - High cost of frequent schema changes
  - Inefficiency in storing and querying nested data like reviews

- **Section B: NoSQL Benefits**
  - Flexible document-based schema
  - Embedded documents for reviews within products
  - Horizontal scalability using sharding

- **Section C: Trade-offs of using MongoDB instead of MySQL**
  - Weaker transactional guarantees for complex operations
  - Risk of data inconsistency due to schema flexibility

---

### 2: MongoDB Implementation

**Files:**
- `products_catalog.json`
- `mongodb_operations.js`

#### Implemented Operations

1. **Load Data:** Load product data into the `products` collection  
2. **Basic Query:** Query electronics products priced below 50,000  
3. **Review Analysis:** Query products having average rating >= 4.0 by calculate average product ratings using aggregation  
4. **Update Operation:** Add a new review to an existing product  
5. **Complex Aggregation:** Perform category-wise price analysis with sorting  

All operations are written using MongoDB Query Language and Aggregation Framework with clear comments for readability.

---

## Tools & Technologies

- **Database:** MongoDB  
- **Interface:** MongoDB Compass / MongoDB Shell  
- **Data Format:** JSON  
- **Language:** JavaScript (MongoDB queries)

---

## Learning Outcomes

- Strong understanding of NoSQL concepts and use cases
- Practical experience with MongoDB queries and aggregations
- Ability to model flexible and nested data structures
- Clear comparison of NoSQL and relational database trade-offs

---

This completes **Part 2: NoSQL Database Analysis** for the FlexiMart system.
