# SQL E-Commerce Data Pipeline & Analytics (Medallion Architecture)

## Project Overview
This project demonstrates a comprehensive end-to-end SQL-based data engineering and analytics pipeline. Using the **Medallion Architecture** (Bronze, Silver, Gold), it transforms raw, "dirty" e-commerce data into a structured, optimized Star Schema ready for business intelligence and executive reporting.

The project is implemented in **T-SQL (MSSQL)** and showcases advanced data modeling, ETL processes, and analytical query patterns.

---

## 🏗️ Data Architecture: The Medallion Approach

### 1. 🥉 Bronze Layer (Raw Ingestion)
- **Source:** Raw data simulation for Customers, Products, and Orders.
- **Characteristics:** Contains duplicates, inconsistent casing, whitespace issues, and unformatted strings.
- **File:** `bronze.sql`

### 2. 🥈 Silver Layer (Cleaned & Standardized)
- **Transformation:**
    - **Deduplication:** Utilized `ROW_NUMBER()` and CTEs to identify and remove duplicate records.
    - **Data Cleaning:** Implemented `TRIM`, `LOWER`, and `CAST` for data type normalization and string sanitization.
    - **Data Integrity:** Applied filtering to ensure valid business logic (e.g., `price > 0`, `quantity > 0`).
- **File:** `silver.sql`

### 3. 🥇 Gold Layer (Analytics & Reporting)
- **Modeling:** Implemented a **Star Schema** to optimize query performance.
- **Dimensional Modeling:** Created Dimension Views (`dim_customers`, `dim_products`) for attribute consistency.
- **Fact Table:** Developed a persistent `fact_orders` table with pre-calculated metrics (e.g., `total_amount`) to reduce compute time for large-scale joins.
- **Reporting:** Created specialized views for Executive Dashboards (`report_customer_activity`) and Category Performance.
- **Files:** `gold.sql`, `Fact Table.sql`

---

## 🚀 Key Technical Skills Demonstrated

*   **ETL Pipeline Design:** Automated flow from raw ingestion to reporting-ready assets.
*   **Data Quality Engineering:** Advanced deduplication and sanitization techniques.
*   **Advanced T-SQL:**
    *   **Window Functions:** `RANK()`, `NTILE()`, `SUM() OVER()`, `AVG() OVER()`.
    *   **Complex CTEs:** For modular and readable transformation logic.
    *   **Performance Optimization:** Pre-joining staging assets into persistent Fact tables.
*   **Business Intelligence:** Generating actionable insights like customer tiering, moving averages, and revenue contribution analysis.

---

## 📊 Analytical Insights Generated
The project includes a suite of advanced analytical queries (`Queries.sql`) providing:
- **Revenue Trends:** Running totals and 7-day moving averages for growth tracking.
- **Customer Segmentation:** Ranking and tiering customers (Top/Mid/Low) based on spend performance.
- **Category Growth:** Percentage-of-total contribution analysis for product categories.
- **Audit Trails:** Processing latency analysis to monitor pipeline performance.

---

## 🛠️ How to Use
1.  Run `setup.sql` to initialize the environment (Reserved for environment-specific configs).
2.  Execute `bronze.sql` to ingest raw sample data.
3.  Execute `silver.sql` to perform data cleaning and deduplication.
4.  Execute `Fact Table.sql` followed by `gold.sql` to build the analytics layer.
5.  Explore `Queries.sql` for advanced business analysis.