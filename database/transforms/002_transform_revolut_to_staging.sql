-- =============================================================
-- 002_transform_revolut_to_staging.sql
--
-- Loads raw.revolut_transactions → staging.transactions_normalized
--
-- Revolut amount is already signed:
--   negative = money leaving Revolut
--   positive = money arriving in Revolut
--
-- transaction_type reference:
--   Topup        → money arriving from HSBC (TRANSFER_IN)
--   Card Payment → money spent at a merchant (EXPENSE)
--   Transfer     → bill payments sent out (EDF, Council Tax, Gym) → EXPENSE
--   Card Refund  → merchant refunding money (REFUND)
--
-- Classification logic:
--
--   TRANSFER / REVOLUT_TOPUP
--     → transaction_type = 'Topup' AND description ILIKE '%Payment from MASKE%'
--       (counterpart is HSBC "Pravin Maske Revoult" TRANSFER_OUT)
--
--   EXPENSE
--     → transaction_type IN ('Card Payment', 'Transfer') AND amount < 0
--       This includes EDF Energy, Coventry Cc (council tax),
--       Coventry Sports (gym) — all real spending even though
--       Revolut labels them as "Transfer"
--
--   REFUND / MERCHANT_REFUND
--     → transaction_type = 'Card Refund'
--       (Trainline, Temu refunds)
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
    -- Amount already signed in Revolut export — use as-is
    amount,
    currency,
    -- transaction_class
    CASE
        -- TRANSFER: money arriving from HSBC (Pravin topping up Revolut)
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from MASKE%'
            THEN 'TRANSFER'
        -- TRANSFER: money arriving from Barclays (wife sending via AJABE)
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from AJABE%'
            THEN 'TRANSFER'
        -- INCOME: friend/family paying back
        WHEN transaction_type = 'Transfer'
         AND amount > 0
         AND description ILIKE '%Transfer from%'
            THEN 'INCOME'
        -- REFUND: merchant returning money
        WHEN transaction_type = 'Card Refund'
            THEN 'REFUND'
        -- EXPENSE: card payments, bill transfers, and Rev Payments going out
        WHEN transaction_type IN ('Card Payment', 'Transfer', 'Rev Payment')
         AND amount < 0
            THEN 'EXPENSE'
        ELSE NULL
    END AS transaction_class,
    -- transaction_sub_type
    CASE
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from MASKE%'
            THEN 'REVOLUT_TOPUP'
        -- Barclays → Revolut (wife funding Revolut directly)
        WHEN transaction_type = 'Topup'
         AND description ILIKE '%Payment from AJABE%'
            THEN 'BARCLAYS_TO_REVOLUT'
        -- Friend/family repayment
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
