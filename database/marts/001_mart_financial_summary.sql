-- =============================================================
-- 001_mart_financial_summary.sql
--
-- mart.financial_summary
-- Monthly household P&L view
--
-- Columns:
--   month             — truncated to first of month
--   pravin_salary     — Pravin's JLR salary (HSBC)
--   wife_salary       — Wife's John Crane salary (Barclays)
--   household_income  — total of both salaries
--   total_expense     — all EXPENSE rows (positive for readability)
--   total_refunds     — money returned by merchants (positive)
--   net_expense       — total_expense - total_refunds
--   total_investment  — money moved to Trading 212 etc
--   net_flow          — household_income - net_expense - total_investment
--   savings_rate_pct  — net_flow / household_income * 100
--
-- EXCLUDES transfers (internal account moves net to zero)
-- =============================================================

CREATE OR REPLACE VIEW mart.financial_summary AS
SELECT
    DATE_TRUNC('month', transaction_datetime)           AS month,

    -- Pravin's salary
    SUM(amount) FILTER (
        WHERE transaction_sub_type = 'SALARY_PRAVIN'
    )                                                   AS pravin_salary,

    -- Wife's salary
    SUM(amount) FILTER (
        WHERE transaction_sub_type = 'SALARY_WIFE'
    )                                                   AS wife_salary,

    -- Combined household income
    SUM(amount) FILTER (
        WHERE transaction_class = 'INCOME'
    )                                                   AS household_income,

    -- Total spending (shown as positive)
    ABS(SUM(amount) FILTER (
        WHERE transaction_class = 'EXPENSE'
    ))                                                  AS total_expense,

    -- Refunds received (shown as positive)
    SUM(amount) FILTER (
        WHERE transaction_class = 'REFUND'
    )                                                   AS total_refunds,

    -- Net expense after refunds (shown as positive)
    ABS(SUM(amount) FILTER (
        WHERE transaction_class = 'EXPENSE'
    )) - COALESCE(SUM(amount) FILTER (
        WHERE transaction_class = 'REFUND'
    ), 0)                                               AS net_expense,

    -- Money moved to investments (shown as positive)
    ABS(SUM(amount) FILTER (
        WHERE transaction_class = 'INVESTMENT'
    ))                                                  AS total_investment,

    -- Net flow = income - net_expense - investment
    SUM(amount) FILTER (WHERE transaction_class = 'INCOME')
    + SUM(amount) FILTER (WHERE transaction_class = 'EXPENSE')
    + COALESCE(SUM(amount) FILTER (WHERE transaction_class = 'REFUND'), 0)
    + COALESCE(SUM(amount) FILTER (WHERE transaction_class = 'INVESTMENT'), 0)
                                                        AS net_flow,

    -- Savings rate %
    CASE
        WHEN SUM(amount) FILTER (WHERE transaction_class = 'INCOME') = 0
            THEN 0
        ELSE ROUND(
            (
                SUM(amount) FILTER (WHERE transaction_class = 'INCOME')
                + SUM(amount) FILTER (WHERE transaction_class = 'EXPENSE')
                + COALESCE(SUM(amount) FILTER (WHERE transaction_class = 'REFUND'), 0)
                + COALESCE(SUM(amount) FILTER (WHERE transaction_class = 'INVESTMENT'), 0)
            )
            / SUM(amount) FILTER (WHERE transaction_class = 'INCOME')
            * 100
        , 1)
    END                                                 AS savings_rate_pct

FROM staging.transactions_normalized
GROUP BY 1
ORDER BY 1;
