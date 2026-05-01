-- ====================================================
-- DATA PROFILING: Null Checks and Data Quality
-- ====================================================

/* This section checks for:
    1. Missing values (NULLs and blanks for text fields)
    2. Data completeness (% of issues per column)
    3. Duplicate records based on business keys
*/

-- ====================================================
-- Staging Sales

SELECT
   	'order_number' AS column_name,
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_number IS NULL) AS null_count,
    ROUND(COUNT(*) FILTER (WHERE order_number IS NULL) * 100.0 / COUNT(*), 2) AS issue_pct
FROM staging.stg_sales

UNION ALL 
SELECT 'line_item',
	COUNT(*),
    COUNT(*) FILTER (WHERE line_item IS NULL),
    ROUND(COUNT(*) FILTER (WHERE line_item IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL
SELECT 'order_date',
	COUNT(*),
    COUNT(*) FILTER (WHERE order_date IS NULL OR TRIM(order_date) = ''),
    ROUND(COUNT(*) FILTER (WHERE order_date IS NULL OR TRIM(order_date) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL 
SELECT 'delivery_date',
	COUNT(*),
    COUNT(*) FILTER (WHERE delivery_date IS NULL OR TRIM(delivery_date) = ''),          -- 49,719
    ROUND(COUNT(*) FILTER (WHERE delivery_date IS NULL OR TRIM(delivery_date) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL
SELECT 'customer_key',
	COUNT(*),
    COUNT(*) FILTER (WHERE customer_key IS NULL),
    ROUND(COUNT(*) FILTER (WHERE customer_key IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL
SELECT 'store_key',
	COUNT(*),
    COUNT(*) FILTER (WHERE store_key IS NULL),
    ROUND(COUNT(*) FILTER (WHERE store_key IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL
SELECT 'product_key',
	COUNT(*),
    COUNT(*) FILTER (WHERE product_key IS NULL),
    ROUND(COUNT(*) FILTER (WHERE product_key IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL 
SELECT'quantity',
	COUNT(*),
    COUNT(*) FILTER (WHERE quantity IS NULL),
    ROUND(COUNT(*) FILTER (WHERE quantity IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

UNION ALL SELECT 'currency_code',
	COUNT(*),
    COUNT(*) FILTER (WHERE currency_code IS NULL OR TRIM(currency_code) = ''),
    ROUND(COUNT(*) FILTER (WHERE currency_code IS NULL OR TRIM(currency_code) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_sales

ORDER BY issue_pct DESC;

-- ====================================================
-- Staging Customers

SELECT
    'customer_key' AS column_name,
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_key IS NULL) AS null_count,
    ROUND(COUNT(*) FILTER (WHERE customer_key IS NULL) * 100.0 / COUNT(*), 2) AS issue_pct
FROM staging.stg_customers

UNION ALL
SELECT 'gender',
	COUNT(*),
    COUNT(*) FILTER (WHERE gender IS NULL OR TRIM(gender) = ''),
    ROUND(COUNT(*) FILTER (WHERE gender IS NULL OR TRIM(gender) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'name',
	COUNT(*),
    COUNT(*) FILTER (WHERE name IS NULL OR TRIM(name) = ''),
    ROUND(COUNT(*) FILTER (WHERE name IS NULL OR TRIM(name) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'city',
	COUNT(*),
    COUNT(*) FILTER (WHERE city IS NULL OR TRIM(city) = ''),
    ROUND(COUNT(*) FILTER (WHERE city IS NULL OR TRIM(city) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'state_code',
	COUNT(*),
    COUNT(*) FILTER (WHERE state_code IS NULL OR TRIM(state_code) = ''),
   ROUND(COUNT(*) FILTER (WHERE state_code IS NULL OR TRIM(state_code) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'state',
	COUNT(*),
    COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = ''),
    ROUND(COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'zip_code',
	COUNT(*),
    COUNT(*) FILTER (WHERE zip_code IS NULL OR TRIM(zip_code) = ''),
    ROUND(COUNT(*) FILTER (WHERE zip_code IS NULL OR TRIM(zip_code) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL 
SELECT 'country',
	COUNT(*),
    COUNT(*) FILTER (WHERE country IS NULL OR TRIM(country) = ''),
   ROUND(COUNT(*) FILTER (WHERE country IS NULL OR TRIM(country) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'continent',
	COUNT(*),
    COUNT(*) FILTER (WHERE continent IS NULL OR TRIM(continent) = ''),
    ROUND(COUNT(*) FILTER (WHERE continent IS NULL OR TRIM(continent) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

UNION ALL
SELECT 'date_of_birth',
	COUNT(*),
    COUNT(*) FILTER (WHERE date_of_birth IS NULL OR TRIM(date_of_birth) = ''),
    ROUND(COUNT(*) FILTER (WHERE date_of_birth IS NULL OR TRIM(date_of_birth) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_customers

ORDER BY issue_pct DESC;

-- ====================================================
--Staging Product

SELECT
    'product_key' AS column_name,
    COUNT(*)  AS total_rows,
    COUNT(*) FILTER (WHERE product_key IS NULL) AS null_count,
    ROUND(COUNT(*) FILTER (WHERE product_key IS NULL) * 100.0 / COUNT(*), 2) AS issue_pct
FROM staging.stg_products

UNION ALL
SELECT 'product_name',
	COUNT(*),
    COUNT(*) FILTER (WHERE product_name IS NULL OR TRIM(product_name) = ''),
   	ROUND(COUNT(*) FILTER (WHERE product_name IS NULL OR TRIM(product_name) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL
SELECT 'brand',
	COUNT(*),
    COUNT(*) FILTER (WHERE brand IS NULL OR TRIM(brand) = ''),
    ROUND(COUNT(*) FILTER (WHERE brand IS NULL OR TRIM(brand) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL
SELECT 'color',
	COUNT(*),
    COUNT(*) FILTER (WHERE color IS NULL OR TRIM(color) = ''),
    ROUND(COUNT(*) FILTER (WHERE color IS NULL OR TRIM(color) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL
SELECT 'unit_cost_usd',
	COUNT(*),
    COUNT(*) FILTER (WHERE unit_cost_usd IS NULL OR TRIM(unit_cost_usd) = ''),
    ROUND(COUNT(*) FILTER (WHERE unit_cost_usd IS NULL OR TRIM(unit_cost_usd) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL
SELECT 'unit_price_usd',
	COUNT(*),
    COUNT(*) FILTER (WHERE unit_price_usd IS NULL OR TRIM(unit_price_usd) = ''),
    ROUND(COUNT(*) FILTER (WHERE unit_price_usd IS NULL OR TRIM(unit_price_usd) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL
SELECT 'subcategory_key',
	COUNT(*),
    COUNT(*) FILTER (WHERE subcategory_key IS NULL),
    ROUND(COUNT(*) FILTER (WHERE subcategory_key IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL SELECT 'subcategory',
	COUNT(*),
    COUNT(*) FILTER (WHERE subcategory IS NULL OR TRIM(subcategory) = ''),
    ROUND(COUNT(*) FILTER (WHERE subcategory IS NULL OR TRIM(subcategory) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL 
SELECT 'category_key',
	COUNT(*),
    COUNT(*) FILTER (WHERE category_key IS NULL),
    ROUND(COUNT(*) FILTER (WHERE category_key IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_products

UNION ALL
SELECT 'category',
	COUNT(*),
    COUNT(*) FILTER (WHERE category IS NULL OR TRIM(category) = ''),
    ROUND(COUNT(*) FILTER (WHERE category IS NULL OR TRIM(category) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_products

ORDER BY issue_pct DESC;

-- ====================================================
-- Staging Stores

SELECT
    'store_key' AS column_name,
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE store_key IS NULL) AS null_count,
    ROUND(COUNT(*) FILTER (WHERE store_key IS NULL) * 100.0 / COUNT(*), 2) AS issue_pct
FROM staging.stg_stores

UNION ALL
SELECT 'country',
	COUNT(*),
    COUNT(*) FILTER (WHERE country IS NULL OR TRIM(country) = ''),
    ROUND(COUNT(*) FILTER (WHERE country IS NULL OR TRIM(country) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_stores

UNION ALL
SELECT 'state',
	COUNT(*),
    COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = ''),
    ROUND(COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = '') * 100.0 / COUNT(*), 2)
FROM staging.stg_stores

UNION ALL
SELECT 'square_meters',
	COUNT(*),
    COUNT(*) FILTER (WHERE square_meters IS NULL),							--1
    ROUND(COUNT(*) FILTER (WHERE square_meters IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_stores

UNION ALL
SELECT 'open_date',
	COUNT(*),
    COUNT(*) FILTER (WHERE open_date IS NULL),
    ROUND(COUNT(*) FILTER (WHERE open_date IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_stores

ORDER BY issue_pct DESC;

-- ====================================================
-- Staging Exchange_rate

SELECT
    'rate_date' AS column_name,
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE rate_date IS NULL) AS null_count,
    ROUND(COUNT(*) FILTER (WHERE rate_date IS NULL)  * 100.0 / COUNT(*), 2) AS issue_pct
FROM staging.stg_exchange_rate

UNION ALL
SELECT 'currency',
	COUNT(*),
    COUNT(*) FILTER (WHERE currency IS NULL),
    ROUND(COUNT(*) FILTER (WHERE currency IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_exchange_rate

UNION ALL 
SELECT 'exchange_rate',
	COUNT(*),
    COUNT(*) FILTER (WHERE exchange_rate IS NULL),
    ROUND(COUNT(*) FILTER (WHERE exchange_rate IS NULL) * 100.0 / COUNT(*), 2)
FROM staging.stg_exchange_rate

ORDER BY issue_pct DESC;

-- ====================================================
-- Duplicate Check based on business keys

SELECT 'stg_sales' AS table_name,
    COUNT(*) - COUNT(DISTINCT (order_number, line_item)) AS duplicate_rows
FROM staging.stg_sales

UNION ALL
SELECT 'stg_customers',
    COUNT(*) - COUNT(DISTINCT customer_key)
FROM staging.stg_customers

UNION ALL
SELECT 'stg_products',
    COUNT(*) - COUNT(DISTINCT product_key)
FROM staging.stg_products

UNION ALL
SELECT 'stg_stores',
    COUNT(*) - COUNT(DISTINCT store_key)
FROM staging.stg_stores

UNION ALL
SELECT 'stg_exchange_rate',
    COUNT(*) - COUNT(DISTINCT (rate_date, currency))
FROM staging.stg_exchange_rate;