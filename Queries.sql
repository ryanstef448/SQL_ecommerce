-- Advanced analysis using window functions, CTEs, and Business Logic (MSSQL/T-SQL)

-- 1. Revenue trends with running totals and 7-day moving average
-- Demonstrates time-series analysis capabilities
SELECT 
    order_timestamp,
    total_amount,
    SUM(total_amount) OVER(ORDER BY order_timestamp) AS cumulative_revenue,
    AVG(total_amount) OVER(ORDER BY order_timestamp ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7d
FROM gold.fact_orders;

-- 2. Customer segmentation by spend performance
-- Demonstrates RANK and NTILE for customer tiering
SELECT 
    customer_name,
    total_revenue,
    RANK() OVER(ORDER BY total_revenue DESC) AS spend_rank,
    NTILE(3) OVER(ORDER BY total_revenue DESC) AS customer_tier -- 1: Top, 2: Mid, 3: Low
FROM gold.report_customer_activity;

-- 3. Category growth and contribution analysis
-- Demonstrates cross-table analysis and percentage calculations
WITH category_metrics AS (
    SELECT 
        category,
        total_revenue,
        SUM(total_revenue) OVER() AS grand_total_revenue
    FROM gold.report_category_performance
)
SELECT 
    category,
    total_revenue,
    ROUND((total_revenue / grand_total_revenue) * 100, 2) AS revenue_contribution_pct
FROM category_metrics
ORDER BY total_revenue DESC;

-- 4. Audit Trail: Checking processing latency
-- Demonstrates data engineering monitoring capabilities
SELECT TOP 5
    customer_id,
    signup_date,
    ingestion_timestamp,
    processed_timestamp,
    DATEDIFF(SECOND, ingestion_timestamp, processed_timestamp) AS processing_latency_seconds
FROM silver.customers;
