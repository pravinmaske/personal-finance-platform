-- =============================================================
-- 007_mart_expense_breakdown.sql
--
-- mart.expense_breakdown
-- Splits expenses into fixed vs variable costs.
--
-- Fixed costs: same amount every month regardless of behaviour
--   Rent, Energy, Council Tax, Broadband, Mobile, Gym
--
-- Variable costs: driven by your choices
--   Groceries, Transport, Dining, Shopping, Leisure, Travel
--
-- This view helps answer:
--   "How much of my spending do I actually control?"
--   "What is my minimum monthly burn rate?"
-- =============================================================

CREATE OR REPLACE VIEW mart.expense_breakdown AS
WITH categorised AS (
    SELECT
        DATE_TRUNC('month', t.transaction_datetime)     AS month,
        COALESCE(mc.category, 'Uncategorised')          AS category,
        COALESCE(mc.subcategory, '')                    AS subcategory,
        ABS(SUM(t.amount))                              AS total_spent,
        COUNT(*)                                        AS transaction_count
    FROM staging.transactions_normalized t
    LEFT JOIN dim.merchant_category mc
        ON t.description ILIKE ('%' || mc.keyword || '%')
    WHERE t.transaction_class = 'EXPENSE'
    GROUP BY 1, 2, 3
)
SELECT
    month,
    category,
    subcategory,
    total_spent,
    transaction_count,

    -- Fixed or variable
    CASE
        WHEN category IN ('Rent', 'Bills', 'Health')
            THEN 'Fixed'
        ELSE 'Variable'
    END                                                 AS cost_type,

    -- % of total month expenses
    ROUND(
        total_spent
        / SUM(total_spent) OVER (PARTITION BY month)
        * 100
    , 1)                                                AS pct_of_total_expense,

    -- Fixed subtotal per month
    SUM(total_spent) FILTER (
        WHERE category IN ('Rent', 'Bills', 'Health')
    ) OVER (PARTITION BY month)                         AS monthly_fixed_total,

    -- Variable subtotal per month
    SUM(total_spent) FILTER (
        WHERE category NOT IN ('Rent', 'Bills', 'Health')
    ) OVER (PARTITION BY month)                         AS monthly_variable_total

FROM categorised
ORDER BY month, cost_type, total_spent DESC;
