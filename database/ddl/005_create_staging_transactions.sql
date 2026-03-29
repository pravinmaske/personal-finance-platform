-- CREATE TABLE staging.transactions_normalized (
--     transaction_id BIGSERIAL PRIMARY KEY,
--     account_name VARCHAR(30),
--     transaction_datetime TIMESTAMP,
--     description TEXT,
--     amount NUMERIC(12,2),
--     transaction_direction VARCHAR(10), -- DEBIT / CREDIT
--     currency VARCHAR(10),
--     raw_transaction_type VARCHAR(100),
--     ingestion_timestamp TIMESTAMP,
--     source_file_name TEXT
-- );


-- -- adding income type column:

-- ALTER TABLE staging.transactions_normalized
-- ADD COLUMN income_type VARCHAR(50);

-- =============================================================
-- 005_create_staging_transactions.sql
-- Single unified table — one row per transaction, all sources
--
-- transaction_class values:
--   INCOME      — money earned or received from outside
--   EXPENSE     — money spent on goods, services, bills
--   TRANSFER    — money moving between your own accounts
--   INVESTMENT  — money moved to investment accounts (Trading 212 etc)
--   REFUND      — merchant refund (money returned to you)
--
-- transaction_sub_type values (the detail within each class):
--   INCOME      → SALARY_PRAVIN, SALARY_WIFE
--   TRANSFER    → HSBC_TO_REVOLUT, REVOLUT_TOPUP,
--                 BARCLAYS_TO_HSBC, HSBC_WIFE_TRANSFER,
--                 HSBC_TO_INDIA, BARCLAYS_TO_SAVINGS
--   INVESTMENT  → TRADING_212
--   EXPENSE     → (no sub_type — use merchant category in dim)
--   REFUND      → MERCHANT_REFUND
-- =============================================================

DROP TABLE IF EXISTS staging.transactions_normalized;

CREATE TABLE staging.transactions_normalized (
    id                      SERIAL PRIMARY KEY,
    -- Source traceability
    account_name            TEXT            NOT NULL,   -- HSBC | REVOLUT | BARCLAYS
    source_file_name        TEXT,
    ingestion_timestamp     TIMESTAMP       NOT NULL DEFAULT NOW(),
    -- Core transaction fields
    transaction_datetime    TIMESTAMP       NOT NULL,
    description             TEXT            NOT NULL,
    -- Amount: always SIGNED
    --   negative = money leaving the account
    --   positive = money arriving in the account
    amount                  NUMERIC(12, 2)  NOT NULL,
    currency                TEXT            NOT NULL DEFAULT 'GBP',
    -- Classification
    transaction_class       TEXT,           -- INCOME | EXPENSE | TRANSFER | INVESTMENT | REFUND
    transaction_sub_type    TEXT,           -- see header above
    -- Raw source fields for debugging
    raw_transaction_type    TEXT            -- Revolut: Card Payment / Transfer / Topup etc
);

-- Indexes for common query patterns
CREATE INDEX idx_stg_datetime    ON staging.transactions_normalized (transaction_datetime);
CREATE INDEX idx_stg_account     ON staging.transactions_normalized (account_name);
CREATE INDEX idx_stg_class       ON staging.transactions_normalized (transaction_class);
CREATE INDEX idx_stg_month       ON staging.transactions_normalized (DATE_TRUNC('month', transaction_datetime));
