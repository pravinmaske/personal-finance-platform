CREATE OR REPLACE VIEW mart.financial_summary AS
SELECT
    DATE_TRUNC('month', transaction_datetime) AS month,
    -- Salary only
    SUM(CASE 
        WHEN income_type = 'SALARY' 
        THEN amount 
        ELSE 0 
    END) AS salary_income,
    -- Expenses (convert to positive)
    SUM(CASE 
        WHEN transaction_class = 'EXPENSE' 
        THEN ABS(amount) 
        ELSE 0 
    END) AS total_expense,
    -- Savings = Salary - Expense
    SUM(CASE 
        WHEN income_type = 'SALARY' 
        THEN amount 
        ELSE 0 
    END)
    -
    SUM(CASE 
        WHEN transaction_class = 'EXPENSE' 
        THEN ABS(amount) 
        ELSE 0 
    END) AS savings,
    -- Net Flow (includes everything except transfers)
    SUM(CASE 
        WHEN transaction_class = 'EXPENSE' THEN amount
        WHEN income_type = 'SALARY' THEN amount
        WHEN income_type = 'REFUND' THEN amount
        ELSE 0
    END) AS net_flow
FROM staging.transactions_normalized
GROUP BY 1
ORDER BY 1;