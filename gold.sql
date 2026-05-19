-- Create gold schema for analytics and reporting if it doesn't exist
IF SCHEMA_ID('gold') IS NULL
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA gold';
END;
GO

-- Create customer dimension view
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    signup_date
FROM silver.customers;
GO

-- Create product dimension view
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT 
    product_id,
    product_name,
    category,
    price
FROM silver.products;
GO

-- Note: gold.fact_orders is created as a persistent table in "Fact Table.sql" 
-- to demonstrate pre-calculated metrics for performance optimization.

-- Create customer behavior report (Executive Dashboard View)
IF OBJECT_ID('gold.report_customer_activity', 'V') IS NOT NULL DROP VIEW gold.report_customer_activity;
GO
CREATE VIEW gold.report_customer_activity AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(f.order_id) AS total_orders,
    SUM(f.total_amount) AS total_revenue,
    AVG(f.total_amount) AS avg_order_value,
    MAX(f.order_timestamp) AS last_order_date
FROM gold.dim_customers c
LEFT JOIN gold.fact_orders f ON c.customer_id = f.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
GO

-- Create category performance report
IF OBJECT_ID('gold.report_category_performance', 'V') IS NOT NULL DROP VIEW gold.report_category_performance;
GO
CREATE VIEW gold.report_category_performance AS
SELECT 
    p.category,
    COUNT(f.order_id) AS total_orders,
    SUM(f.total_amount) AS total_revenue,
    SUM(f.quantity) AS total_units_sold
FROM gold.fact_orders f
JOIN gold.dim_products p ON f.product_id = p.product_id
GROUP BY p.category;
GO
