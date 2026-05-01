-- QUESTION 1: What is the total revenue, cost, profit and profit margin by year?
-- Purpose: To know if the business is growing and staying profitable year over year?

SELECT
    year,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity) AS total_units_sold,
    SUM(line_revenue_usd) AS total_revenue_usd,
    SUM(line_cost_usd) AS total_cost_usd,
    SUM(line_profit_usd) AS total_profit_usd,
    ROUND(
        SUM(line_profit_usd) / SUM(line_revenue_usd) * 100
    , 2) AS profit_margin_pct
FROM warehouse.vw_revenue_analysis
WHERE year BETWEEN 2016 AND 2020
GROUP BY year
ORDER BY year;


-- QUESTION 2: What is the year over year revenue growth?
-- Purpose: To spot seasonal trends and understand if revenue grow or decline

WITH yearly_revenue AS (
    SELECT
        year,
        SUM(line_revenue_usd) AS revenue_usd,
        LAG(SUM(line_revenue_usd)) OVER (ORDER BY year) AS prev_year_revenue_usd
    FROM warehouse.vw_revenue_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY year
)
SELECT
    year,
    revenue_usd,
    prev_year_revenue_usd,
    revenue_usd - prev_year_revenue_usd AS yoy_change_usd,
    ROUND(
        (revenue_usd - prev_year_revenue_usd)
        / NULLIF(prev_year_revenue_usd, 0) * 100,
    1) AS yoy_growth_pct
FROM yearly_revenue
ORDER BY year;


-- QUESTION 3: What is the month-over-month revenue growth?
-- Purpose: To spot seasonal trends and identify which months drive the most growth or decline

WITH monthly_revenue AS (
    SELECT
        "year",
        month_number,
        month_name,
        year_month,
        SUM(line_revenue_usd) AS revenue_usd
    FROM warehouse.vw_revenue_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY 
    	"year", 
    	month_number,
    	month_name,
    	year_month
)
SELECT
    "year",
    month_name,
    year_month,
    revenue_usd,
    
   	-- Previous month revenue using LAG()
    LAG(revenue_usd) OVER (ORDER BY year, month_number) AS prev_month_revenue_usd,
    
    -- Month-over-month change in Revenue
    revenue_usd - LAG(revenue_usd) OVER (ORDER BY year, month_number) AS mom_change_usd,
    
    -- Month-over-month growth percentage
    ROUND(
        (revenue_usd - LAG(revenue_usd) OVER (ORDER BY year, month_number))
        / NULLIF(LAG(revenue_usd) OVER (ORDER BY year, month_number), 0) * 100,
    2) AS mom_growth_pct
FROM monthly_revenue
ORDER BY year, month_number;

