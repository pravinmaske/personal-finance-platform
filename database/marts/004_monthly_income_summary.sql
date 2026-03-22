CREATE OR REPLACE VIEW mart.monthly_salary AS
SELECT
DATE_TRUNC('month', transaction_datetime) AS month,
SUM(amount) AS salary_income
FROM staging.transactions_normalized
WHERE income_type = 'SALARY'
GROUP BY 1;