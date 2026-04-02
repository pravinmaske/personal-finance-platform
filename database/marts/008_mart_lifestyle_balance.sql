-- =============================================================
-- 008_mart_lifestyle_balance.sql
--
-- mart.lifestyle_balance
-- Answers: "Am I living well, not just saving well?"
--
-- Tracks the balance between essentials and lifestyle spending.
-- A healthy financial life has both strong savings AND
-- intentional spending on things that matter.
--
-- Lifestyle score bands:
--   0-5%   lifestyle spend → Under-spending, possibly depriving yourself
--   5-15%  lifestyle spend → Healthy balance
--   15-25% lifestyle spend → Active lifestyle, watch the trend
--   25%+   lifestyle spend → Review against savings goals
--
-- Categories:
--   Essentials:   Rent, Bills, Groceries, Transport, Food at Work
--   Lifestyle:    Dining, Leisure, Travel, Shopping, Health (gym)
--   Uncategorised: unknown — needs categorisation
-- =============================================================

CREATE OR REPLACE VIEW mart.lifestyle_balance AS
WITH monthly_cats AS (
    SELECT
        DATE_TRUNC('month', t.transaction_datetime)     AS month,
        COALESCE(mc.category, 'Uncategorised')          AS category,
        ABS(SUM(t.amount))                              AS total_spent
    FROM staging.transactions_normalized t
    LEFT JOIN dim.merchant_category mc
        ON t.description ILIKE ('%' || mc.keyword || '%')
    WHERE t.transaction_class = 'EXPENSE'
    GROUP BY 1, 2
),
pivoted AS (
    SELECT
        month,
        -- Essentials
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Rent'
        ), 0)                                           AS rent,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Bills'
        ), 0)                                           AS bills,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Groceries'
        ), 0)                                           AS groceries,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Transport'
        ), 0)                                           AS transport,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Food at Work'
        ), 0)                                           AS food_at_work,
        -- Lifestyle
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Dining'
        ), 0)                                           AS dining_out,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Leisure'
        ), 0)                                           AS leisure,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Travel'
        ), 0)                                           AS travel,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Shopping'
        ), 0)                                           AS shopping,
        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Health'
        ), 0)                                           AS health_gym,

        COALESCE(SUM(total_spent) FILTER (
            WHERE category = 'Uncategorised'
        ), 0)                                           AS uncategorised,

        SUM(total_spent)                                AS total_expense

    FROM monthly_cats
    GROUP BY 1
)
SELECT
    month,
    -- Essentials breakdown
    rent, bills, groceries, transport, food_at_work,
    rent + bills + groceries + transport + food_at_work AS total_essentials,
    -- Lifestyle breakdown
    dining_out, leisure, travel, shopping, health_gym,
    dining_out + leisure + travel + shopping + health_gym AS total_lifestyle,
    uncategorised,
    total_expense,
    -- Ratios
    ROUND((rent + bills + groceries + transport + food_at_work)
        / NULLIF(total_expense, 0) * 100, 1)           AS essentials_pct,

    ROUND((dining_out + leisure + travel + shopping + health_gym)
        / NULLIF(total_expense, 0) * 100, 1)           AS lifestyle_pct,
    -- Lifestyle score interpretation
    CASE
        WHEN (dining_out + leisure + travel + shopping + health_gym)
            / NULLIF(total_expense, 0) * 100 < 5
            THEN 'Under-spending on lifestyle'
        WHEN (dining_out + leisure + travel + shopping + health_gym)
            / NULLIF(total_expense, 0) * 100 < 15
            THEN 'Healthy balance'
        WHEN (dining_out + leisure + travel + shopping + health_gym)
            / NULLIF(total_expense, 0) * 100 < 25
            THEN 'Active lifestyle — monitor'
        ELSE 'Review against savings goals'
    END                                                 AS lifestyle_verdict,

    income_by_month.household_income
FROM pivoted
JOIN (
    SELECT
        DATE_TRUNC('month', transaction_datetime) AS month,
        SUM(amount) AS household_income
    FROM staging.transactions_normalized
    WHERE transaction_class = 'INCOME'
    GROUP BY 1
) income_by_month USING (month)
ORDER BY month;
