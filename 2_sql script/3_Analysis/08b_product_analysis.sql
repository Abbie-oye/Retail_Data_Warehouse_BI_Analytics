-- QUESTION 4: Which are the top 10 products by revenue and what is their rank within their category?
-- Purpose: To identify top products and understand which products lead their category

SELECT
    product_name,
    brand,
    category,
    subcategory,
    total_revenue_usd,
    total_units_sold,
    RANK() OVER (PARTITION BY category
        ORDER BY total_revenue_usd DESC) AS rank_in_category,
    RANK() OVER (
        ORDER BY total_revenue_usd DESC) AS overall_rank
FROM (
    SELECT
        product_name,
        brand,
        category,
        subcategory,
        SUM(line_revenue_usd) AS total_revenue_usd,
        SUM(quantity) AS total_units_sold
    FROM warehouse.vw_product_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY product_name, brand, category, subcategory
) product_summary
ORDER BY overall_rank
LIMIT 10;


-- QUESTION 5: Revenue contribution % per category
-- Purpose: Identify which categories drive revenue and profitability

WITH category_revenue AS (
    SELECT
        category,
        SUM(line_revenue_usd) AS category_revenue_usd,
        SUM(line_profit_usd) AS category_profit_usd,
        SUM(quantity) AS units_sold
    FROM warehouse.vw_product_analysis
    WHERE year BETWEEN 2016 AND 2020
    GROUP BY category
)

SELECT
    category,
    category_revenue_usd,
    category_profit_usd,
    units_sold,

    -- Revenue Contribution %
    ROUND(
        category_revenue_usd 
        / SUM(category_revenue_usd) OVER () * 100,
    2) AS revenue_contribution_pct,

    -- Profit Margin %
    ROUND(
        category_profit_usd 
        / category_revenue_usd * 100,
    2) AS profit_margin_pct

FROM category_revenue
ORDER BY category_revenue_usd DESC;


-- QUESTION 6: Which products have never been sold?
-- Purpose: Identify dead stock / products taking up inventory space with zero revenue contribution
SELECT
    p.product_key,
    p.product_name,
    p.brand,
    p.category,
    p.subcategory,
    p.unit_cost_usd,
    p.unit_price_usd
FROM warehouse.dim_product p
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.vw_product_analysis v
    WHERE v.product_key = p.product_key
      AND v.year BETWEEN 2016 AND 2020
)
ORDER BY p.category, p.product_name;