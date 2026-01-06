# NoSQL Justification Report

## Section A: Limitations of RDBMS (Relational Databases)

### why the current relational database would struggle with:
**1. Products having different attributes (e.g., laptops have RAM/processor, shoes have size/color):** 
Relational databases like MySQL or PostgreSQL use fixed schemas and structured tables, making them less suitable for highly dynamic data models. In FlexiMart, different products require different fields, for example RAM, processor, and storage for laptops, size and color for shoes. Modeling this in an RDBMS leads to many nullable columns or multiple subtype tables, increasing complexity and making queries harder to manage.

**2. Frequent schema changes when adding new product types**
Frequent schema changes in relational databases are costly and time-consuming. Adding new product types or attributes requires altering tables, migrating data, and updating applicationn logic, which can lock tables, impact performance, and increase risks, reducing agility for evolving business needs.

**3. Storing customer reviews as nested data**
Storing customer reviews as nested data is inefficient in relational databases. Reviews require separate a separate tables with foreign keys, resulting in complex joins for data retrieval. As review volume grows, queries become slower and harder to maintain. RDBMS are optimized for structured, tabular data, not hierarchical or nested  data relationships.

---

## Section B: Benefits of NoSQL (MongoDB)

###  how MongoDB solves:
**1. Flexible schema (document structure)**
MongoDB addresses these challenges using a flexible, document-based schema where each product is stored as a JSON-like document. Different products can have different attributes, such as RAM and processor for laptops or size and color for shoes, within the same collection. This eliminates the need for numerous nullable columns or complex subtype table structures and allows new product types to be added without modifying the existing database schema.

**2. Embedded documents (reviews within products)**
MongoDB also supports embedded documents, which makes it well-suited for handling nested data such as customer reviews. Customer reviews can be stored directly inside the product document as an array of sub-documents, enabling faster reads and simpler queries without expensive joins. It also preserves the natural hierarchical relationship between products and their reviews. This structure closely matches real-world data access patterns.

**3. Horizontal scalability**
MongoDB also supports horizontal scalability through sharding. As the product catalog and review data grow, data can be distributed across multiple servers, improving performance and availability. This makes MongoDB highly scalable and adaptable for large, evolving product catalogs like FlexiMart.

---

## Section C: Trade-offs of Using MongoDB

### Two disadvantages of using MongoDB instead of MySQL for this product catalog are:
**1. Weaker transactional guarantees for complex operations compared to MySQL**
While MongoDB supports transactions, they are more resource-intensive and less mature than ACID-compliant transactions in MySQL. For scenarios involving multiple related updates, MySQL provides stronger consistency and simpler transaction management. This makes relational databases more reliable for critical financial and inventory-related operations.

**2. Risk of data inconsistency due to flexible schema**
Another trade-off is data inconsistency and reporting complexity. Without a fixed schema, enforcing validation requires additional application logic, and similar attributes may be stored in different formats, increasing data quality risks. In contrast, MySQL enforces a strict schema and simpler SQL-based reporting.

---

