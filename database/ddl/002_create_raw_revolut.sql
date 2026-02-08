CREATE TABLE raw.revolut_transactions (
    raw_id BIGSERIAL PRIMARY KEY,
    transaction_type VARCHAR(100),      -- Type
    product VARCHAR(50),               -- Product
    started_at TIMESTAMP,              -- Started Date
    completed_at TIMESTAMP,            -- Completed Date
    description VARCHAR(150),                  -- Description
    amount NUMERIC(12,2),              -- Signed amount
    fee NUMERIC(12,2),
    currency VARCHAR(10),
    state VARCHAR(30),
    balance NUMERIC(12,2),

    source_file_name VARCHAR(100),
    account_name VARCHAR(30) DEFAULT 'REVOLUT',
    ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
