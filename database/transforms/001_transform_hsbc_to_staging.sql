-- =============================================================
-- 001_transform_hsbc_to_staging.sql
-- Loads raw.hsbc_transactions → staging.transactions_normalized
--
-- Classification:
--   INCOME / SALARY_PRAVIN    → JAGUAR LAND ROVER paid_in
--   TRANSFER / HSBC_WIFE_TRANSFER → AJABE paid_in (wife sending to HSBC)
--   TRANSFER / HSBC_TO_REVOLUT   → Pravin Maske Revoult paid_out
--   TRANSFER / HSBC_TO_INDIA     → 401672 paid_out
--   TRANSFER / HSBC_TO_WIFE      → Aishwarya Ajabe paid_out (Pravin sending back to wife)
--   INVESTMENT / TRADING_212     → Trading 212 paid_out
--   EXPENSE                      → all other paid_out
--   REFUND                       → all other paid_in
-- =============================================================

INSERT INTO staging.transactions_normalized (
    account_name, source_file_name, ingestion_timestamp,
    transaction_datetime, description, amount, currency,
    transaction_class, transaction_sub_type, raw_transaction_type
)
SELECT
    account_name, source_file_name, ingestion_timestamp,
    transaction_date::TIMESTAMP,
    REGEXP_REPLACE(description, E'[\\n\\r\\t]+', ' ', 'g') AS description,
    CASE
        WHEN paid_out IS NOT NULL THEN -paid_out
        WHEN paid_in  IS NOT NULL THEN  paid_in
    END AS amount,
    'GBP',
    -- transaction_class
    CASE
        WHEN paid_in  IS NOT NULL AND description ILIKE '%JAGUAR LAND ROVER%'                   THEN 'INCOME'
        WHEN paid_in  IS NOT NULL AND description ILIKE '%AJABE%'                               THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL AND description ILIKE '%Pravin Maske Revoult%'                THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL AND description ILIKE '%401672%'                              THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL AND (description ILIKE '%Aishwarya Ajabe%'
                                    OR description ILIKE '%Wife Transfer%')                     THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL AND description ILIKE '%Trading 212%'                         THEN 'INVESTMENT'
        WHEN paid_out IS NOT NULL                                                               THEN 'EXPENSE'
        WHEN paid_in  IS NOT NULL                                                               THEN 'REFUND'
    END,
    -- transaction_sub_type
    CASE
        WHEN paid_in  IS NOT NULL AND description ILIKE '%JAGUAR LAND ROVER%'                   THEN 'SALARY_PRAVIN'
        WHEN paid_in  IS NOT NULL AND description ILIKE '%AJABE%'                               THEN 'HSBC_WIFE_TRANSFER'
        WHEN paid_out IS NOT NULL AND description ILIKE '%Pravin Maske Revoult%'                THEN 'HSBC_TO_REVOLUT'
        WHEN paid_out IS NOT NULL AND description ILIKE '%401672%'                              THEN 'HSBC_TO_INDIA'
        WHEN paid_out IS NOT NULL AND (description ILIKE '%Aishwarya Ajabe%'
                                    OR description ILIKE '%Wife Transfer%')                     THEN 'HSBC_TO_WIFE'
        WHEN paid_out IS NOT NULL AND description ILIKE '%Trading 212%'                         THEN 'TRADING_212'
        WHEN paid_out IS NOT NULL                                                               THEN NULL
        WHEN paid_in  IS NOT NULL                                                               THEN 'MERCHANT_REFUND'
    END,
    'HSBC_BANK_EXPORT'
FROM raw.hsbc_transactions;
