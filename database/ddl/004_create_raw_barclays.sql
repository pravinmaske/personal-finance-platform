-- =============================================================
-- 004_create_raw_barclays.sql
-- Raw Barclays transactions — preserve source structure exactly
-- Same paid_in / paid_out shape as HSBC
-- =============================================================

DROP TABLE IF EXISTS raw.barclays_transactions;

CREATE TABLE raw.barclays_transactions (
    raw_id              SERIAL PRIMARY KEY,
    transaction_date    DATE            NOT NULL,
    description         TEXT            NOT NULL,
    paid_out            NUMERIC(12, 2),             -- money leaving Barclays (positive value)
    paid_in             NUMERIC(12, 2),             -- money arriving in Barclays (positive value)
    balance             NUMERIC(12, 2),
    account_name        TEXT            NOT NULL DEFAULT 'BARCLAYS',
    source_file_name    TEXT,
    ingestion_timestamp TIMESTAMP       NOT NULL DEFAULT NOW()
);
