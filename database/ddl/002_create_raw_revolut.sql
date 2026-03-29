-- CREATE TABLE raw.revolut_transactions (
--     raw_id BIGSERIAL PRIMARY KEY,
--     transaction_type VARCHAR(100),      -- Type
--     product VARCHAR(50),               -- Product
--     started_at TIMESTAMP,              -- Started Date
--     completed_at TIMESTAMP,            -- Completed Date
--     description VARCHAR(150),                  -- Description
--     amount NUMERIC(12,2),              -- Signed amount
--     fee NUMERIC(12,2),
--     currency VARCHAR(10),
--     state VARCHAR(30),
--     balance NUMERIC(12,2),

--     source_file_name VARCHAR(100),
--     account_name VARCHAR(30) DEFAULT 'REVOLUT',
--     ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );


-- =============================================================
-- 003_create_raw_revolut.sql
-- Raw Revolut transactions — preserve source structure exactly
-- =============================================================

DROP TABLE IF EXISTS raw.revolut_transactions;

CREATE TABLE raw.revolut_transactions (
    raw_id              SERIAL PRIMARY KEY,
    transaction_type    TEXT,                       -- Card Payment, Transfer, Topup, Card Refund
    product             TEXT,
    started_at          TIMESTAMP,
    completed_at        TIMESTAMP       NOT NULL,
    description         TEXT            NOT NULL,
    amount              NUMERIC(12, 2)  NOT NULL,   -- negative = outflow, positive = inflow
    fee                 NUMERIC(12, 2)  DEFAULT 0,
    currency            TEXT            DEFAULT 'GBP',
    state               TEXT,
    balance             NUMERIC(12, 2),
    account_name        TEXT            NOT NULL DEFAULT 'REVOLUT',
    source_file_name    TEXT,
    ingestion_timestamp TIMESTAMP       NOT NULL DEFAULT NOW()
);