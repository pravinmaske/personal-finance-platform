-- =============================================================
-- 006_mart_investment_tracker.sql
--
-- mart.investment_tracker
-- Tracks every outflow that is wealth-building in nature:
--   - Trading 212 / SIPs (INVESTMENT class)
--   - India home loan EMI (HSBC_TO_INDIA — building equity)
--   - Emergency fund top-ups (BARCLAYS_TO_SAVINGS)
--
-- Gives you a running cumulative total so you can see
-- how your wealth-building compounds over time.
-- =============================================================

CREATE OR REPLACE VIEW mart.investment_tracker AS
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', transaction_datetime)       AS month,

        ABS(COALESCE(SUM(amount) FILTER (
            WHERE transaction_sub_type = 'TRADING_212'
        ), 0))                                          AS trading_212,

        ABS(COALESCE(SUM(amount) FILTER (
            WHERE transaction_sub_type = 'HSBC_TO_INDIA'
        ), 0))                                          AS india_home_loan,

        ABS(COALESCE(SUM(amount) FILTER (
            WHERE transaction_sub_type = 'BARCLAYS_TO_SAVINGS'
        ), 0))                                          AS emergency_fund,

        SUM(amount) FILTER (
            WHERE transaction_class = 'INCOME'
        )                                               AS household_income

    FROM staging.transactions_normalized
    GROUP BY 1
)
SELECT
    month,
    trading_212,
    india_home_loan,
    emergency_fund,
    trading_212 + india_home_loan + emergency_fund      AS total_wealth_building,
    household_income,

    -- % of income going to wealth building
    ROUND(
        (trading_212 + india_home_loan + emergency_fund)
        / NULLIF(household_income, 0) * 100
    , 1)                                                AS wealth_building_rate_pct,

    -- Cumulative totals (growing picture over time)
    SUM(trading_212)     OVER (ORDER BY month)          AS cumulative_trading_212,
    SUM(india_home_loan) OVER (ORDER BY month)          AS cumulative_india,
    SUM(emergency_fund)  OVER (ORDER BY month)          AS cumulative_emergency_fund,
    SUM(trading_212 + india_home_loan + emergency_fund)
                         OVER (ORDER BY month)          AS cumulative_total

FROM monthly
ORDER BY month;
