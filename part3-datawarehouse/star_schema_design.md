# Star Schema Design Documentation

## Section 1. Schema Overview

### FACT TABLE: fact_sales

**Grain:** One row per product per order line item

**Business Process:** Sales transactions

**Measures (Numeric Facts):**
- `quantity_sold`: Number of units sold
- `unit_price`: Price per unit at the time of sale
- `discount_amount`: Discount applied
- `total_amount`: Final sales amount (quantity × unit_price - discount)

**Foreign Keys:**
- `date_key` → `dim_date`
- `product_key` → `dim_product`
- `customer_key` → `dim_customer`

---

### DIMENSION TABLE: dim_date

**Purpose:** Supports Date dimension for time-based analysis.

**Type:** Conformed dimension

**Attributes:**
- `date_key` (PK): Surrogate key (integer, format: YYYYMMDD)
- `full_date`: Actual date
- `day_of_week`: Monday, Tuesday, etc.
- `day_of_month`: Day date
- `month`: 1–12
- `month_name`: January, February, etc.
- `quarter`: Q1, Q2, Q3, Q4
- `year`: 2023, 2024, etc.
- `is_weekend`: Boolean flag

---

### DIMENSION TABLE: dim_product

**Purpose:**  Stores descriptive information about products.

**Type:** Conformed dimension

**Attributes:**
- `product_key` (PK): Surrogate key (integer)
- `product_id`: Source system product identifier (product code)
- `product_name`: Name of the product
- `category`: Type of the product (Electronics, Fashion)
- `subcategory`: Sub type of the product (Mobile phones, laptop for the Electronics)
- `brand`: manufacturer or company name of the product
- `unit_price`: Cost of the per product
- `is_active`: Boolean flag. Indicates product availability in the inventory

---

### DIMENSION TABLE: dim_customer

**Purpose:** Stores customer demographic and location details.

**Type:** Conformed dimension

**Attributes:**
- `customer_key` (PK): Surrogate key (Integer)
- `customer_id`: Source system customer identifier
- `customer_name`: Name of customer
- `DOB`: Date of birth of customer (format: YYYYMMDD)
- `age`: Age of customer
- `email`: Email id of customer
- `phone`: Mobile number of customer (+91-XXXXXXXXXX)
- `city`: Shipping address 
- `state`: Shipping address
- `region`: Shipping address
- `customer_segment`: Type of customer (Retail, Corporate, Wholesale)

---

## Section 2. Design Decisions

**1. Why chose this granularity (transaction line-item level):**
The star schema is designed at the **transaction line-item level** to capture the most granular sales data. This granularity allows detailed analysis such as product-level sales, discount amount, customer age group analysis and brand of products prefered by customer and region of orders, while still supporting aggregation at higher levels like daily or monthly sales.

**2. Why surrogate keys instead of natural keys:**
Surrogate keys are used instead of natural keys because they are integers which ensure stability, improve join performance, and handle changes in source system identifiers. Surrogate keys also simplify slowly changing dimension management and avoid dependency on operational system keys.

**3. How this design supports drill-down and roll-up operations:**
This design enables efficient drill-down like Deminsion table dim_date (year => quarter => month => day => day of the week => transaction) and roll-up like Deminsion table dim_date (transaction => daily => monthly => yearly) operations. Analysts can easily slice data by product category, shipping address, or time period. The separation of facts and dimensions ensures simplicity, query performance, and scalability, making the schema suitable for long-term historical analysis and business intelligence reporting.

---

## Section 3. Sample Data Flow

### Example of how one transaction flows from source to data warehouse:
**Source Transaction:**
Order #101, Customer "John Doe", Product "Laptop", Qty: 2, Price: 50000

**Becomes in Data Warehouse:**
fact_sales: {
  date_key: 20240115,
  product_key: 5,
  customer_key: 12,
  quantity_sold: 2,
  unit_price: 50000,
  total_amount: 100000
}

dim_date: {
    date_key: 20240115,
    full_date: '2024-01-15',
    month: 1,
    quarter: 'Q1',
    day_of_week: 'Monday',
    day_of_month: 15,
    month_name: 'January',
    year: 2024,
    is_weekend: false
}

dim_product: {
    product_key: 5,
    product_id: 'ELC192',
    product_name: 'Laptop',
    category: 'Electronics',
    subcategory: 'Laptop',
    brand: 'Dell',
    unit_price: 50000,
    is_active: true
}

dim_customer: {
    customer_key: 12,
    customer_id: 'C1002',
    customer_name: 'John Doe',
    city: 'Mumbai',
    DOB: 1998-10-28,
    age: 27,
    email: 'john.doe@gmail.com',
    phone: +91-7893579207,
    state: 'Maharashtra',
    region: 'Western',
    customer_segment: 'Retail'
}




