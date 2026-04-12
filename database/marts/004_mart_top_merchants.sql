-- =============================================================
-- 004_mart_top_merchants.sql
--
-- mart.top_merchants
-- Ranks merchants by total spend per month.
-- Shows you exactly where money is going at merchant level.
-- Only includes EXPENSE rows.
-- =============================================================

CREATE OR REPLACE VIEW mart.top_merchants AS
WITH deduped AS (
    SELECT DISTINCT ON (t.id)
        t.id,
        DATE_TRUNC('month', t.transaction_datetime)     AS month,
        t.account_name,
        t.description,
        t.amount,
        COALESCE(mc.category, 'Uncategorised')          AS category
    FROM staging.transactions_normalized t
    LEFT JOIN dim.merchant_category mc
        ON t.description ILIKE ('%' || mc.keyword || '%')
    WHERE t.transaction_class = 'EXPENSE'
    ORDER BY t.id, LENGTH(mc.keyword) DESC NULLS LAST
)
SELECT
    month,
    account_name,
    description                                         AS merchant,
    category,
    COUNT(*)                                            AS visit_count,
    ABS(SUM(amount))                                    AS total_spent,
    ABS(AVG(amount))                                    AS avg_per_visit,
    RANK() OVER (
        PARTITION BY month
        ORDER BY ABS(SUM(amount)) DESC
    )                                                   AS spend_rank
FROM deduped
GROUP BY 1, 2, 3, 4
ORDER BY 1, total_spent DESC;
