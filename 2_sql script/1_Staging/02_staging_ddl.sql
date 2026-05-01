-- Creating Staging schema
CREATE SCHEMA IF NOT EXISTS staging;

-- Creating Staging Tables

DROP TABLE IF EXISTS staging.stg_customers;
CREATE TABLE staging.stg_customers (
	customer_key	INTEGER,
	gender TEXT,
	name TEXT,
    city TEXT,           -- some values are ALL CAPS
    state_code TEXT,
    state TEXT,
    zip_code TEXT,           -- kept as TEXT — mixed char
    country TEXT,
    continent TEXT,
    date_of_birth TEXT      -- unformatted
);

DROP TABLE IF EXISTS staging.stg_exchange_rate;
CREATE TABLE staging.stg_exchange_rate (
	rate_date       TEXT,           -- mixed formatting
    currency        TEXT,
    exchange_rate   NUMERIC

);

DROP TABLE IF EXISTS staging.stg_products;
CREATE TABLE staging.stg_products (
	product_key         INTEGER,
    product_name        TEXT,
    brand               TEXT,
    color               TEXT,
    unit_cost_usd       TEXT,       -- raw: '$ '  — needs cleaning
    unit_price_usd      TEXT,       -- raw: '$ ' — needs cleaning
    subcategory_key     INTEGER,
    subcategory         TEXT,
    category_key        INTEGER,
    category            TEXT
);

DROP TABLE IF EXISTS staging.stg_sales;
CREATE TABLE staging.stg_sales (
	order_number    INTEGER,
    line_item       INTEGER,
    order_date      TEXT,           -- mixed formatting,
    delivery_date   TEXT,           -- NULL for in-store orders
    customer_key    INTEGER,
    store_key       INTEGER,
    product_key     INTEGER,
    quantity        INTEGER,
    currency_code   TEXT  
);

DROP TABLE IF EXISTS staging.stg_stores;
CREATE TABLE staging.stg_stores (
	store_key       INTEGER,
    country         TEXT,
    state           TEXT,
    square_meters   NUMERIC,        -- NULL for online store (store_key = 0)
    open_date       TEXT            -- raw: '12/15/2009' format
);


-- Modifying Staging Tables

COPY staging.stg_customers FROM 'C:\Program Files\PostgreSQL\18\data\Raw_Dataset\Global_Electronics_Files\Customers.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

COPY staging.stg_exchange_rate FROM 'C:\Program Files\PostgreSQL\18\data\Raw_Dataset\Global_Electronics_Files\Exchange_Rates.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

COPY staging.stg_products FROM 'C:\Program Files\PostgreSQL\18\data\Raw_Dataset\Global_Electronics_Files\Products.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

COPY staging.stg_sales FROM 'C:\Program Files\PostgreSQL\18\data\Raw_Dataset\Global_Electronics_Files\Sales.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

COPY staging.stg_stores FROM 'C:\Program Files\PostgreSQL\18\data\Raw_Dataset\Global_Electronics_Files\Stores.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';



