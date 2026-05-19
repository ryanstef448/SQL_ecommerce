-- Create silver schema for cleaned data if it doesn't exist
-- Note: VS Code may show an error on 'silver' schemas until this script is executed against your database.
IF SCHEMA_ID('silver') IS NULL
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA silver';
END;
GO

-- Clean and deduplicate customer data
IF OBJECT_ID('silver.customers', 'U') IS NOT NULL DROP TABLE silver.customers;
GO
WITH customer_clean AS (
    SELECT 
        customer_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        LOWER(TRIM(email)) AS email,
        CAST(signup_date AS DATETIME) AS signup_date,
        ingestion_timestamp,
        GETDATE() AS processed_timestamp,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY signup_date DESC, ingestion_timestamp DESC) as rn
    FROM bronze.raw_customers
)
SELECT 
    customer_id, 
    first_name, 
    last_name, 
    email, 
    signup_date, 
    ingestion_timestamp, 
    processed_timestamp
INTO silver.customers
FROM customer_clean
WHERE rn = 1;
GO

-- Clean and standardize product data
IF OBJECT_ID('silver.products', 'U') IS NOT NULL DROP TABLE silver.products;
GO
SELECT 
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    price,
    ingestion_timestamp,
    GETDATE() AS processed_timestamp
INTO silver.products
FROM bronze.raw_products
WHERE price > 0;
GO

-- Clean and cast order data types
IF OBJECT_ID('silver.orders', 'U') IS NOT NULL DROP TABLE silver.orders;
GO
SELECT 
    order_id,
    customer_id,
    product_id,
    quantity,
    CAST(order_timestamp AS DATETIME) AS order_timestamp,
    ingestion_timestamp,
    GETDATE() AS processed_timestamp
INTO silver.orders
FROM bronze.raw_orders
WHERE quantity > 0;
GO
