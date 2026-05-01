-- =======================================
-- Auto-generating Dim_Date
-- =======================================

TRUNCATE TABLE warehouse.dim_date CASCADE;

INSERT INTO warehouse.dim_date (
	date_key, full_date, day_name,
	day_of_week, month_number, month_name,
	quarter, year, year_month, is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER AS date_key,
	d::DATE AS full_date,
    TRIM(TO_CHAR(d, 'Day')) AS day_name,
    EXTRACT(ISODOW FROM d)::SMALLINT AS day_of_week,
	EXTRACT(MONTH FROM d)::SMALLINT AS month_number,
    TRIM(TO_CHAR(d, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM d)::SMALLINT AS quarter,
    EXTRACT(YEAR FROM d)::SMALLINT AS year,
    TO_CHAR(d, 'YYYY-MM') AS year_month,
    (EXTRACT(ISODOW FROM d) IN (6,7)) AS is_weekend
FROM generate_series(
    '2015-01-01'::DATE,
    '2021-12-31'::DATE,
    '1 day'::INTERVAL
) AS d;

-- Verifying 
SELECT
    COUNT(*) AS total_days,
    MIN(full_date) AS date_from,
    MAX(full_date) AS date_to
FROM warehouse.dim_date;


-- =======================================
-- Dim_Customer
-- =======================================

TRUNCATE TABLE warehouse.dim_customer CASCADE;

INSERT INTO warehouse.dim_customer (
    customer_key, gender,name, city,
    state_code, state, zip_code, country,
    continent, date_of_birth
)
SELECT
    customer_key,
	TRIM(gender) AS gender,
	TRIM(INITCAP(name)) AS name,
	TRIM(INITCAP(city)) AS city,
	TRIM(state_code) AS state_code,
	TRIM(state) AS state,
	TRIM(zip_code) AS zip_code,
	TRIM(country) AS country,
	TRIM(continent)AS continent,
    TO_DATE(date_of_birth, 'MM/DD/YYYY') AS date_of_birth
FROM staging.stg_customers;

-- Verifying
SELECT COUNT(*) FROM warehouse.dim_customer;


-- =======================================
-- Dim_Product
-- =======================================

TRUNCATE TABLE warehouse.dim_product CASCADE;

INSERT INTO warehouse.dim_product (
    product_key,
    product_name,
    brand,
    color,
    unit_cost_usd,
    unit_price_usd,
    subcategory_key,
    subcategory,
    category_key,
    category
)
SELECT
    product_key,
    TRIM(product_name) AS product_name,
    TRIM(brand) AS brand,
    TRIM(color) AS color,
    
    TRIM(REGEXP_REPLACE(unit_cost_usd, '[\$,]', '', 'g'))::NUMERIC(10,2) AS unit_cost_usd,
    TRIM(REGEXP_REPLACE(unit_price_usd, '[\$,]', '', 'g'))::NUMERIC(10,2) AS unit_price_usd,
    
    subcategory_key,
    TRIM(subcategory) AS subcategory,
    category_key,
    TRIM(category) AS category
FROM staging.stg_products;
 
-- Verifying
SELECT COUNT(*) FROM warehouse.dim_product;


-- =======================================
 -- Dim_Store
-- =======================================

TRUNCATE TABLE warehouse.dim_store CASCADE;

INSERT INTO warehouse.dim_store (
    store_key, country,
    state, square_meters,
    open_date, store_type
)
SELECT
    store_key,
    TRIM(country),
    TRIM(state),

    CASE 
        WHEN store_key = 0 THEN NULL
        ELSE square_meters
    END AS square_meters,
    TO_DATE(open_date, 'MM/DD/YYYY') AS open_date,
    CASE
        WHEN store_key = 0 THEN 'Online'
        ELSE 'Physical'
    END AS store_type
FROM staging.stg_stores;
 
 
 
-- Verifying
SELECT
    COUNT(*) AS total_stores,
    COUNT(*) FILTER (WHERE store_type = 'Online') AS online,
    COUNT(*) FILTER (WHERE store_type = 'Physical') AS physical
FROM warehouse.dim_store;


-- =======================================
-- Dim_Exchange_rate
-- =======================================

TRUNCATE TABLE warehouse.dim_exchange_rate CASCADE;

INSERT INTO warehouse.dim_exchange_rate (
    rate_date,
    currency,
    exchange_rate
)
SELECT
   TO_DATE(rate_date, 'MM/DD/YYYY') AS rate_date,
    TRIM(currency) AS currency,
    exchange_rate
FROM staging.stg_exchange_rate
ON CONFLICT (rate_date, currency) DO NOTHING;
 
 
-- Verify dim_exchange_rate
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT currency) AS currencies,
    MIN(rate_date) AS date_from,
    MAX(rate_date)  AS date_to
FROM warehouse.dim_exchange_rate;


