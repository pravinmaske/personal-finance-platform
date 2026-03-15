CREATE OR REPLACE VIEW mart.category_monthly_spend AS

SELECT
DATE_TRUNC('month', t.transaction_datetime) AS month,
c.category,
SUM(t.amount) AS total_spend

FROM staging.transactions_normalized t
LEFT JOIN dim.merchant_category c
ON t.description = c.merchant_name

WHERE t.transaction_class = 'EXPENSE'

GROUP BY 1,2
ORDER BY 1,3 DESC;