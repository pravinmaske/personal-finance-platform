-- =============================================================
-- 002_transform_revolut_to_staging.sql
-- Loads raw.revolut_transactions → staging.transactions_normalized
--
-- Revolut amount is already signed:
--   negative = money leaving, positive = money arriving
--
-- transaction_type reference:
--   Topup        → money arriving (transfer in)
--   Card Payment → merchant spend (EXPENSE)
--   Transfer     → bill payments out (EXPENSE) or person transfers
--   Rev Payment  → Revolut-native payments e.g. Booking.com (EXPENSE)
--   Card Refund  → merchant refund (REFUND)
--
-- Classification:
--   TRANSFER / REVOLUT_TOPUP
--     → Topup from MASKE (from HSBC)
--
--   TRANSFER / BARCLAYS_TO_REVOLUT
--     → Topup from AJABE (from Barclays)
--
--   TRANSFER / PERSONAL_TRANSFER
--     → Transfer TO a named person (e.g. Rajesh) — not real spending
--
--   INCOME / OTHER_INCOME
--     → Transfer FROM a named person (e.g. Rajesh paying back)
--
--   REFUND / MERCHANT_REFUND
--     → Card Refund type
--
--   EXPENSE
--     → Card Payment, Transfer (bills), Rev Payment — amount < 0
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
    completed_at,
    description,
    amount,
    currency,
    CASE
        -- TRANSFER: money arriving from HSBC (Pravin topping up Revolut)
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from MASKE%'
            THEN 'TRANSFER'
        -- TRANSFER: money arriving from Barclays (wife via AJABE)
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from AJABE%'
            THEN 'TRANSFER'
        -- INCOME: person paying Pravin back (e.g. Rajesh repayment March)
        WHEN transaction_type = 'Transfer'
         AND amount > 0
         AND description ILIKE '%Transfer from%'
            THEN 'INCOME'
        -- REFUND: merchant returning money
        WHEN transaction_type = 'Card Refund'
            THEN 'REFUND'
        -- EXPENSE: all outgoing card payments, bill transfers, Rev Payments
        -- including person-to-person transfers for shared expenses (e.g. Belfast trip)
        WHEN transaction_type IN ('Card Payment', 'Transfer', 'Rev Payment')
         AND amount < 0
            THEN 'EXPENSE'
        ELSE NULL
    END AS transaction_class,
    CASE
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from MASKE%'
            THEN 'REVOLUT_TOPUP'
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from AJABE%'
            THEN 'BARCLAYS_TO_REVOLUT'
        WHEN transaction_type = 'Transfer'
         AND amount > 0
         AND description ILIKE '%Transfer from%'
            THEN 'OTHER_INCOME'
        WHEN transaction_type = 'Card Refund'
            THEN 'MERCHANT_REFUND'
        WHEN transaction_type IN ('Card Payment', 'Transfer', 'Rev Payment')
         AND amount < 0
            THEN NULL   -- EXPENSE: category resolved via dim.merchant_category
        ELSE NULL
    END AS transaction_sub_type,
    transaction_type AS raw_transaction_type
FROM raw.revolut_transactions;
