--Adding idempotency protection to transform.
--This prevents accidental duplicates in the future.

ALTER TABLE staging.transactions_normalized
ADD CONSTRAINT unique_txn UNIQUE (
    account_name,
    transaction_datetime,
    description,
    amount
);
