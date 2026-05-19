-- Create bronze schema for raw ingestion if it doesn't exist
IF SCHEMA_ID('bronze') IS NULL
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA bronze';
END;
GO

-- Setup raw customers table with messy data for cleaning demonstration
IF OBJECT_ID('bronze.raw_customers', 'U') IS NOT NULL DROP TABLE bronze.raw_customers;
GO
CREATE TABLE bronze.raw_customers (
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    signup_date VARCHAR(50),
    ingestion_timestamp DATETIME DEFAULT GETDATE()
);

-- Insert raw data including duplicates and formatting issues
INSERT INTO bronze.raw_customers (customer_id, first_name, last_name, email, signup_date) VALUES
(8472, '  john ', 'doe', 'john.doe@gmail.com', '2025-01-15 08:30:00'),
(1928, 'Jane', 'Smith', 'jane.smith@yahoo.com', '2025-02-20 14:15:00'),
(8472, 'John', 'Doe', 'john.doe@gmail.com', '2025-01-15 08:30:00'), -- Duplicate
(3749, 'Bob', 'Johnson', 'BOB.JOHNSON@OUTLOOK.COM', '2025-03-01 11:00:00'),
(9210, 'Alice', 'Brown', 'alice.b@gmail.com', '2025-04-10 09:00:00'),
(5562, 'Michael', '  Wilson', 'm.wilson@corp.net', '2025-05-12 10:45:00'),
(2837, 'sarah', 'connor', 's.connor@sky.net', '2025-06-01 08:00:00'),
(1928, 'Jane', 'Smith', 'jane.smith@yahoo.com', '2025-02-20 14:15:00'), -- Duplicate
(4491, 'David', 'Miller', 'david.miller@example.com', '2025-07-20 16:30:00'),
(6723, 'Emily', 'Davis', 'emily.davis@gmail.com', '2025-08-15 12:00:00'),
(3104, 'Chris', 'Evans', 'c.evans@marvel.com', '2025-09-05 10:00:00'),
(5521, 'Robert', 'Downing', 'ironman@stark.com', '2025-10-12 11:30:00'),
(7782, 'Scarlett', '  Johansson', 'black.widow@avengers.org', '2025-11-20 09:15:00');

-- Setup raw products table
IF OBJECT_ID('bronze.raw_products', 'U') IS NOT NULL DROP TABLE bronze.raw_products;
CREATE TABLE bronze.raw_products (
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    ingestion_timestamp DATETIME DEFAULT GETDATE()
);

INSERT INTO bronze.raw_products (product_id, product_name, category, price) VALUES
(10293, 'Wireless Mouse', 'Electronics', 25.99),
(58372, ' Ergonomic Chair', 'Office', 199.99),
(39481, 'Water Bottle', ' Fitness ', 15.50),
(20485, 'Laptop Stand', 'Electronics', 45.00),
(88273, 'Mechanical Keyboard', 'Electronics', 89.99),
(47281, 'Desk Lamp', 'Office', 34.50),
(11293, 'Yoga Mat', 'Fitness', 22.00),
(99382, 'Noise Cancelling Headphones', 'Electronics', 249.99);

-- Setup raw orders table
IF OBJECT_ID('bronze.raw_orders', 'U') IS NOT NULL DROP TABLE bronze.raw_orders;
CREATE TABLE bronze.raw_orders (
    order_id INT,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_timestamp VARCHAR(50),
    ingestion_timestamp DATETIME DEFAULT GETDATE()
);

INSERT INTO bronze.raw_orders (order_id, customer_id, product_id, quantity, order_timestamp) VALUES
(77283, 8472, 10293, 2, '2026-05-10 10:00:00'),
(11928, 1928, 58372, 1, '2026-05-11 11:30:00'),
(33847, 8472, 39481, 1, '2026-05-12 15:45:00'),
(99281, 3749, 10293, 5, '2026-05-13 09:15:00'),
(44728, 9210, 20485, 1, '2026-05-14 14:00:00'),
(88271, 5562, 88273, 1, '2026-05-15 10:00:00'),
(22938, 2837, 11293, 2, '2026-05-16 11:00:00'),
(55612, 4491, 99382, 1, '2026-05-17 14:30:00'),
(12345, 6723, 10293, 1, '2026-05-18 09:00:00'),
(66723, 8472, 20485, 1, '2026-05-19 16:00:00'),
(10293, 3104, 11293, 1, '2026-05-20 10:00:00'),
(55837, 5521, 99382, 2, '2026-05-21 13:00:00'),
(99384, 7782, 88273, 1, '2026-05-22 15:30:00');
