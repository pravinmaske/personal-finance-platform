-- CREATE TABLE dim.merchant_category (

--     merchant_name VARCHAR(150) PRIMARY KEY,
--     category VARCHAR(100),
--     sub_category VARCHAR(100)

-- );

-- =============================================================
-- 006_create_dim_merchant_category.sql
-- Maps merchant description keywords → spending category
-- =============================================================

DROP TABLE IF EXISTS dim.merchant_category;

CREATE TABLE dim.merchant_category (
    id              SERIAL PRIMARY KEY,
    keyword         TEXT    NOT NULL UNIQUE,    -- matched via ILIKE in transforms
    category        TEXT    NOT NULL,           -- Groceries, Transport, Bills etc
    subcategory     TEXT                        -- optional finer grain
);
