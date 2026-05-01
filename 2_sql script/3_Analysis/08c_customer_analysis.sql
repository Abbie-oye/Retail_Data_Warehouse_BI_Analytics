-- QUESTION 7: Who are the most valuable customers?
-- Purpose: Segmenting customers into Low / Mid / High value tiers based on lifetime revenue distribution

WITH customer_ltv AS (
    SELECT
        customer_key,
        customer_name,
        customer_country,
        continent,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(line_revenue_usd) AS total_ltv
    FROM warehouse.vw_customer_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY
        customer_key,
        customer_name,
        customer_country,
        continent
),

customer_segment AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th
    FROM customer_ltv
),

segment_value AS (
    SELECT
        c.*,
        CASE
            WHEN c.total_ltv >= cs.ltv_75th THEN 'High Value'
            WHEN c.total_ltv <= cs.ltv_25th THEN 'Low Value'
            ELSE 'Mid Value'
        END AS customer_segment
    FROM customer_ltv c
    CROSS JOIN customer_segment cs
)

SELECT
    customer_segment,
    COUNT(customer_key) AS customer_count,
    SUM(total_orders) AS total_orders,
    SUM(total_ltv) AS total_ltv,
    ROUND(
        SUM(total_ltv) * 100.0 / SUM(SUM(total_ltv)) OVER (),
        2
    ) AS ltv_pct,
    ROUND(
        SUM(total_ltv) / COUNT(customer_key),
        2
    ) AS avg_ltv
FROM segment_value
GROUP BY customer_segment
ORDER BY 3 DESC;


-- QUESTION 8: How many customers from each cohort_year are active or churned?
-- Purpose: To understand customer loyalty: Which cohorts retain or is losing customers over time?
--	 (12 month window as electronics industry standard)

WITH customer_last_purchase AS (
    SELECT
        customer_key,
        customer_name,
        MAX(full_date) AS last_purchase_date,
        MIN(full_date) AS first_purchase_date,
        MIN(year) AS cohort_year
    FROM warehouse.vw_customer_analysis
    GROUP BY customer_key, customer_name
),
max_date AS (
    SELECT MAX(full_date) AS max_date
    FROM warehouse.vw_customer_analysis
    WHERE year <= 2020
),

churned_customers AS (
    SELECT
        c.customer_key,
        c.customer_name,
        c.cohort_year,
        CASE 
            WHEN c.last_purchase_date < m.max_date - INTERVAL '12 months'
                THEN 'Churned'
            ELSE 'Active'
        END AS customer_status
    FROM customer_last_purchase c
    CROSS JOIN max_date m

    -- Exclude new customers (<12 months old) since they cannot be classified as churned yet
    WHERE c.first_purchase_date < m.max_date - INTERVAL '12 months'
)

SELECT
    cohort_year,
    customer_status,
    COUNT(customer_key) AS num_customers,
    SUM(COUNT(customer_key)) OVER (PARTITION BY cohort_year) AS total_customers,
    ROUND(
        100.0 * COUNT(customer_key) 
        / SUM(COUNT(customer_key)) OVER (PARTITION BY cohort_year),
        2
    ) AS status_pct
FROM churned_customers
WHERE cohort_year BETWEEN 2016 AND 2020
GROUP BY cohort_year, customer_status
ORDER BY cohort_year, customer_status;


-- QUESTION 9: How does each customer cohort contribute to revenue in subsequent years?
-- Purpose: Understand which customer cohorts drive the most revenue year over year; are older cohorts still contributing or fading out?

WITH yearly_cohort AS (
    SELECT
        customer_key,
        MIN(year) AS cohort_year
    FROM warehouse.vw_customer_analysis
    GROUP BY customer_key
)
SELECT
    y.cohort_year,
    v.year AS purchase_year,
    COUNT(DISTINCT v.customer_key) AS num_customers,
    COUNT(DISTINCT v.order_number) AS num_orders,
    SUM(v.line_revenue_usd) AS cohort_revenue_usd,
    ROUND(
        SUM(v.line_revenue_usd) * 100.0 /SUM(SUM(v.line_revenue_usd)) OVER (PARTITION BY v.year)
    , 2)  AS revenue_contribution_pct
FROM warehouse.vw_customer_analysis v
JOIN yearly_cohort y ON v.customer_key = y.customer_key
WHERE v.year BETWEEN 2016 AND 2020
GROUP BY y.cohort_year, v.year
ORDER BY y.cohort_year, v.year;

-- QUESTION 10: Which customers have never placed an order?
-- Purpose: : Identify registered but inactive customers, an opportunity for re-engagement campaigns

SELECT COUNT(*) AS inactive_customers
FROM warehouse.dim_customer c
LEFT JOIN warehouse.vw_customer_analysis v
    ON c.customer_key = v.customer_key
    AND v.year BETWEEN 2016 AND 2020
WHERE v.customer_key IS NULL;
