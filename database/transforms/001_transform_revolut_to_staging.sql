--- clear staging before reload 
-- Clear staging before reload (important habit)
TRUNCATE TABLE staging.transactions_normalized;

INSERT INTO staging.transactions_normalized (
    account_name,
    transaction_datetime,
    description,
    amount,
    transaction_direction,
    currency,
    raw_transaction_type,
    ingestion_timestamp,
    source_file_name
)
SELECT
    account_name,
    completed_at,
    description,
    ABS(amount),
    CASE 
        WHEN amount < 0 THEN 'DEBIT'
        ELSE 'CREDIT'
    END,
    currency,
    transaction_type,
    ingestion_timestamp,
    source_file_name
FROM raw.revolut_transactions;
