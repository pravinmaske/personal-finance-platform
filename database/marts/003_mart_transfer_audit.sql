-- =============================================================
-- 003_mart_transfer_audit.sql
--
-- mart.transfer_audit
-- Validates that every internal transfer has a matching counterpart.
-- Net total per transfer pair should always be zero.
--
-- Transfer pairs in this pipeline:
--
--   HSBC_TO_REVOLUT  ↔  REVOLUT_TOPUP
--     Pravin moves money from HSBC to Revolut
--     HSBC side: negative (money out)
--     Revolut side: positive (money in)
--     Net must = 0
--
--   BARCLAYS_TO_HSBC  ↔  HSBC_WIFE_TRANSFER
--     Wife sends money from Barclays to Pravin's HSBC
--     Barclays side: negative (money out)
--     HSBC side: positive (money in)
--     Net must = 0
--
--   HSBC_TO_INDIA (one-sided — India account not in pipeline)
--     These will not net to zero — that is expected.
--
--   BARCLAYS_TO_SAVINGS (one-sided — savings account not in pipeline)
--     These will not net to zero — that is expected.
-- =============================================================

CREATE OR REPLACE VIEW mart.transfer_audit AS

-- Pair 1: HSBC → Revolut
SELECT
    'HSBC_TO_REVOLUT ↔ REVOLUT_TOPUP'              AS transfer_pair,
    SUM(amount) FILTER (
        WHERE transaction_sub_type = 'HSBC_TO_REVOLUT'
    )                                               AS hsbc_side,
    SUM(amount) FILTER (
        WHERE transaction_sub_type = 'REVOLUT_TOPUP'
    )                                               AS revolut_side,
    SUM(amount) FILTER (
        WHERE transaction_sub_type IN ('HSBC_TO_REVOLUT', 'REVOLUT_TOPUP')
    )                                               AS net,
    CASE
        WHEN ABS(SUM(amount) FILTER (
            WHERE transaction_sub_type IN ('HSBC_TO_REVOLUT', 'REVOLUT_TOPUP')
        )) < 0.01
        THEN 'PASS'
        ELSE 'FAIL — amounts do not match'
    END                                             AS status

FROM staging.transactions_normalized
WHERE transaction_class = 'TRANSFER'

UNION ALL

-- Pair 2: Barclays → HSBC (wife transfers)
SELECT
    'BARCLAYS_TO_HSBC ↔ HSBC_WIFE_TRANSFER',
    SUM(amount) FILTER (
        WHERE transaction_sub_type = 'BARCLAYS_TO_HSBC'
    ),
    SUM(amount) FILTER (
        WHERE transaction_sub_type = 'HSBC_WIFE_TRANSFER'
    ),
    SUM(amount) FILTER (
        WHERE transaction_sub_type IN ('BARCLAYS_TO_HSBC', 'HSBC_WIFE_TRANSFER')
    ),
    CASE
        WHEN ABS(SUM(amount) FILTER (
            WHERE transaction_sub_type IN ('BARCLAYS_TO_HSBC', 'HSBC_WIFE_TRANSFER')
        )) < 0.01
        THEN 'PASS'
        ELSE 'FAIL — amounts do not match'
    END

FROM staging.transactions_normalized
WHERE transaction_class = 'TRANSFER'

UNION ALL

-- Pair 3: HSBC → India (one-sided — no counterpart in pipeline)
SELECT
    'HSBC_TO_INDIA (one-sided, no counterpart)',
    SUM(amount) FILTER (WHERE transaction_sub_type = 'HSBC_TO_INDIA'),
    NULL,
    SUM(amount) FILTER (WHERE transaction_sub_type = 'HSBC_TO_INDIA'),
    'INFO — India account not in pipeline'
FROM staging.transactions_normalized
WHERE transaction_class = 'TRANSFER'

UNION ALL

-- Pair 4: Barclays → Savings (one-sided)
SELECT
    'BARCLAYS_TO_SAVINGS (one-sided, no counterpart)',
    SUM(amount) FILTER (WHERE transaction_sub_type = 'BARCLAYS_TO_SAVINGS'),
    NULL,
    SUM(amount) FILTER (WHERE transaction_sub_type = 'BARCLAYS_TO_SAVINGS'),
    'INFO — savings account not in pipeline'
FROM staging.transactions_normalized
WHERE transaction_class = 'TRANSFER';
