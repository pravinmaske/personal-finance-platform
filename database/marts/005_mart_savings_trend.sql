-- =============================================================
-- 005_mart_savings_trend.sql
--
-- mart.savings_trend
-- Monthly savings picture — income vs outgoings vs what's
-- actually being put aside (including transfers to savings
-- accounts and investments outside the pipeline).
--
-- Three savings measures:
--
--   pipeline_net_flow
--     Income minus expenses within HSBC+Revolut+Barclays.
--     This is money that stayed in your accounts.
--
--   committed_savings
--     Money actively moved OUT to savings/investments:
--       - BARCLAYS_TO_SAVINGS (emergency fund)
--       - TRADING_212 (investments)
--       - HSBC_TO_INDIA (home loan EMI — wealth building)
--
--   true_net_flow
--     pipeline_net_flow minus committed_savings
--     (what's left in current accounts after everything)
--
--   total_wealth_building
--     committed_savings — the money you're actively growing
-- =============================================================

CREATE OR REPLACE VIEW mart.savings_trend AS
SELECT
    DATE_TRUNC('month', transaction_datetime)           AS month,

    -- Income
    SUM(amount) FILTER (
        WHERE transaction_class = 'INCOME'
    )                                                   AS household_income,

    -- All spending (net of refunds)
    ABS(SUM(amount) FILTER (
        WHERE transaction_class = 'EXPENSE'
    )) - COALESCE(SUM(amount) FILTER (
        WHERE transaction_class = 'REFUND'
    ), 0)                                               AS net_expense,

    -- Money left inside the pipeline accounts
    SUM(amount) FILTER (
        WHERE transaction_class IN ('INCOME','EXPENSE','REFUND','INVESTMENT')
    )                                                   AS pipeline_net_flow,

    -- Emergency fund / savings transfers out (Barclays → savings)
    ABS(COALESCE(SUM(amount) FILTER (
        WHERE transaction_sub_type = 'BARCLAYS_TO_SAVINGS'
    ), 0))                                              AS savings_transfers,

    -- Home loan EMI + India payments (wealth building abroad)
    ABS(COALESCE(SUM(amount) FILTER (
        WHERE transaction_sub_type = 'HSBC_TO_INDIA'
    ), 0))                                              AS india_commitments,

    -- Trading 212 / SIP investments
    ABS(COALESCE(SUM(amount) FILTER (
        WHERE transaction_sub_type = 'TRADING_212'
    ), 0))                                              AS investments,

    -- Total actively committed to wealth building
    ABS(COALESCE(SUM(amount) FILTER (
        WHERE transaction_sub_type = 'BARCLAYS_TO_SAVINGS'
    ), 0))
    + ABS(COALESCE(SUM(amount) FILTER (
        WHERE transaction_sub_type = 'HSBC_TO_INDIA'
    ), 0))
    + ABS(COALESCE(SUM(amount) FILTER (
        WHERE transaction_sub_type = 'TRADING_212'
    ), 0))                                              AS total_wealth_building,

    -- Savings rate on income (pipeline net flow only)
    ROUND(
        SUM(amount) FILTER (
            WHERE transaction_class IN ('INCOME','EXPENSE','REFUND','INVESTMENT')
        )
        / NULLIF(SUM(amount) FILTER (WHERE transaction_class = 'INCOME'), 0)
        * 100
    , 1)                                                AS pipeline_savings_rate_pct,

    -- True savings rate including committed savings + india + investments
    ROUND(
        (
            SUM(amount) FILTER (
                WHERE transaction_class IN ('INCOME','EXPENSE','REFUND','INVESTMENT')
            )
            + ABS(COALESCE(SUM(amount) FILTER (
                WHERE transaction_sub_type IN (
                    'BARCLAYS_TO_SAVINGS','HSBC_TO_INDIA','TRADING_212'
                )
            ), 0))
        )
        / NULLIF(SUM(amount) FILTER (WHERE transaction_class = 'INCOME'), 0)
        * 100
    , 1)                                                AS total_wealth_building_rate_pct

FROM staging.transactions_normalized
GROUP BY 1
ORDER BY 1;
