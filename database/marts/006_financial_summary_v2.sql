CREATE OR REPLACE VIEW mart.financial_summary_v2 AS
SELECT
    DATE_TRUNC('month', transaction_datetime) AS month,
    -- Total Income
    SUM(CASE 
        WHEN transaction_class = 'INCOME' 
        THEN amount ELSE 0 END) AS total_income,
    -- Total Expense (make positive for readability)
    ABS(SUM(CASE 
        WHEN transaction_class = 'EXPENSE' 
        THEN amount ELSE 0 END)) AS total_expense,
    -- Net Flow (Savings)
    SUM(CASE 
        WHEN transaction_class IN ('INCOME','EXPENSE') 
        THEN amount ELSE 0 END) AS net_flow,
    -- Savings Rate %
    CASE 
        WHEN SUM(CASE WHEN transaction_class = 'INCOME' THEN amount ELSE 0 END) = 0 
        THEN 0
        ELSE 
            ROUND(
                (
                    SUM(CASE WHEN transaction_class IN ('INCOME','EXPENSE') THEN amount ELSE 0 END)
                    /
                    SUM(CASE WHEN transaction_class = 'INCOME' THEN amount ELSE 0 END)
                ) * 100, 
            2)
    END AS savings_rate_pct
FROM staging.transactions_normalized
WHERE transaction_class IN ('INCOME','EXPENSE')   -- 🚨 IMPORTANT
GROUP BY 1
ORDER BY 1;