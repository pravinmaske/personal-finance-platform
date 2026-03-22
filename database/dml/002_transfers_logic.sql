--HSBC Transfer Logic
UPDATE staging.transactions_normalized
SET transaction_class = 'TRANSFER',
    income_type = 'TRANSFER_IN'
WHERE description ILIKE '%AJABE%'
   OR description ILIKE '%MASKE%';

-- Barclays Transfers

UPDATE staging.transactions_normalized
SET transaction_class = 'TRANSFER',
    income_type = 'TRANSFER_OUT'
WHERE description ILIKE '%Husband Transfer%';

-- Revolut transactions:
UPDATE staging.transactions_normalized
SET transaction_class = 'TRANSFER',
    income_type = 'TRANSFER_IN'
WHERE description ILIKE '%Payment from MASKE%'
   OR description ILIKE '%Payment from AJABE%';