-- =============================================================
-- 002_mart_category_spend.sql
--
-- mart.category_monthly_spend
-- Monthly spending broken down by merchant category
--
-- Joins staging expenses to dim.merchant_category via keyword
-- matching. Expenses with no matching keyword land in 'Uncategorised'.
--
-- Only includes EXPENSE rows — excludes TRANSFER, INCOME, INVESTMENT
-- =============================================================

CREATE OR REPLACE VIEW mart.category_monthly_spend AS
SELECT
    DATE_TRUNC('month', t.transaction_datetime)     AS month,
    t.account_name,
    COALESCE(mc.category, 'Uncategorised')          AS category,
    COALESCE(mc.subcategory, '')                    AS subcategory,
    COUNT(*)                                        AS transaction_count,
    ABS(SUM(t.amount))                              AS total_spent

FROM staging.transactions_normalized t
LEFT JOIN dim.merchant_category mc
    ON t.description ILIKE ('%' || mc.keyword || '%')
WHERE t.transaction_class = 'EXPENSE'
GROUP BY 1, 2, 3, 4
ORDER BY 1, total_spent DESC;
