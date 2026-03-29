
CREATE OR REPLACE VIEW mart.financial_summary AS
SELECT
    DATE_TRUNC('month', transaction_datetime) AS month,
    -- Salary only
    SUM(CASE 
        WHEN income_type = 'SALARY' 
        THEN amount 
        ELSE 0 
    END) AS household_income,
    -- Expenses only (exclude transfers!)
    SUM(CASE 
        WHEN transaction_class = 'EXPENSE' 
        THEN ABS(amount) 
        ELSE 0 
    END) AS total_expense,
    -- Savings
    SUM(CASE 
        WHEN transaction_class = 'SAVINGS' 
        THEN ABS(amount) 
        ELSE 0 
    END) AS total_savings,
    -- Net position (exclude transfers!)
    SUM(CASE 
        WHEN transaction_class IN ('EXPENSE','SAVINGS') THEN amount
        WHEN income_type = 'SALARY' THEN amount
        WHEN income_type = 'REFUND' THEN amount
        ELSE 0 END
        ) AS net_flow
FROM staging.transactions_normalized
GROUP BY 1
ORDER BY 1;