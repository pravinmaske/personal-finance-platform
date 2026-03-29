-- =============================================================
-- 003_transform_barclays_to_staging.sql
--
-- Loads raw.barclays_transactions → staging.transactions_normalized
--
-- Sign convention (same as HSBC):
--   paid_out → negative (money leaving Barclays)
--   paid_in  → positive (money arriving in Barclays)
--
-- Classification logic:
--
--   INCOME / SALARY_WIFE
--     → "John Crane UK" paid_in
--       (wife's salary from her employer)
--
--   TRANSFER / BARCLAYS_TO_HSBC
--     → "Husband Transfer" paid_out
--       (wife sending money to Pravin's HSBC)
--       counterpart is HSBC "AJABE HUSBAND TRANSFER" paid_in
--
--   TRANSFER / BARCLAYS_TO_SAVINGS
--     → "emergency fund" paid_out
--       (money moved to savings — still the household's money)
--
--   EXPENSE
--     → any other paid_out not matched above
--
--   REFUND
--     → any other paid_in not matched above
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
    -- transaction_class
    CASE
        -- INCOME: wife's salary
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%John Crane%'
            THEN 'INCOME'
        -- TRANSFER: wife sending to Pravin's HSBC
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Husband Transfer%'
            THEN 'TRANSFER'
        -- TRANSFER: moving money to savings/emergency fund
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%emergency fund%'
            THEN 'TRANSFER'
        -- EXPENSE: any other paid_out
        WHEN paid_out IS NOT NULL
            THEN 'EXPENSE'
        -- REFUND: any other paid_in
        WHEN paid_in IS NOT NULL
            THEN 'REFUND'
    END AS transaction_class,
    -- transaction_sub_type
    CASE
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%John Crane%'
            THEN 'SALARY_WIFE'

        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Husband Transfer%'
            THEN 'BARCLAYS_TO_HSBC'

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
