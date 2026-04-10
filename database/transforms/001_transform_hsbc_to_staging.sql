-- =============================================================
-- 001_transform_hsbc_to_staging.sql
--
-- Loads raw.hsbc_transactions → staging.transactions_normalized
--
-- Sign convention:
--   paid_out → negative amount (money leaving)
--   paid_in  → positive amount (money arriving)
--
-- Classification logic (applied in a single pass):
--
--   INCOME / SALARY_PRAVIN
--     → JAGUAR LAND ROVER paid_in (main salary credit)
--
--   TRANSFER / HSBC_TO_REVOLUT
--     → "Pravin Maske Revoult" paid_out
--       (Pravin moving money from HSBC to his Revolut)
--
--   TRANSFER / HSBC_TO_INDIA
--     → "401672" paid_out
--       (Pravin sending money to India — home loan EMI + other)
--
--   TRANSFER / HSBC_WIFE_TRANSFER  (wife sending IN to HSBC)
--     → "AJABE" paid_in
--       (counterpart is BARCLAYS Husband Transfer paid_out)
--
--   INVESTMENT / TRADING_212
--     → "Trading 212" paid_out
--
--   EXPENSE / (no sub_type — category resolved via dim.merchant_category)
--     → all remaining paid_out rows
--
--   REFUND / MERCHANT_REFUND
--     → paid_in rows that are NOT salary and NOT wife transfers
--       (e.g. Trainline refund credited back)
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
    -- Clean up newline characters that HSBC embeds in descriptions
    REGEXP_REPLACE(description, E'[\\n\\r]+', ' ', 'g') AS description,
    -- Signed amount: paid_out = negative, paid_in = positive
    CASE
        WHEN paid_out IS NOT NULL THEN -paid_out
        WHEN paid_in  IS NOT NULL THEN  paid_in
    END AS amount,
    'GBP' AS currency,
    -- transaction_class
    CASE
        -- INCOME: salary credit
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%JAGUAR LAND ROVER%'
            THEN 'INCOME'
        -- TRANSFER: wife sending from Barclays into this HSBC
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%AJABE%'
            THEN 'TRANSFER'
        -- TRANSFER: Pravin moving money out to Revolut
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Pravin Maske Revoult%'
            THEN 'TRANSFER'
        -- TRANSFER: Pravin sending to India account
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%401672%'
            THEN 'TRANSFER'
        -- INVESTMENT: Trading 212
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Trading 212%'
            THEN 'INVESTMENT'
        -- EXPENSE: all other paid_out
        WHEN paid_out IS NOT NULL
            THEN 'EXPENSE'
        -- REFUND: any other paid_in (not salary, not wife transfer)
        WHEN paid_in IS NOT NULL
            THEN 'REFUND'
    END AS transaction_class,
    -- transaction_sub_type
    CASE
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%JAGUAR LAND ROVER%'
            THEN 'SALARY_PRAVIN'
        WHEN paid_in IS NOT NULL
         AND description ILIKE '%AJABE%'
            THEN 'HSBC_WIFE_TRANSFER'
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Pravin Maske Revoult%'
            THEN 'HSBC_TO_REVOLUT'
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%401672%'
            THEN 'HSBC_TO_INDIA'
        WHEN paid_out IS NOT NULL
         AND description ILIKE '%Trading 212%'
            THEN 'TRADING_212'
        WHEN paid_out IS NOT NULL
            THEN NULL   -- EXPENSE: category comes from dim.merchant_category
        WHEN paid_in IS NOT NULL
            THEN 'MERCHANT_REFUND'
    END AS transaction_sub_type,
    'HSBC_BANK_EXPORT' AS raw_transaction_type
FROM raw.hsbc_transactions;
