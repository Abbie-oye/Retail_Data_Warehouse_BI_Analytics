-- BASE VIEW (Grain: 1 row per order_number + line_item)
-- Creating Base View

DROP VIEW IF EXISTS warehouse.vw_sales_base CASCADE;

CREATE VIEW warehouse.vw_sales_base AS
SELECT 
	-- Fact_sales
	f.order_number,
    f.line_item,
    f.quantity,
    f.currency_code,
    f.days_to_deliver,
    f.unit_price_usd,
    f.unit_cost_usd,
    f.line_revenue_usd,
    f.line_cost_usd,
    f.line_profit_usd,
    
    -- dim_date
    d.full_date,
    d.year,
    d.month_number,
    d.month_name,
    d.quarter,
    d.year_month,
    d.day_name,
    d.is_weekend,
    
    -- dim_customer
    c.customer_key,
    c.name AS customer_name,
    c.gender,
    c.city AS customer_city,
    c.country AS customer_country,
    c.continent,
    c.date_of_birth,
    
    -- dim_product
    p.product_key,
    p.product_name,
    p.brand,
    p.color,
    p.category,
    p.subcategory,
    
    -- dim_store	
    s.store_key,
    s.country AS store_country,
    s.state AS store_state,
    s.store_type,
    s.square_meters,
    s.open_date AS store_open_date
FROM warehouse.fact_sales f
INNER JOIN warehouse.dim_date d ON f.order_date_key= d.date_key
INNER JOIN warehouse.dim_customer c  ON f.customer_key = c.customer_key
INNER JOIN warehouse.dim_product p  ON f.product_key = p.product_key
INNER JOIN warehouse.dim_store s ON f.store_key = s.store_key
;


-- Creating Analytical Views

DROP VIEW IF EXISTS warehouse.vw_revenue_analysis CASCADE;

CREATE VIEW warehouse.vw_revenue_analysis AS
SELECT
    order_number,
    line_item,
    quantity,
    currency_code,
    days_to_deliver,
    line_revenue_usd,
    line_cost_usd,
    line_profit_usd,
    full_date,
    year,
    month_number,
    month_name,
    quarter,
    year_month,
    day_name,
    is_weekend,
    store_country,
    store_state,
    store_type
FROM warehouse.vw_sales_base;


DROP VIEW IF EXISTS warehouse.vw_product_analysis CASCADE;

CREATE VIEW warehouse.vw_product_analysis AS
SELECT
    order_number,
    line_item,
    quantity,
    line_revenue_usd,
    line_cost_usd,
    line_profit_usd,
    year,
    month_number,
    month_name,
    quarter,
    year_month,
    product_key,
    product_name,
    brand,
    color,
    category,
    subcategory,
    store_country
FROM warehouse.vw_sales_base;


DROP VIEW IF EXISTS warehouse.vw_customer_analysis CASCADE;

CREATE VIEW warehouse.vw_customer_analysis AS
SELECT
    order_number,
    line_item,
    quantity,
    days_to_deliver,
    line_revenue_usd,
    line_cost_usd,
    line_profit_usd,
    full_date,
    year,
    month_number,
    month_name,
    quarter,
    year_month,
    customer_key,
    customer_name,
    gender,
    customer_city,
    customer_country,
    continent,
    date_of_birth,
    store_type,
    store_country
FROM warehouse.vw_sales_base;


DROP VIEW IF EXISTS warehouse.vw_store_analysis CASCADE;

CREATE VIEW warehouse.vw_store_analysis AS
SELECT
    order_number,
    line_item,
    quantity,
    days_to_deliver,
    line_revenue_usd,
    line_cost_usd,
    line_profit_usd,
    year,
    month_number,
    month_name,
    quarter,
    year_month,
    customer_country,
    continent,
    store_key,
    store_country,
    store_state,
    store_type,
    square_meters,
    store_open_date
FROM warehouse.vw_sales_base;

-- Verifying all views
SELECT
    table_name AS view_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'warehouse'
    AND table_type = 'VIEW'
ORDER BY table_name;


-- Row count check
SELECT 'vw_sales_base' AS view_name, COUNT(*) AS row_count FROM warehouse.vw_sales_base
UNION ALL
SELECT 'vw_revenue_analysis', COUNT(*) FROM warehouse.vw_revenue_analysis
UNION ALL
SELECT 'vw_product_analysis', COUNT(*) FROM warehouse.vw_product_analysis
UNION ALL
SELECT 'vw_customer_analysis', COUNT(*) FROM warehouse.vw_customer_analysis
UNION ALL
SELECT 'vw_store_analysis', COUNT(*) FROM warehouse.vw_store_analysis;
