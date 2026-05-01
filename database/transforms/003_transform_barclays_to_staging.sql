-- =============================================================
-- 003_transform_barclays_to_staging.sql
-- Loads raw.barclays_transactions → staging.transactions_normalized
--
-- Classification:
--   INCOME / SALARY_WIFE
--     → "John Crane UK" paid_in (wife's salary)
--
--   TRANSFER / BARCLAYS_TO_HSBC
--     → "Husband Transfer" paid_out          (regular monthly transfer)
--     → "Bill Payment to Pravin Maske HSBC"  (reimbursement — e.g. April rent payback)
--
--   TRANSFER / BARCLAYS_TO_REVOLUT
--     → "Bill Payment to Pravin Maske Revolut" paid_out
--       (wife funding Revolut directly — nursery fees, shared expenses)
--
--   TRANSFER / BARCLAYS_TO_SAVINGS
--     → "emergency fund" paid_out
--
--   EXPENSE → any other paid_out
--   REFUND  → any other paid_in
-- =============================================================

INSERT INTO staging.transactions_normalized (
    account_name,
    source_file_name,
    ingestion_timestamp,
    transaction_datetime,
    description,
    amount,
    currency,
    transaction_class,
    transaction_sub_type,
    raw_transaction_type
)
SELECT
    account_name,
    source_file_name,
    ingestion_timestamp,
    transaction_date::TIMESTAMP,
    description,
    CASE
        WHEN paid_out IS NOT NULL THEN -paid_out
        WHEN paid_in  IS NOT NULL THEN  paid_in
    END AS amount,
    'GBP' AS currency,
    CASE
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%John Crane%'
            THEN 'INCOME'
        WHEN paid_out IS NOT NULL
         AND (description ILIKE '%Husband Transfer%'
           OR description ILIKE '%Bill Payment to Pravin Maske HSBC%')
            THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Bill Payment to Pravin Maske Revolut%'
            THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%emergency fund%'
            THEN 'TRANSFER'
        WHEN paid_out IS NOT NULL
            THEN 'EXPENSE'
        WHEN paid_in IS NOT NULL
            THEN 'REFUND'
    END AS transaction_class,
    CASE
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%John Crane%'
            THEN 'SALARY_WIFE'
        WHEN paid_out IS NOT NULL
         AND (description ILIKE '%Husband Transfer%'
           OR description ILIKE '%Bill Payment to Pravin Maske HSBC%')
            THEN 'BARCLAYS_TO_HSBC'

        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Bill Payment to Pravin Maske Revolut%'
            THEN 'BARCLAYS_TO_REVOLUT'
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%emergency fund%'
            THEN 'BARCLAYS_TO_SAVINGS'
        WHEN paid_out IS NOT NULL
            THEN NULL
        WHEN paid_in IS NOT NULL
            THEN 'MERCHANT_REFUND'
    END AS transaction_sub_type,
    'BARCLAYS_BANK_EXPORT' AS raw_transaction_type
FROM raw.barclays_transactions;
