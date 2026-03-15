INSERT INTO staging.transactions_normalized(
    account_name,
    transaction_datetime,
    description,
    amount,
    transaction_class
) 
SELECT 
account_name,
transaction_date::timestamp,
description,
case 
when paid_out IS NOT NULL THEN -paid_out
when paid_in IS NOT NULL THEN paid_in
END as amount,
case 
    when paid_out is not null THEN 'EXPENSE'
    WHEN paid_in is not null THEN 'INCOME'
end as transaction_class
FROM raw.hsbc_transactions;
