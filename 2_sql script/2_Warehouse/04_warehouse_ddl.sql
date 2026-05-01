-- Create Schema for warehouse
CREATE SCHEMA IF NOT EXISTS warehouse;

-- ==============================================
-- Creating Dimension Tables
-- ==============================================

-- Auto-generated Date Dimension

DROP TABLE IF EXISTS warehouse.dim_date CASCADE;
CREATE TABLE warehouse.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    day_of_week SMALLINT NOT NULL,
    month_number SMALLINT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    quarter SMALLINT NOT NULL,
    year SMALLINT NOT NULL,
    year_month VARCHAR(7) NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- Customer Dimension

DROP TABLE IF EXISTS warehouse.dim_customer CASCADE;
CREATE TABLE warehouse.dim_customer (
    customer_key INTEGER PRIMARY KEY,
    gender VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    city  VARCHAR(100) NOT NULL,
    state_code VARCHAR(50)  NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    continent VARCHAR(50) NOT NULL,
    date_of_birth DATE
);

-- Product Dimension
DROP TABLE IF EXISTS warehouse.dim_product CASCADE;
CREATE TABLE warehouse.dim_product (
    product_key INTEGER PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    color VARCHAR(50) NOT NULL,
    unit_cost_usd NUMERIC(10,2) NOT NULL CHECK (unit_cost_usd >= 0),
    unit_price_usd NUMERIC(10,2) NOT NULL CHECK (unit_price_usd >= 0),
    subcategory_key INTEGER NOT NULL,
    subcategory VARCHAR(100) NOT NULL,
    category_key INTEGER NOT NULL,
    category VARCHAR(100) NOT NULL
);

-- Store Dimension

DROP TABLE IF EXISTS warehouse.dim_store CASCADE;
CREATE TABLE warehouse.dim_store (
    store_key INTEGER PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(100) NOT NULL,
    square_meters NUMERIC(10,2) CHECK (square_meters >= 0),
    open_date DATE,
    store_type VARCHAR(10) NOT NULL
);

-- Exchange_rate Dimension

DROP TABLE IF EXISTS warehouse.dim_exchange_rate CASCADE;
CREATE TABLE warehouse.dim_exchange_rate (
    exchange_rate_key SERIAL PRIMARY KEY,	-- surrogate key
    rate_date DATE NOT NULL,
    currency VARCHAR(3) NOT NULL,
    exchange_rate NUMERIC(10,6) NOT NULL CHECK (exchange_rate > 0),
    UNIQUE (rate_date, currency) 
);

-- ====================================================
-- Fact Table
-- Grain: One row per order line item
--          (one order can have multiple products = multiple rows)
-- ====================================================

DROP TABLE IF EXISTS warehouse.fact_sales CASCADE;
CREATE TABLE warehouse.fact_sales (
    sales_key SERIAL PRIMARY KEY,    -- surrogate 
    
    --Order identifiers
    order_number INTEGER NOT NULL,
    line_item INTEGER  NOT NULL,

    -- Date foreign keys
    order_date_key INTEGER NOT NULL REFERENCES warehouse.dim_date(date_key),
    delivery_date_key INTEGER REFERENCES warehouse.dim_date(date_key),

    -- Dimensions foreign keys
    customer_key INTEGER NOT NULL REFERENCES warehouse.dim_customer(customer_key),
    store_key INTEGER NOT NULL REFERENCES warehouse.dim_store(store_key),
    product_key INTEGER NOT NULL REFERENCES warehouse.dim_product(product_key),
    exchange_rate_key INTEGER NOT NULL REFERENCES warehouse.dim_exchange_rate(exchange_rate_key),

    -- Order details
	quantity INTEGER NOT NULL CHECK (quantity > 0),
    currency_code VARCHAR(3) NOT NULL,

    -- Financial measures (USD)
    unit_cost_usd NUMERIC(10,2) NOT NULL,		-- from dim_product
    unit_price_usd NUMERIC(10,2) NOT NULL,		-- from dim_product
    line_cost_usd NUMERIC(12,2) NOT NULL,		-- quantity × unit_cost_usd
    line_revenue_usd NUMERIC(12,2) NOT NULL,	-- quantity × unit_price_usd
    line_profit_usd NUMERIC(12,2) NOT NULL,		-- revenue - cost
	days_to_deliver INTEGER,     				-- NULL for in-store orders
    CONSTRAINT uq_order_line UNIQUE (order_number, line_item)
);

-- Creating Indexes for performance

CREATE INDEX idx_fact_sales_order_date_key
    ON warehouse.fact_sales(order_date_key);

CREATE INDEX idx_fact_sales_customer_key
    ON warehouse.fact_sales(customer_key);

CREATE INDEX idx_fact_sales_product_key
    ON warehouse.fact_sales(product_key);

CREATE INDEX idx_fact_sales_store_key
    ON warehouse.fact_sales(store_key);

CREATE INDEX idx_dim_date_year_month
    ON warehouse.dim_date(year, month_number);

-- ==============================================
-- VALIDATION QUERIES
-- ==============================================

-- Tables verification
SELECT
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'warehouse'
ORDER BY table_name;

-- Columns Check
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'warehouse'
ORDER BY table_name, ordinal_position;