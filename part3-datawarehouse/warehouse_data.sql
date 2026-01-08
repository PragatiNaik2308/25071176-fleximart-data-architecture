-- Query 1: Insert in dim_date: 30 dates (January-February 2024)

INSERT into dim_date VALUES 
(20240101,'2024-01-01','Monday',1,1,'January','Q1',2024,false),
(20240102,'2024-01-02','Tuesday',2,1,'January','Q1',2024,false),
(20240103,'2024-01-03','Wednesday',3,1,'January','Q1',2024,false),
(20240104,'2024-01-04','Thursday',4,1,'January','Q1',2024,false),
(20240105,'2024-01-05','Friday',5,1,'January','Q1',2024,false),
(20240106,'2024-01-06','Saturday',6,1,'January','Q1',2024,true),
(20240107,'2024-01-07','Sunday',7,1,'January','Q1',2024,true),
(20240108,'2024-01-08','Monday',8,1,'January','Q1',2024,false),
(20240109,'2024-01-09','Tuesday',9,1,'January','Q1',2024,false),
(20240110,'2024-01-10','Wednesday',10,1,'January','Q1',2024,false),
(20240111,'2024-01-11','Thursday',11,1,'January','Q1',2024,false),
(20240112,'2024-01-12','Friday',12,1,'January','Q1',2024,false),
(20240113,'2024-01-13','Saturday',13,1,'January','Q1',2024,true),
(20240114,'2024-01-14','Sunday',14,1,'January','Q1',2024,true),
(20240115,'2024-01-15','Monday',15,1,'January','Q1',2024,false),
(20240201,'2024-02-01','Thursday',1,2,'February','Q1',2024,false),
(20240202,'2024-02-02','Friday',2,2,'February','Q1',2024,false),
(20240203,'2024-02-03','Saturday',3,2,'February','Q1',2024,true),
(20240204,'2024-02-04','Sunday',4,2,'February','Q1',2024,true),
(20240205,'2024-02-05','Monday',5,2,'February','Q1',2024,false),
(20240206,'2024-02-06','Tuesday',6,2,'February','Q1',2024,false),
(20240207,'2024-02-07','Wednesday',7,2,'February','Q1',2024,false),
(20240208,'2024-02-08','Thursday',8,2,'February','Q1',2024,false),
(20240209,'2024-02-09','Friday',9,2,'February','Q1',2024,false),
(20240210,'2024-02-10','Saturday',10,2,'February','Q1',2024,true),
(20240211,'2024-02-11','Sunday',11,2,'February','Q1',2024,true),
(20240212,'2024-02-12','Monday',12,2,'February','Q1',2024,false),
(20240213,'2024-02-13','Tuesday',13,2,'February','Q1',2024,false),
(20240214,'2024-02-14','Wednesday',14,2,'February','Q1',2024,false),
(20240215,'2024-02-15','Thursday',15,2,'February','Q1',2024,false);

-----------------------------------------------------------------------------------------

-- Query 2: Insert in dim_product: 15 products across 3 categories
INSERT INTO dim_product (product_id, product_name, category, subcategory, unit_price) VALUES
('ELEC001','Laptop','Electronics','Computers',65000),
('ELEC002','Smartphone','Electronics','Mobiles',30000),
('ELEC003','Headphones','Electronics','Accessories',3000),
('ELEC004','Tablet','Electronics','Tablets',25000),
('ELEC005','Smart Watch','Electronics','Wearables',15000),
('FASH001','T-Shirt','Fashion','Clothing',800),
('FASH002','Jeans','Fashion','Clothing',2000),
('FASH003','Shoes','Fashion','Footwear',3500),
('FASH004','Jacket','Fashion','Outerwear',5000),
('FASH005','Sunglasses','Fashion','Accessories',1200),
('HOME001','Mixer Grinder','Home','Kitchen',4500),
('HOME002','Sofa','Home','Furniture',45000),
('HOME003','Dining Table','Home','Furniture',60000),
('HOME004','Curtains','Home','Decor',1500),
('HOME005','Lamp','Home','Lighting',2200);

