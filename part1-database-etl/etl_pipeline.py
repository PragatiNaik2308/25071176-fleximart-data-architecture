import pandas as pd
import re
from datetime import datetime
from sqlalchemy import create_engine, text
import logging
import os

# SETUP LOGGING
logging.basicConfig(
    filename="part1-database-etl/etl_pipeline.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# DATABASE CONFIG (POSTGRES)
engine = create_engine(
    "postgresql+psycopg2://postgres:Pragati23@localhost:5432/fleximart"
)


# HELPER FUNCTIONS
# Standardize phone numbers to +91-xxxxxxxxxx format
def standardize_phone(phone):
    if pd.isna(phone):
        return None
    phone = re.sub(r"\D", "", str(phone))  # Remove non-numeric characters
    phone = phone[-10:]  # Take last 10 digits
    return f"+91-{phone}"

# Standardize date formats to YYYY-MM-DD
def parse_date(val):
    if pd.isna(val):
        return None
    for fmt in ("%Y-%m-%d", "%d/%m/%Y", "%m-%d-%Y", "%m/%d/%Y", "%d-%m-%Y"):
        try:
            return datetime.strptime(str(val), fmt).date()
        except ValueError:
            continue
    return None

# Standardize product category names
def normalize_category(cat):
    if pd.isna(cat):
        return "Unknown"
    return cat.strip().title()


# DATA QUALITY REPORT VALUES
report = {
    "Number of records processed in Customers": 0,
    "Number of duplicates removed in Customers": 0,
    "Number of missing values handled in Customers": 0,
    "Number of records loaded successfully in Customer table": 0,
    "Number of records processed in Products": 0,
    "Number of duplicates removed in Products": 0,
    "Number of missing values handled in Products": 0,
    "Number of records loaded successfully in Products table": 0,
    "Number of records processed in Sales": 0,
    "Number of duplicates removed in Sales": 0,
    "Number of missing values handled in Sales": 0,
    "Number of records loaded successfully in Orders table": 0,
    "Number of records loaded successfully in order_items table": 0
}

# EXTRACT
try:
    customers = pd.read_csv("data/customers_raw.csv")
    products = pd.read_csv("data/products_raw.csv")
    sales = pd.read_csv("data/sales_raw.csv")
    logging.info("CSV files loaded successfully.")
except Exception as e:
    logging.error(f"Error while loading CSV files: {e}")
    raise

# TRANSFORM - CUSTOMERS
try:
    initial_count = len(customers)
    report["Number of records processed in Customers"] = len(customers)

    customers = customers.drop_duplicates(subset=["customer_id"])
    report["Number of duplicates removed in Customers"] = initial_count - len(customers)

    # Handle missing emails
    missing_email_count = customers["email"].isna().sum()
    report["Number of missing values handled in Customers"] = missing_email_count
    customers["email"] = customers.apply(
        lambda x: f"unknown_{x['customer_id']}@example.com" if pd.isna(x["email"]) else x["email"],
        axis=1
    )

    customers["phone"] = customers["phone"].apply(standardize_phone)
    customers["city"] = customers["city"].str.title()
    customers["registration_date"] = customers["registration_date"].apply(parse_date)

    customers_clean = customers[
        ["customer_id", "first_name", "last_name", "email", "phone", "city", "registration_date"]
    ]

    logging.info(f"Customers transformed: {len(customers_clean)} records processed.")
except Exception as e:
    logging.error(f"Error  while transforming customers: {e}")
    raise

# TRANSFORM - PRODUCTS
try:
    initial_count = len(products)
    report["Number of records processed in Products"] = len(products)

    products = products.drop_duplicates(subset=["product_id"])
    report["Number of duplicates removed in Products"] = initial_count - len(products)

    products["category"] = products["category"].apply(normalize_category)

    missing_price_count = products["price"].isna().sum()
    products["price"] = products["price"].fillna(products["price"].median())
    
    missing_stock_quantity_count = products["stock_quantity"].isna().sum()
    products["stock_quantity"] = products["stock_quantity"].fillna(0)

    report["Number of missing values handled in Products"] = missing_price_count + missing_stock_quantity_count

    products_clean = products[
        ["product_id", "product_name", "category", "price", "stock_quantity"]
    ]

    logging.info(f"Products transformed: {len(products_clean)} records processed.")
except Exception as e:
    logging.error(f"Error transforming products: {e}")
    raise

# TRANSFORM - SALES
try:
    initial_count = len(sales)
    report["Number of records processed in Sales"] = len(sales)

    sales = sales.drop_duplicates(subset=["transaction_id"])
    report["Number of duplicates removed in Sales"] = initial_count - len(sales)

    missing_customer_ids_count = sales["customer_id"].isna().sum()
    missing_product_ids_count = sales["product_id"].isna().sum()
    report["Number of missing values handled in Sales"] = missing_customer_ids_count + missing_product_ids_count

    sales = sales.dropna(subset=["customer_id", "product_id"])
    sales["transaction_date"] = sales["transaction_date"].apply(parse_date)

    logging.info(f"Sales transformed: {len(sales)} records processed.")
except Exception as e:
    logging.error(f"Error transforming sales: {e}")
    raise

# LOAD - CUSTOMERS
try:
    customers_clean.drop(columns=["customer_id"]).to_sql(
        "customers", engine, if_exists="append", index=False
    )
    report["Number of records loaded successfully in Customer table"] = len(customers_clean)
    logging.info(f"Customers loaded: {len(customers_clean)}")
   
except Exception as e:
    logging.error(f"Error while loading customers: {e}")
    raise

# LOAD - PRODUCTS
try:
    products_clean.drop(columns=["product_id"]).to_sql(
        "products", engine, if_exists="append", index=False
    )
    report["Number of records loaded successfully in Products table"] = len(products_clean)
    logging.info(f"Products loaded: {len(products_clean)}")

except Exception as e:
    logging.error(f"Error while loading products: {e}")
    raise

# BUILD SURROGATE KEY MAPS
customer_map = pd.read_sql("SELECT customer_id, email FROM customers", engine)
product_map = pd.read_sql("SELECT product_id, product_name FROM products", engine)

# LOAD - ORDERS & ORDER_ITEMS
try:
    with engine.begin() as conn:
        orders_count = 0
        order_items_count = 0

        for _, row in sales.iterrows():
            # Map customer
            email = customers.loc[customers["customer_id"] == row.customer_id, "email"].values[0]
            cust_row = customer_map[customer_map["email"] == email]
            if cust_row.empty:
                continue
            customer_id = int(cust_row.iloc[0]["customer_id"])

            # Insert order
            order_result = conn.execute(
                text("""
                    INSERT INTO orders (customer_id, order_date, total_amount, status)
                    VALUES (:customer_id, :order_date, :total_amount, :status)
                    RETURNING order_id
                """),
                {
                    "customer_id": customer_id,
                    "order_date": row.transaction_date,
                    "total_amount": row.quantity * row.unit_price,
                    "status": row.status
                }
            )
            order_id = order_result.scalar()
            orders_count += 1

            # Map product
            product_name = products.loc[products["product_id"] == row.product_id, "product_name"].values[0]
            prod_row = product_map[product_map["product_name"] == product_name]
            if prod_row.empty:
                continue
            product_id = int(prod_row.iloc[0]["product_id"])

            # Insert order item
            conn.execute(
                text("""
                    INSERT INTO order_items
                    (order_id, product_id, quantity, unit_price, subtotal)
                    VALUES (:order_id, :product_id, :quantity, :unit_price, :subtotal)
                """),
                {
                    "order_id": order_id,
                    "product_id": product_id,
                    "quantity": row.quantity,
                    "unit_price": row.unit_price,
                    "subtotal": row.quantity * row.unit_price
                }
            )
            order_items_count += 1

    report["Number of records loaded successfully in Orders table"] = orders_count
    report["Number of records loaded successfully in order_items table"] = order_items_count
    logging.info(f"Orders loaded: {orders_count}, Order items loaded: {order_items_count}")

except Exception as e:
    logging.error(f"Error  while loading orders/order_items: {e}")
    raise

# WRITE DATA QUALITY REPORT
try:
    report_path = "part1-database-etl/data_quality_report.txt"
    with open(report_path, "w") as f:
        for key, value in report.items():
            f.write(f"{key}: {value}\n")
    logging.info(f"Data quality report generated at {os.path.abspath(report_path)}")
except Exception as e:
    logging.error(f"Error while writing data quality report: {e}")

print("PostgreSQL ETL Pipeline Completed Successfully")
