
-- Drop order is important due to FK dependencies
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS sales_reps;
DROP TABLE IF EXISTS offices;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Customers are stored once (eliminates customer update anomalies)
CREATE TABLE customers (
    customer_id      VARCHAR(10)  PRIMARY KEY,
    customer_name    VARCHAR(100) NOT NULL,
    customer_email   VARCHAR(255) NOT NULL UNIQUE,
    customer_city    VARCHAR(100) NOT NULL
);

-- Products are stored once (eliminates product insert/delete anomalies)
CREATE TABLE products (
    product_id         VARCHAR(10)  PRIMARY KEY,
    product_name       VARCHAR(100) NOT NULL,
    category           VARCHAR(50)  NOT NULL,
    current_unit_price DECIMAL(10,2) NOT NULL 
);

-- Offices are stored once; sales reps reference an office (eliminates office address update anomalies)
CREATE TABLE offices (
    office_id      VARCHAR(10)  PRIMARY KEY,
    office_label   VARCHAR(100) NOT NULL,
    office_address VARCHAR(255) NOT NULL
);

-- Sales reps are stored once and reference offices
CREATE TABLE sales_reps (
    sales_rep_id    VARCHAR(10)  PRIMARY KEY,
    sales_rep_name  VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(255) NOT NULL UNIQUE,
    office_id       VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_salesreps_office
        FOREIGN KEY (office_id) REFERENCES offices(office_id)
);


-- Orders store only order-level facts and reference customer + sales rep
CREATE TABLE orders (
    order_id      VARCHAR(10) PRIMARY KEY,
    customer_id   VARCHAR(10) NOT NULL,
    sales_rep_id  VARCHAR(10) NOT NULL,
    order_date    DATE        NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_orders_salesrep
        FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- Order items store line-level facts (quantity + unit price captured at time of order)
CREATE TABLE order_items (
    order_id            VARCHAR(10) NOT NULL,
    product_id          VARCHAR(10) NOT NULL,
    quantity            INT         NOT NULL CHECK (quantity > 0),
    unit_price_at_order DECIMAL(10,2) NOT NULL CHECK (unit_price_at_order >= 0),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

 

-- -------------------------
-- Seed data (>= 5 rows per table)
-- -------------------------

-- customers (all from orders_flat.csv)
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001','Rohan Mehta','rohan@gmail.com','Mumbai'),
('C002','Priya Sharma','priya@gmail.com','Delhi'),
('C003','Amit Verma','amit@gmail.com','Bangalore'),
('C004','Sneha Iyer','sneha@gmail.com','Chennai'),
('C005','Vikram Singh','vikram@gmail.com','Mumbai');

-- products (all from orders_flat.csv)
INSERT INTO products (product_id, product_name, category, current_unit_price) VALUES
('P001','Laptop','Electronics',55000.00),
('P002','Mouse','Electronics',800.00),
('P003','Desk Chair','Furniture',8500.00),
('P004','Notebook','Stationery',120.00),
('P005','Headphones','Electronics',3200.00),
('P007','Pen Set','Stationery',250.00);

-- offices (first 3 from orders_flat.csv; last 2 are SAMPLE_NOT_IN_CSV)
INSERT INTO offices (office_id, office_label, office_address) VALUES
('OFF1','Delhi Office','Delhi Office, Connaught Place, New Delhi - 110001'),
('OFF2','Mumbai HQ','Mumbai HQ, Nariman Point, Mumbai - 400021'),
('OFF3','South Zone','South Zone, MG Road, Bangalore - 560001'),
('OFF4','SAMPLE_NOT_IN_CSV','Kolkata Office, Park Street, Kolkata - 700016'),
('OFF5','SAMPLE_NOT_IN_CSV','Pune Office, Hinjawadi, Pune - 411057');

-- sales_reps (first 3 from orders_flat.csv; last 2 are SAMPLE_NOT_IN_CSV)
INSERT INTO sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_id) VALUES
('SR01','Deepak Joshi','deepak@corp.com','OFF2'),
('SR02','Anita Desai','anita@corp.com','OFF1'),
('SR03','Ravi Kumar','ravi@corp.com','OFF3'),
('SR04','SAMPLE_NOT_IN_CSV','sre4@corp.com','OFF4'),
('SR05','SAMPLE_NOT_IN_CSV','sre5@corp.com','OFF5');

-- orders (all from orders_flat.csv)
INSERT INTO orders (order_id, customer_id, sales_rep_id, order_date) VALUES
('ORD1114','C001','SR01','2023-08-06'),
('ORD1002','C002','SR02','2023-01-17'),
('ORD1132','C003','SR02','2023-03-07'),
('ORD1075','C005','SR03','2023-04-18'),
('ORD1133','C001','SR03','2023-10-16');

-- order_items (all from orders_flat.csv)
INSERT INTO order_items (order_id, product_id, quantity, unit_price_at_order) VALUES
('ORD1114','P007',2,250.00),
('ORD1002','P005',1,3200.00),
('ORD1132','P007',5,250.00),
('ORD1075','P003',3,8500.00),
('ORD1133','P004',1,120.00);
