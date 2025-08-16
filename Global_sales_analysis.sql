/*
===============================================================
 Project 1: Global Sales & Profitability SQL Analysis
 Target Companies: JPMorgan, Barclays, EY, Deloitte
 Author: [Your Name]
===============================================================

 PURPOSE:
 This project demonstrates real-world SQL usage in a 
 financial/consulting environment:
   - Data quality validation
   - Core KPI computation
   - Business insights queries
   - Early-warning trend checks

 Dataset: revenue_txns (simulated global sales dataset)
===============================================================
*/


-- ============================================================
-- 1. SCHEMA SETUP
-- ============================================================

-- Fact table: Revenue Transactions
CREATE TABLE revenue_txns (
    txn_id BIGINT PRIMARY KEY,
    client_id VARCHAR(50),
    product_category VARCHAR(50),
    region VARCHAR(50),
    channel VARCHAR(50),
    txn_date DATE,
    revenue_usd DECIMAL(18,2),
    cost_usd DECIMAL(18,2),
    profit_usd DECIMAL(18,2),
    incentive_flag CHAR(1),
    fx_rate DECIMAL(10,4),
    currency VARCHAR(10)
);

-- Note: Load your CSV into this table before running queries.


-- ============================================================
-- 2. DATA QUALITY & CLEANING CHECKS
-- ============================================================

-- 2.1 Missing or invalid values
SELECT COUNT(*) AS missing_values
FROM revenue_txns
WHERE client_id IS NULL
   OR product_category IS NULL
   OR revenue_usd IS NULL;

-- 2.2 Logical validation: Profit should not exceed revenue
SELECT *
FROM revenue_txns
WHERE profit_usd > revenue_usd;

-- 2.3 FX rate sanity checks (flag outliers beyond expected band)
SELECT *
FROM revenue_txns
WHERE fx_rate NOT BETWEEN 0.5 AND 2.0;


-- ============================================================
-- 3. KPI QUERIES
-- ============================================================

-- 3.1 Total revenue, profit, and margin
SELECT 
    SUM(revenue_usd) AS total_revenue,
    SUM(profit_usd) AS total_profit,
    ROUND(SUM(profit_usd) * 100.0 / NULLIF(SUM(revenue_usd),0), 2) AS margin_pct
FROM revenue_txns;

-- 3.2 Revenue & Margin by Region
SELECT 
    region,
    SUM(revenue_usd) AS total_revenue,
    SUM(profit_usd) AS total_profit,
    ROUND(SUM(profit_usd) * 100.0 / NULLIF(SUM(revenue_usd),0), 2) AS margin_pct
FROM revenue_txns
GROUP BY region
ORDER BY margin_pct ASC;

-- 3.3 Incentives Impact (Promo vs Non-Promo)
SELECT 
    incentive_flag,
    SUM(revenue_usd) AS total_revenue,
    SUM(profit_usd) AS total_profit,
    ROUND(SUM(profit_usd) * 100.0 / NULLIF(SUM(revenue_usd),0), 2) AS margin_pct
FROM revenue_txns
GROUP BY incentive_flag;


-- ============================================================
-- 4. BUSINESS-READY INSIGHTS
-- ============================================================

-- 4.1 Top 10 Low-Margin Clients (Pricing opportunity list)
SELECT 
    client_id,
    SUM(revenue_usd) AS total_revenue,
    ROUND(SUM(profit_usd)*100.0 / NULLIF(SUM(revenue_usd),0), 2) AS margin_pct
FROM revenue_txns
GROUP BY client_id
HAVING SUM(revenue_usd) > 50000
ORDER BY margin_pct ASC
LIMIT 10;

-- 4.2 Elasticity Check: Average Price vs Volume
SELECT 
    product_category,
    AVG(revenue_usd / NULLIF(cost_usd,0)) AS avg_price_index,
    COUNT(*) AS txn_count
FROM revenue_txns
GROUP BY product_category
ORDER BY avg_price_index DESC;

-- 4.3 Early-Warning: MoM Margin Drop > 100 bps
WITH monthly_perf AS (
    SELECT 
        DATE_TRUNC('month', txn_date) AS month,
        SUM(revenue_usd) AS total_revenue,
        SUM(profit_usd) AS total_profit,
        ROUND(SUM(profit_usd)*100.0 / NULLIF(SUM(revenue_usd),0), 2) AS margin_pct
    FROM revenue_txns
    GROUP BY DATE_TRUNC('month', txn_date)
)
SELECT 
    month,
    margin_pct,
    LAG(margin_pct) OVER (ORDER BY month) AS prev_margin,
    (margin_pct - LAG(margin_pct) OVER (ORDER BY month)) AS margin_change
FROM monthly_perf
HAVING margin_change < -1.0;

-- ============================================================
-- END OF FILE
-- ============================================================
