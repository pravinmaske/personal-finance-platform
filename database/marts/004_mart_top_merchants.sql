-- =============================================================
-- 004_mart_top_merchants.sql
--
-- mart.top_merchants
-- Ranks merchants by total spend per month.
-- Shows you exactly where money is going at merchant level.
-- Only includes EXPENSE rows.
-- =============================================================

CREATE OR REPLACE VIEW mart.top_merchants AS
SELECT
    DATE_TRUNC('month', transaction_datetime)   AS month,
    account_name,
    description                                 AS merchant,
    COALESCE(mc.category, 'Uncategorised')      AS category,
    COUNT(*)                                    AS visit_count,
    ABS(SUM(amount))                            AS total_spent,
    ABS(AVG(amount))                            AS avg_per_visit,
    RANK() OVER (
        PARTITION BY DATE_TRUNC('month', transaction_datetime)
        ORDER BY ABS(SUM(amount)) DESC
    )                                           AS spend_rank
FROM staging.transactions_normalized t
LEFT JOIN dim.merchant_category mc
    ON t.description ILIKE ('%' || mc.keyword || '%')
WHERE transaction_class = 'EXPENSE'
GROUP BY 1, 2, 3, 4
ORDER BY 1, total_spent DESC;
