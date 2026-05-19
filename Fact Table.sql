-- Create gold schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold')
END;
GO

-- Pre-calculate metrics and create a persistent Fact Table
-- This demonstrates performance optimization by pre-joining staging assets
IF OBJECT_ID('gold.fact_orders', 'U') IS NOT NULL DROP TABLE gold.fact_orders;

SELECT 
    o.order_id,
    o.customer_id, -- Maps to gold.dim_customers
    o.product_id,  -- Maps to gold.dim_products
    CAST(o.order_timestamp AS DATE) AS order_date_key, -- Maps to gold.dim_date (Standard practice)
    o.quantity,
    (o.quantity * p.price) AS total_amount, -- Pre-calculated metric
    o.order_timestamp
INTO gold.fact_orders
FROM silver.orders o
JOIN silver.products p ON o.product_id = p.product_id;
GO
