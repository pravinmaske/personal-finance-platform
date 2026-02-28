CREATE TABLE staging.transactions_normalized (
    transaction_id BIGSERIAL PRIMARY KEY,
    account_name VARCHAR(30),
    transaction_datetime TIMESTAMP,
    description TEXT,
    amount NUMERIC(12,2),
    transaction_direction VARCHAR(10), -- DEBIT / CREDIT
    currency VARCHAR(10),
    raw_transaction_type VARCHAR(100),
    ingestion_timestamp TIMESTAMP,
    source_file_name TEXT
);
