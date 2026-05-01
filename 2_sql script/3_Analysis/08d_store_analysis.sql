-- QUESTION 11: What is the Year-over-Year revenue growth by country?
-- Purpose: Understand which markets are growing fastest and which are declining?

WITH country_yearly_revenue AS (
    SELECT
        store_country AS country,
        year,
        SUM(line_revenue_usd) AS revenue_usd,
        COUNT(DISTINCT order_number) AS total_orders
    FROM warehouse.vw_store_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY store_country, year
),
lagged AS (
    SELECT
        *,
        LAG(revenue_usd) OVER (PARTITION BY country ORDER BY year) AS prev_year_revenue_usd
    FROM country_yearly_revenue
)
SELECT
    country,
    year,
    revenue_usd,
    total_orders,
    prev_year_revenue_usd,
    ROUND(revenue_usd - prev_year_revenue_usd, 2) AS yoy_change_usd,
    ROUND(
        (revenue_usd - prev_year_revenue_usd) 
        / NULLIF(prev_year_revenue_usd, 0) * 100
    , 2) AS yoy_growth_pct
FROM lagged
ORDER BY country, year;


-- QUESTION 12: Which stores generate the most revenue per square meter?
-- Purpose: Identify most efficient store locations

WITH store_revenue AS (
    SELECT
        store_key,
        store_country,
        store_state,
        square_meters,
        store_open_date,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(line_revenue_usd) AS total_revenue_usd,
        SUM(line_profit_usd) AS total_profit_usd
    FROM warehouse.vw_store_analysis
    WHERE year BETWEEN 2016 AND 2020
      AND store_type = 'Physical'
    GROUP BY
        store_key, store_country, store_state,
        square_meters, store_open_date
)

SELECT
    store_country,
    store_state,
    square_meters,
    total_orders,
    total_revenue_usd,
    total_profit_usd,
    revenue_per_sqm,

    -- Rank within country
    RANK() OVER (
        PARTITION BY store_country
        ORDER BY revenue_per_sqm DESC
    ) AS rank_in_country,

    -- Overall rank
    RANK() OVER (
        ORDER BY revenue_per_sqm DESC
    ) AS overall_rank

FROM (
    SELECT
        *,
        ROUND(
            total_revenue_usd / NULLIF(square_meters, 0)
        , 2) AS revenue_per_sqm
    FROM store_revenue
) sr

ORDER BY overall_rank;


-- QUESTION 13: Which physical stores have never recorded a sale?
-- Purpose: Identify underperforming store locations that may need investigation or closure

WITH max_date AS (
    SELECT MAX(full_date) AS max_dt
    FROM warehouse.vw_revenue_analysis
)
SELECT
    s.store_key,
    s.country,
    s.state,
    s.store_type,
    s.square_meters,
    s.open_date,
    m.max_dt - s.open_date AS days_open_no_sales
FROM warehouse.dim_store s
CROSS JOIN max_date m
LEFT JOIN (
    SELECT DISTINCT store_key
    FROM warehouse.vw_store_analysis
    WHERE year BETWEEN 2016 AND 2020
) v
ON s.store_key = v.store_key
WHERE v.store_key IS NULL
  AND s.store_type = 'Physical'
ORDER BY s.country, s.state;


-- QUESTION 14: What is the revenue split between Online vs Physical stores by year?
-- Purpose: To understand channel performance: Is the online channel growing faster than physical stores?

WITH channel_revenue AS (
    SELECT
        year,
        store_type,
        SUM(line_revenue_usd)AS revenue_usd,
        COUNT(DISTINCT order_number) AS total_orders,
        ROUND(AVG(days_to_deliver), 1) AS avg_delivery_days
    FROM warehouse.vw_revenue_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY year, store_type
)
SELECT
    year,
    store_type,
    revenue_usd,
    total_orders,
    avg_delivery_days,
    ROUND(
        revenue_usd / SUM(revenue_usd) OVER (PARTITION BY year) * 100
    , 2) AS revenue_share_pct
FROM channel_revenue
ORDER BY year, store_type;