UPDATE staging.transactions_normalized
SET income_type =
CASE
    WHEN transaction_class != 'INCOME' THEN NULL
    -- Salary
    WHEN description ILIKE '%JAGUAR LAND ROVER%' THEN 'SALARY'
    -- Transfers
    WHEN description ILIKE '%AJABE%' THEN 'TRANSFER_IN'
    WHEN description ILIKE '%MASKE%' THEN 'TRANSFER_IN'
    -- Refunds
    WHEN description ILIKE '%Trainline%' AND amount > 0 THEN 'REFUND'
    WHEN description ILIKE '%Temu%' AND amount > 0 THEN 'REFUND'
    WHEN description ILIKE '%Uber%' AND amount > 0 THEN 'REFUND'
    ELSE 'OTHER'
END;