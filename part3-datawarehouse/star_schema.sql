-- part3-datawarehouse/star_schema.sql
-- Star schema for retail_transactions.csv with cleaned/standardized sample data

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_date (
    date_key      INT PRIMARY KEY,
    full_date     DATE NOT NULL,
    year          INT NOT NULL,
    quarter       INT NOT NULL,
    month         INT NOT NULL,
    day           INT NOT NULL,
    day_name      VARCHAR(10) NOT NULL
);

CREATE TABLE dim_store (
    store_key     INT PRIMARY KEY,
    store_name    VARCHAR(100) NOT NULL,
    store_city    VARCHAR(100) NOT NULL
);

CREATE TABLE dim_product (
    product_key   INT PRIMARY KEY,
    product_name  VARCHAR(100) NOT NULL,
    category      VARCHAR(20)  NOT NULL
);

CREATE TABLE fact_sales (
    sales_key      INT PRIMARY KEY,
    transaction_id VARCHAR(20) NOT NULL,
    date_key       INT NOT NULL,
    store_key      INT NOT NULL,
    product_key    INT NOT NULL,
    customer_id    VARCHAR(20) NOT NULL,
    units_sold     INT NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL,
    sales_amount   DECIMAL(14,2) NOT NULL,
    CONSTRAINT fk_fact_date    FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_store   FOREIGN KEY (store_key)   REFERENCES dim_store(store_key),
    CONSTRAINT fk_fact_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);

-- Insert cleaned dates (standardized to YYYY-MM-DD)
INSERT INTO dim_date (date_key, full_date, year, quarter, month, day, day_name) VALUES
(20230115, '2023-01-15', 2023, 1, 1, 15, 'Sunday'),
(20230205, '2023-02-05', 2023, 1, 2, 5, 'Sunday'),
(20230220, '2023-02-20', 2023, 1, 2, 20, 'Monday'),
(20230331, '2023-03-31', 2023, 1, 3, 31, 'Friday'),
(20230809, '2023-08-09', 2023, 3, 8, 9, 'Wednesday'),
(20230815, '2023-08-15', 2023, 3, 8, 15, 'Tuesday'),
(20230829, '2023-08-29', 2023, 3, 8, 29, 'Tuesday'),
(20231026, '2023-10-26', 2023, 4, 10, 26, 'Thursday'),
(20231208, '2023-12-08', 2023, 4, 12, 8, 'Friday'),
(20231212, '2023-12-12', 2023, 4, 12, 12, 'Tuesday');

-- Insert stores (NULL/blank cities filled from other rows with same store_name)
INSERT INTO dim_store (store_key, store_name, store_city) VALUES
(1, 'Chennai Anna', 'Chennai'),
(2, 'Delhi South', 'Delhi'),
(3, 'Bangalore MG', 'Bangalore'),
(4, 'Pune FC Road', 'Pune');

-- Insert products (category casing standardized: Electronics / Clothing / Groceries)
INSERT INTO dim_product (product_key, product_name, category) VALUES
(1, 'Speaker', 'Electronics'),
(2, 'Tablet', 'Electronics'),
(3, 'Phone', 'Electronics'),
(4, 'Smartwatch', 'Electronics'),
(5, 'Atta 10kg', 'Groceries'),
(6, 'Jeans', 'Clothing'),
(7, 'Biscuits', 'Groceries');

-- Insert fact rows (>= 10) with cleaned values (dates normalized; category standardized; NULL cities filled)
INSERT INTO fact_sales (sales_key, transaction_id, date_key, store_key, product_key, customer_id, units_sold, unit_price, sales_amount) VALUES
(1, 'TXN5000', 20230829, 1, 1, 'CUST045', 3, 49262.78, 147788.34),
(2, 'TXN5001', 20231212, 1, 2, 'CUST021', 11, 23226.12, 255487.32),
(3, 'TXN5002', 20230205, 1, 3, 'CUST019', 20, 48703.39, 974067.80),
(4, 'TXN5003', 20230220, 2, 2, 'CUST007', 14, 23226.12, 325165.68),
(5, 'TXN5004', 20230115, 1, 4, 'CUST004', 10, 58851.01, 588510.10),
(6, 'TXN5005', 20230809, 3, 5, 'CUST027', 12, 52464.00, 629568.00),
(7, 'TXN5006', 20230331, 4, 4, 'CUST025', 6, 58851.01, 353106.06),
(8, 'TXN5007', 20231026, 4, 6, 'CUST041', 16, 2317.47, 37079.52),
(9, 'TXN5008', 20231208, 3, 7, 'CUST030', 9, 27469.99, 247229.91),
(10, 'TXN5009', 20230815, 3, 4, 'CUST020', 3, 58851.01, 176553.03);
