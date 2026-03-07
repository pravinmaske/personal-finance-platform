CREATE OR REPLACE VIEW mart.personal_cashflow_summary AS
SELECT
    DATE_TRUNC('month', transaction_datetime) AS month,
    SUM(
        CASE 
            WHEN transaction_class = 'INCOME'
            THEN amount ELSE 0
        END
    ) as income,
    SUM(
        CASE 
            WHEN transaction_class = 'EXPANSE' 
            THEN amount 
            ELSE 0
        END
    ) as expenses,

    SUM(
        CASE 
            WHEN transaction_class = 'TRANSFER_IN' 
            THEN amount
            ELSE 0
        END
    ) as transfers_in,
    COUNT(*) as total_transactions
FROM staging.transactions_normalized
GROUP BY 1
ORDER BY 1;