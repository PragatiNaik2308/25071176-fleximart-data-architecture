# FlexiMart Database Schema Documentation

## Section 1. Entity–Relationship Description

### ENTITY: customers
**Purpose:**  
Stores customer personal and registration information.

**Attributes:**
- `customer_id` (Primary Key): Unique surrogate identifier for each customer
- `first_name`: Customer’s first name
- `last_name`: Customer’s last name
- `email`: Unique email address used for communication and identification
- `phone`: Customer contact number in standardized format
- `city`: City where the customer resides
- `registration_date`: Date when the customer registered on the platform

**Relationships:**
- One customer can place **many orders**  
  (1 : M relationship with `orders` table)

---

### ENTITY: products
**Purpose:**  
Stores information about products available for sale.

**Attributes:**
- `product_id` (Primary Key): Unique surrogate identifier for each product
- `product_name`: Name of the product
- `category`: Product category (e.g., Electronics, Fashion, Groceries)
- `price`: Unit price of the product
- `stock_quantity`: Quantity available in inventory

**Relationships:**
- One product can appear in **many order items**  
  (1 : M relationship with `order_items` table)

---

### ENTITY: orders
**Purpose:**  
Stores order-level transactional information.

**Attributes:**
- `order_id` (Primary Key): Unique identifier for each order
- `customer_id` (Foreign Key): References `customers.customer_id`
- `order_date`: Date when the order was placed
- `total_amount`: Total value of the order
- `status`: Order status (Completed, Pending, Cancelled)

**Relationships:**
- One order belongs to **one customer**
  (1 : 1 relationship with `customers` table)
- One order contains **many order items**
  (1 : M relationship with `order_items` table)

---

### ENTITY: order_items
**Purpose:**  
Stores line-level details for each product in an order.

**Attributes:**
- `order_item_id` (Primary Key): Unique identifier for each order line
- `order_id` (Foreign Key): References `orders.order_id`
- `product_id` (Foreign Key): References `products.product_id`
- `quantity`: Number of units ordered
- `unit_price`: Price per unit at time of purchase
- `subtotal`: Calculated as quantity × unit_price

**Relationships:**
- Many order items belong to **one order**
  (M : 1 relationship with `orders` table)
- Many order items reference **one product**
  (M : 1 relationship with `products` table)

-----------------------------------------------------------------------------

## Section 2. Normalization Explanation

### Why Design Is In Third Normal Form – 3NF
- The FlexiMart database schema is designed in **Third Normal Form (3NF)** to ensure data 
  integrity, minimize redundancy, and avoid data anomalies.

- First, the **schema satisfies First Normal Form (1NF)** because all tables contain atomic values, 
  there are no multivalued attributes, and no repeating groups exist. Each column stores a single, indivisible value, and each record can be uniquely identified using a primary key.

- Second, the **schema satisfies Second Normal Form (2NF)** because it is already in 1NF and all 
  non-key attributes are fully functionally dependent on the entire primary key. Since surrogate primary keys are used in each table, there are no partial dependencies on composite keys. For example, customer details depend only on customer_id, and product attributes depend only on product_id.

- Third, the **schema satisfies Third Normal Form (3NF)** because there are no transitive  
  dependencies between non-primary key attributes. Each non-key attribute depends only on the primary key and not on another non-key attribute. For example, customer contact details are stored only in the customers table and are not duplicated in orders.

- By eliminating redundancy, the design avoids update anomalies, insert anomalies, and delete. 
  This normalized structure supports scalable transaction processing, accurate reporting, and  
  efficient ETL operations, making it suitable for both operational and analytical workloads.

---

### Functional Dependencies
- `customer_id → first_name, last_name, email, phone, city, registration_date`
- `product_id → product_name, category, price, stock_quantity`
- `order_id → customer_id, order_date, total_amount, status`
- `order_item_id → order_id, product_id, quantity, unit_price, subtotal`

Each non-key attribute depends **only on the primary key** of its table and not on other non-key attributes.

---

### Elimination of Anomalies
- **Insert Anomaly:**  
  New customers or products can be added independently without requiring orders.
- **Update Anomaly:**  
  Customer details (e.g., email or phone) are stored once in the `customers` table, which can be updated whenever needed avoiding inconsistent updates across multiple records.
- **Delete Anomaly:**  
  Deleting an order does not remove customer or product information.

-----------------------------------------------------------------------------

## Section 3. Sample Data Representation

### customers

| customer_id | first_name | last_name | email                    | phone           | city      | registration_date |
|-------------|------------|-----------|--------------------------|-----------------|-----------|-------------------|
|      1      |    Rahul   |  Sharma   | rahul.sharma@gmail.com   | +91-9876543210  | Bangalore | 2023-01-15        |
|      2      |    Priya   |  Patel    | priya.patel@yahoo.com    | +91-9988776655  | Mumbai    | 2023-02-20        |
|      3      |    Amit    |  Kumar    | unknown_C003@example.com | +91-9765432109  | Delhi     | 2023-03-10        |

---

### products

| product_id | product_name       | category    | price    | stock_quantity |
|------------|--------------------|-------------|----------|----------------|
|      1     | Samsung Galaxy S21 | Electronics | 45999.00 |      150       |
|      2     | Nike Running Shoes | Fashion     | 3499.00  |       80       |
|      3     | Apple MacBook Pro  | Electronics | 2999.00  |       45       |

---

### orders

| order_id | customer_id | order_date | total_amount | status    |
|----------|-------------|------------|--------------|-----------|
|    1     |      1      | 2024-01-15 |   45999.00   | Completed |
|    2     |      2      | 2024-01-16 |   5998.00    | Completed |
|    3     |      3      | 2024-01-15 |   52999.00   | Completed |

---

### order_items

| order_item_id | order_id | product_id | quantity | unit_price | subtotal |
|---------------|----------|------------|----------|------------|----------|
|       1       |    1     |     1      |    1     |  45999.00  | 45999.0  |
|       2       |    2     |     4      |    2     |  2999.00   | 5998.0   |
|       3       |    3     |     7      |    1     |  52999.00  | 52999.00 |

-----------------------------------------------------------------------------
