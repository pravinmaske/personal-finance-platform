CREATE TABLE IF NOT EXISTS raw.hsbc_transactions (

raw_id BIGSERIAL PRIMARY KEY,
transaction_date DATE,
description VARCHAR(200),
paid_out NUMERIC(12,2),
paid_in NUMERIC(12,2),
balance NUMERIC(12,2),

account_name VARCHAR(50),
source_file_name VARCHAR(200),
ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);