-- ==========================================
-- Load Revolut CSV into raw.revolut_transactions
-- ==========================================

-- NOTE:
-- This script assumes the CSV is imported via DBeaver
-- OR using \copy from local machine.
-- DO NOT use server-side COPY unless file is on DB server.

-- Example for psql client usage:
-- \copy raw.revolut_transactions(
--     transaction_type,
--     product,
--     started_at,
--     completed_at,
--     description,
--     amount,
--     fee,
--     currency,
--     state,
--     balance
-- )
-- FROM 'data/raw/revolut/account-statement_2026-01-01_2026-01-31_en-gb_1839e3.csv'
-- WITH (FORMAT csv, HEADER true);

-- After load, update lineage:

UPDATE raw.revolut_transactions
SET source_file_name = 'account-statement_2026-01-01_2026-01-31_en-gb_1839e3.csv'
WHERE source_file_name IS NULL;
