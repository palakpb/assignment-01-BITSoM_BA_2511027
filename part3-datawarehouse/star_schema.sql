-- Create Dimension Tables
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    date_actual DATE NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL
);

CREATE TABLE dim_store (
    store_id VARCHAR(10) PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_city VARCHAR(50) NOT NULL
);

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);

-- Create Fact Table
CREATE TABLE fact_sales (
    transaction_id VARCHAR(10) PRIMARY KEY,
    date_key INT NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    units_sold INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    total_revenue DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Load Sample Dimension Data (Cleaned)
INSERT INTO dim_product VALUES ('P100', 'Speaker', 'Electronics'), ('P101', 'Tablet', 'Electronics'), ('P102', 'Phone', 'Electronics'), ('P104', 'Atta 10kg', 'Groceries'), ('P105', 'Jeans', 'Clothing');
INSERT INTO dim_store VALUES ('S100', 'Chennai Anna', 'Chennai'), ('S101', 'Delhi South', 'Delhi'), ('S102', 'Bangalore MG', 'Bangalore'), ('S103', 'Pune FC Road', 'Pune'), ('S104', 'Mumbai Central', 'Mumbai');
INSERT INTO dim_date VALUES (20230829, '2023-08-29', 8, 2023), (20231212, '2023-12-12', 12, 2023), (20230205, '2023-02-05', 2, 2023), (20230504, '2023-05-04', 5, 2023), (20230614, '2023-06-14', 6, 2023);

-- Load Sample Fact Data (Cleaned)
INSERT INTO fact_sales VALUES ('TXN5000', 20230829, 'S100', 'P100', 3, 49262.78, 147788.34);
INSERT INTO fact_sales VALUES ('TXN5102', 20230829, 'S104', 'P108', 13, 42343.15, 550460.95);
INSERT INTO fact_sales VALUES ('TXN5088', 20230829, 'S101', 'P105', 10, 2317.47, 23174.70);
INSERT INTO fact_sales VALUES ('TXN5258', 20230504, 'S100', 'P100', 10, 49262.78, 492627.80);
INSERT INTO fact_sales VALUES ('TXN5001', 20231212, 'S100', 'P101', 11, 23226.12, 255487.32);
INSERT INTO fact_sales VALUES ('TXN5038', 20230614, 'S100', 'P101', 3, 23226.12, 69678.36);
INSERT INTO fact_sales VALUES ('TXN5065', 20230608, 'S100', 'P101', 13, 23226.12, 301939.56);
INSERT INTO fact_sales VALUES ('TXN5080', 20230608, 'S104', 'P100', 12, 49262.78, 591153.36);
INSERT INTO fact_sales VALUES ('TXN5111', 20231105, 'S100', 'P101', 14, 23226.12, 325165.68);
INSERT INTO fact_sales VALUES ('TXN5123', 20231208, 'S100', 'P101', 11, 23226.12, 255487.32);
