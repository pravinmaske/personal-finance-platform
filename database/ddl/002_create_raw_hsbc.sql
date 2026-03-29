-- CREATE TABLE IF NOT EXISTS raw.hsbc_transactions (

-- raw_id BIGSERIAL PRIMARY KEY,
-- transaction_date DATE,
-- description VARCHAR(200),
-- paid_out NUMERIC(12,2),
-- paid_in NUMERIC(12,2),
-- balance NUMERIC(12,2),

-- account_name VARCHAR(50),
-- source_file_name VARCHAR(200),
-- ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP

-- );

-- -- update table raw.hsbc_transactions set account_name = "HSBC", source_file_name = "hsbc_2026_jan_feb.csv";
-- UPDATE raw.hsbc_transactions 
-- SET account_name = 'HSBC', 
--     source_file_name = 'hsbc_2026_jan_feb.csv';

-- select * from raw.hsbc_transactions; 


-- =============================================================
-- 002_create_raw_hsbc.sql
-- Raw HSBC transactions — preserve source structure exactly
-- =============================================================

DROP TABLE IF EXISTS raw.hsbc_transactions;

CREATE TABLE raw.hsbc_transactions (
    raw_id              SERIAL PRIMARY KEY,
    transaction_date    DATE            NOT NULL,
    description         TEXT            NOT NULL,
    paid_out            NUMERIC(12, 2),             -- money leaving HSBC (positive value)
    paid_in             NUMERIC(12, 2),             -- money arriving in HSBC (positive value)
    balance             NUMERIC(12, 2),
    account_name        TEXT            NOT NULL DEFAULT 'HSBC',
    source_file_name    TEXT,
    ingestion_timestamp TIMESTAMP       NOT NULL DEFAULT NOW()
);