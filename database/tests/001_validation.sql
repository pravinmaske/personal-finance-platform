-- =============================================================
-- 001_validation.sql
--
-- Run after 001_reload_staging.sql to verify your pipeline.
-- Expected values are calculated from raw source data.
-- Every query should return zero rows if the pipeline is correct.
-- =============================================================


-- -------------------------------------------------------------
-- TEST 1: No unclassified rows
-- Every row must have a transaction_class. NULL means the
-- classification logic has a gap.
-- Expected: 0 rows
-- -------------------------------------------------------------
SELECT
    'TEST 1 FAIL — unclassified rows exist' AS test,
    account_name,
    description,
    amount
FROM staging.transactions_normalized
WHERE transaction_class IS NULL;


-- -------------------------------------------------------------
-- TEST 2: Salary amounts correct
-- Pravin Jan: £3,195.32  Pravin Feb: £3,195.31
-- Wife   Jan: £2,790.10  Wife   Feb: £2,790.30
-- Expected: 0 rows
-- -------------------------------------------------------------
WITH salary_check AS (
    SELECT
        DATE_TRUNC('month', transaction_datetime)   AS month,
        transaction_sub_type,
        SUM(amount)                                 AS actual
    FROM staging.transactions_normalized
    WHERE transaction_sub_type IN ('SALARY_PRAVIN', 'SALARY_WIFE')
    GROUP BY 1, 2
)
SELECT
    'TEST 2 FAIL — salary mismatch' AS test,
    salary_check.month,
    transaction_sub_type,
    actual,
    expected
FROM salary_check
JOIN (VALUES
    ('2026-01-01'::DATE, 'SALARY_PRAVIN', 3195.32),
    ('2026-02-01'::DATE, 'SALARY_PRAVIN', 3195.31),
    ('2026-03-01'::DATE, 'SALARY_PRAVIN', 3194.91),
    ('2026-01-01'::DATE, 'SALARY_WIFE',   2790.10),
    ('2026-02-01'::DATE, 'SALARY_WIFE',   2790.30),
    ('2026-03-01'::DATE, 'SALARY_WIFE',   2790.30)
) AS expected_vals (month, sub_type, expected)
    ON salary_check.month = expected_vals.month
   AND salary_check.transaction_sub_type = expected_vals.sub_type
WHERE ABS(actual - expected) > 0.01;


-- -------------------------------------------------------------
-- TEST 3: HSBC ↔ Revolut transfer net = 0
-- HSBC_TO_REVOLUT + REVOLUT_TOPUP must sum to exactly zero
-- Expected: 0 rows (i.e. net IS zero)
-- -------------------------------------------------------------
SELECT
    'TEST 3 FAIL — HSBC↔Revolut transfer net not zero' AS test,
    SUM(amount) AS net
FROM staging.transactions_normalized
WHERE transaction_sub_type IN ('HSBC_TO_REVOLUT', 'REVOLUT_TOPUP')
HAVING ABS(SUM(amount)) > 0.01;


-- -------------------------------------------------------------
-- TEST 4: Barclays ↔ HSBC wife transfer net = 0
-- BARCLAYS_TO_HSBC + HSBC_WIFE_TRANSFER must sum to zero
-- Expected: 0 rows
-- -------------------------------------------------------------
SELECT
    'TEST 4 FAIL — Barclays↔HSBC wife transfer net not zero' AS test,
    SUM(amount) AS net
FROM staging.transactions_normalized
WHERE transaction_sub_type IN ('BARCLAYS_TO_HSBC', 'HSBC_WIFE_TRANSFER')
HAVING ABS(SUM(amount)) > 0.01;


-- -------------------------------------------------------------
-- TEST 5: January HSBC expenses match expected
-- £1,295.64 = all paid_out except transfers (Pravin Maske, 401672) and investment (Trading 212)
-- Includes JLR vending machine £0.65 — confirmed real expense
-- Expected: 0 rows
-- -------------------------------------------------------------
SELECT
    'TEST 5 FAIL — Jan HSBC expense total mismatch' AS test,
    SUM(ABS(amount))    AS actual,
    1295.64             AS expected
FROM staging.transactions_normalized
WHERE account_name = 'HSBC'
  AND transaction_class = 'EXPENSE'
  AND DATE_TRUNC('month', transaction_datetime) = '2026-01-01'
HAVING ABS(SUM(ABS(amount)) - 1295.64) > 0.01;


-- -------------------------------------------------------------
-- TEST 6: January Revolut expenses match expected
-- All Card Payment + Transfer outflows = £604.60
-- Expected: 0 rows
-- -------------------------------------------------------------
SELECT
    'TEST 6 FAIL — Jan Revolut expense total mismatch' AS test,
    SUM(ABS(amount))    AS actual,
    604.60              AS expected
FROM staging.transactions_normalized
WHERE account_name = 'REVOLUT'
  AND transaction_class = 'EXPENSE'
  AND DATE_TRUNC('month', transaction_datetime) = '2026-01-01'
HAVING ABS(SUM(ABS(amount)) - 604.60) > 0.01;


-- -------------------------------------------------------------
-- TEST 7: February Revolut expenses match expected
-- £1,204.69 — includes second Trainline £29.14 (two separate purchases on 8 Feb,
-- confirmed from different started_at timestamps in source CSV)
-- Expected: 0 rows
-- -------------------------------------------------------------
SELECT
    'TEST 7 FAIL — Feb Revolut expense total mismatch' AS test,
    SUM(ABS(amount))    AS actual,
    1204.69             AS expected
FROM staging.transactions_normalized
WHERE account_name = 'REVOLUT'
  AND transaction_class = 'EXPENSE'
  AND DATE_TRUNC('month', transaction_datetime) = '2026-02-01'
HAVING ABS(SUM(ABS(amount)) - 1204.69) > 0.01;


-- -------------------------------------------------------------
-- TEST 8: Row count sanity check
-- HSBC: 46 Jan/Feb + 8 March = 54
-- REVOLUT: 75 Jan/Feb + 56 March = 131
-- BARCLAYS: 7 Jan/Feb + 4 March = 11
-- Expected: 0 rows
-- -------------------------------------------------------------
WITH counts AS (
    SELECT account_name, COUNT(*) AS actual_count
    FROM staging.transactions_normalized
    GROUP BY account_name
)
SELECT
    'TEST 8 FAIL — row count mismatch' AS test,
    account_name,
    actual_count,
    expected_count
FROM counts
JOIN (VALUES
    ('HSBC',     54),
    ('REVOLUT', 131),
    ('BARCLAYS', 11)
) AS expected_counts (account_name, expected_count) USING (account_name)
WHERE actual_count <> expected_count;


-- -------------------------------------------------------------
-- SUMMARY: class distribution (informational — always run this)
-- -------------------------------------------------------------
SELECT
    account_name,
    transaction_class,
    COUNT(*)        AS row_count,
    SUM(amount)     AS total_amount
FROM staging.transactions_normalized
GROUP BY 1, 2
ORDER BY 1, 2;