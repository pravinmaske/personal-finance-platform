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
WITH matched AS (
    -- Use DISTINCT ON to ensure each transaction matches at most one keyword.
    -- If multiple keywords match, the longest keyword wins (most specific).
    SELECT DISTINCT ON (t.id)
        t.id,
        DATE_TRUNC('month', t.transaction_datetime)     AS month,
        t.account_name,
        t.amount,
        COALESCE(mc.category, 'Uncategorised')          AS category,
        COALESCE(mc.subcategory, '')                    AS subcategory
    FROM staging.transactions_normalized t
    LEFT JOIN dim.merchant_category mc
        ON t.description ILIKE ('%' || mc.keyword || '%')
    WHERE t.transaction_class = 'EXPENSE'
    ORDER BY t.id, LENGTH(mc.keyword) DESC NULLS LAST
)
SELECT
    month,
    account_name,
    category,
    subcategory,
    COUNT(*)                                            AS transaction_count,
    ABS(SUM(amount))                                    AS total_spent
FROM matched
GROUP BY 1, 2, 3, 4
ORDER BY 1, total_spent DESC;
