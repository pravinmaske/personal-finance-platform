--- clear staging before reload 
-- Clear staging before reload (important habit)
TRUNCATE TABLE staging.transactions_normalized;

-- INSERT INTO staging.transactions_normalized (
--     account_name,
--     transaction_datetime,
--     description,
--     amount,
--     transaction_direction,
--     transaction_class,
--     currency,
--     raw_transaction_type,
--     ingestion_timestamp,
--     source_file_name
-- )
-- SELECT
--     account_name,
--     completed_at,
--     description,
--     ABS(amount),
--     CASE
--         WHEN description ILIKE '%Payment from MASKE%' THEN 'TRANSFER_IN'
--         WHEN description ILIKE '%Payment from AJABE A%' THEN 'TRANSFER_IN'

--         WHEN description ILIKE '%refund%' THEN 'REFUND'

--         WHEN amount < 0 THEN 'EXPENSE'

--         ELSE 'INCOME'
--     END AS transaction_class,
--     currency,
--     transaction_type,
--     ingestion_timestamp,
--     source_file_name
-- FROM raw.revolut_transactions;


INSERT INTO staging.transactions_normalized (
    account_name,
    transaction_datetime,
    description,
    amount,
    transaction_direction,
    transaction_class,
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
    CASE
        WHEN description ILIKE '%Payment from MASKE%' THEN 'TRANSFER_IN'
        WHEN description ILIKE '%Payment from AJABE A%' THEN 'TRANSFER_IN'
		  WHEN description ILIKE '%refund%' THEN 'REFUND'
        WHEN amount < 0 THEN 'EXPANSE'
        ELSE 'INCOME'
    END,
    currency,
    transaction_type,
    ingestion_timestamp,
    source_file_name
FROM raw.revolut_transactions;