-----------------------------------------------------------------------------------------

-- Query 3: Insert in dim_customer: 12 customers across 4 cities
INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_segment) VALUES
('C001','Amit Sharma','Mumbai','Maharashtra','Retail'),
('C002','Neha Verma','Delhi','Delhi','Retail'),
('C003','Ravi Kumar','Bengaluru','Karnataka','Corporate'),
('C004','Pooja Singh','Chennai','Tamil Nadu','Retail'),
('C005','Rahul Mehta','Mumbai','Maharashtra','Corporate'),
('C006','Sneha Iyer','Chennai','Tamil Nadu','Retail'),
('C007','Ankit Jain','Delhi','Delhi','Retail'),
('C008','Vikram Rao','Bengaluru','Karnataka','Corporate'),
('C009','Kiran Patel','Mumbai','Maharashtra','Retail'),
('C010','Meena Das','Delhi','Delhi','Corporate'),
('C011','Arjun Nair','Bengaluru','Karnataka','Retail'),
('C012','Sonal Shah','Mumbai','Maharashtra','Retail');

-----------------------------------------------------------------------------------------

-- Query 4: Insert in fact_sales: 40 sales transactions
INSERT INTO fact_sales
(date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount) VALUES
(20240101, 2, 5, 1, 30000, 0, 30000),
(20240101, 5, 4, 1, 15000, 2000, 13000),
(20240102, 3, 6, 2, 3000, 200, 5800),
(20240103, 4, 7, 1, 25000, 0, 25000),
(20240114, 14, 2, 3, 1500, 0, 4500),
(20240105, 5, 8, 1, 15000, 500, 14500),
(20240106, 1, 1, 2, 65000, 5000, 125000),
(20240106, 2, 2, 1, 30000, 0, 30000),
(20240106, 3, 3, 3, 3000, 300, 8700),
(20240106, 1, 4, 1, 65000, 5000, 60000),
(20240107, 7, 10, 1, 2000, 0, 2000),
(20240108, 5, 8, 1, 15000, 500, 14500),
(20240109, 6, 6, 1, 800, 0, 800),
(20240110, 5, 8, 1, 15000, 500, 14500),
(20240113, 9, 9, 1, 5000, 500, 4500),
(20240113, 10, 10, 2, 1200, 0, 2400),
(20240113, 12, 12, 1, 45000, 5000, 40000),
(20240114, 13, 1, 1, 60000, 10000, 50000),
(20240115, 5, 8, 1, 15000, 500, 14500),
(20240115, 10, 12, 3, 1200, 0, 3600),
(20240203, 6, 9, 4, 800, 0, 3200),
(20240203, 7, 10, 2, 2000, 200, 3800),
(20240203, 8, 11, 1, 3500, 0, 3500),
(20240210, 15, 6, 3, 2200, 200, 6400),
(20240210, 1, 7, 1, 65000, 3000, 62000),
(20240210, 2, 8, 2, 30000, 2000, 58000),
(20240211, 3, 9, 5, 3000, 500, 14500),
(20240211, 4, 10, 1, 25000, 0, 25000),
(20240211, 5, 11, 3, 15000, 1500, 43500),
(20240201, 9, 3, 3, 5000, 0, 5000),
(20240202, 12, 9, 1, 45000, 3500, 42500),
(20240204, 13, 1, 1, 60000, 6000, 54000),
(20240205, 10, 5, 1, 1200, 0, 1200),
(20240205, 5, 11, 3, 15000, 1500, 43500),
(20240207, 5, 12, 1, 15000, 0, 15000),
(20240208, 8, 3, 2, 3500, 0, 7000),
(20240209, 12, 7, 1, 45000, 5000, 40000),
(20240212, 3, 9, 4, 3000, 400, 11600),
(20240213, 14, 2, 2, 1500, 0, 3000),
(20240215, 1, 10, 1, 65000, 3000, 62000);

-----------------------------------------------------------------------------------------
