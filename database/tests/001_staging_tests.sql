--=================================
--# Data Quality Checks
--=================================

-- No null transaction datetime
SELECT *
FROM staging.transactions_normalized
WHERE transaction_datetime IS NULL;

-- No null direction
SELECT *
FROM staging.transactions_normalized
WHERE transaction_direction IS NULL;

-- Amount should always be positive
SELECT *
FROM staging.transactions_normalized
WHERE amount < 0;
