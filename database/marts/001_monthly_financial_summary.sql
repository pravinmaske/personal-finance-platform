CREATE OR REPLACE VIEW mart.monthly_financial_summary AS
SELECT
DATE_TRUNC('month', transaction_datetime) AS month,
COUNT(*) AS total_transactions,
SUM(CASE 
        WHEN 
            transaction_direction = 'CREDIT'
        THEN
            amount 
        ELSE 0 
    END) AS total_income,
SUM(CASE 
        WHEN
            transaction_direction = 'DEBIT'
        THEN
            amount 
        ELSE 0 
    END) AS total_expanse,
SUM( CASE 
    WHEN transaction_direction = 'CREDIT' THEN amount 
    ELSE -amount 
END)  AS net_balance_change

from staging.transactions_normalized
GROUP BY 1
ORDER BY 1
