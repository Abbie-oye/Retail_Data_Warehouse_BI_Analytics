-- Fact Sales Load (Grain: 1 Row per Order_line_item)

TRUNCATE TABLE warehouse.fact_sales RESTART IDENTITY;

WITH sales_clean AS (
    SELECT
        s.*,
        TO_DATE(s.order_date, 'MM/DD/YYYY') AS order_dt,
        TRIM(s.currency_code) AS currency_clean,
        TO_DATE(s.delivery_date, 'MM/DD/YYYY') AS delivery_dt
    FROM staging.stg_sales s
)

INSERT INTO warehouse.fact_sales (
    order_number,
    line_item,
    order_date_key,
    delivery_date_key,
    customer_key,
    store_key,
    product_key,
    exchange_rate_key,
    quantity,
    currency_code,
    unit_price_usd,
    unit_cost_usd,
    line_cost_usd,
    line_revenue_usd,
    line_profit_usd,
    days_to_deliver
)

SELECT
    s.order_number,
    s.line_item,

    -- Date Keys
    TO_CHAR(s.order_dt, 'YYYYMMDD')::INTEGER AS order_date_key,
    CASE 
        WHEN s.delivery_dt IS NOT NULL 
        THEN TO_CHAR(s.delivery_dt, 'YYYYMMDD')::INTEGER
        ELSE NULL
    END AS delivery_date_key,

    s.customer_key,
    s.store_key,
    s.product_key,
    er.exchange_rate_key,

    s.quantity,
    s.currency_clean AS currency_code,

    p.unit_price_usd,
    p.unit_cost_usd,

    -- Measures
    s.quantity * p.unit_cost_usd AS line_cost_usd,
    s.quantity * p.unit_price_usd AS line_revenue_usd,
    (s.quantity * p.unit_price_usd) - (s.quantity * p.unit_cost_usd) AS line_profit_usd,

    -- Delivery Days
    CASE 
        WHEN s.delivery_dt IS NOT NULL 
        THEN s.delivery_dt - s.order_dt
        ELSE NULL
    END AS days_to_deliver

FROM sales_clean s

INNER JOIN warehouse.dim_product p
    ON s.product_key = p.product_key

INNER JOIN warehouse.dim_exchange_rate er
    ON s.order_dt = er.rate_date
   AND er.currency = s.currency_clean

INNER JOIN warehouse.dim_customer c
    ON s.customer_key = c.customer_key

INNER JOIN warehouse.dim_store st
    ON s.store_key = st.store_key;