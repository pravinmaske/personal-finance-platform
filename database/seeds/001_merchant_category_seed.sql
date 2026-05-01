-- =============================================================
-- 001_merchant_category_seed.sql
-- Keyword → category mapping for all known merchants
-- Add new rows here as new merchants appear in future months
--
-- IMPORTANT: If a description could match multiple keywords,
-- the LONGEST matching keyword wins (enforced in mart views
-- via DISTINCT ON / ORDER BY LENGTH DESC). So more specific
-- keywords (e.g. 'ASDA PETROL') always beat shorter ones ('Asda').
-- =============================================================

TRUNCATE TABLE dim.merchant_category RESTART IDENTITY;

INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES
-- Groceries
('grocery coventry',  'Groceries',    'Supermarket'),
('ADSA STORES',       'Groceries',    'Supermarket'),  -- typo of ASDA in HSBC export
('ASDA STORES',       'Groceries',    'Supermarket'),  -- HSBC format: avoids matching ASDA PETROL
('Asda',              'Groceries',    'Supermarket'),  -- Revolut short format
('LIDL',              'Groceries',    'Supermarket'),
('TESCO',             'Groceries',    'Supermarket'),
('Iceland',           'Groceries',    'Supermarket'),
('ALDI',              'Groceries',    'Supermarket'),
('SPAR Food & Fuel',  'Groceries',    'Supermarket'),  -- specific SPAR format (Revolut)
('Spar',              'Groceries',    'Supermarket'),  -- HSBC short format
('Opus Foods',        'Groceries',    'Asian Grocery'),
('Swan Delights',     'Groceries',    'Asian Grocery'),
('Mum and Dads',      'Groceries',    'Supermarket'),
('Al Halal',          'Groceries',    'Fish & Meat'),
('Charlie',           'Groceries',    'Fish & Meat'),
('Asian Fresh Fish',  'Groceries',    'Fish & Meat'),
('Fishy Business',    'Groceries',    'Fish & Meat'),
('Adam''s Fruits',    'Groceries',    'Fresh Produce'),
('Dost Frust',        'Groceries',    'Fresh Produce'),
-- Dining & Takeaway
('JADE HOUSE',        'Dining',       'Takeaway'),
('Malabar Bites',     'Dining',       'Takeaway'),
('Uber Eats',         'Dining',       'Delivery'),
-- Transport
('Trainline',         'Transport',    'Train'),
('Zeelo',             'Transport',    'Bus'),
('Bolt',              'Transport',    'Taxi'),
('Uber',              'Transport',    'Taxi'),          -- must come after Uber Eats
('Phone A Cab',       'Transport',    'Taxi'),
('ASDA PETROL',       'Transport',    'Fuel'),          -- longer than 'Asda' so wins
('RingGo',            'Transport',    'Parking'),
-- Bills & Utilities
('Edf Energy',        'Bills',        'Energy'),
('EDF',               'Bills',        'Energy'),
('Severn Trent',      'Bills',        'Water'),
('VIRGIN MEDIA',      'Bills',        'Broadband'),
('O2 Recharge',       'Bills',        'Mobile'),
('LycaMobile',        'Bills',        'Mobile'),
('PayPoint',          'Bills',        'Utilities'),
('Coventry Cc',       'Bills',        'Council Tax'),
-- Rent
('JPK Leisure',       'Rent',         'Rent'),
-- Health
('Coventry Sports',   'Health',       'Gym'),
('Crest Pharmacy',    'Health',       'Pharmacy'),
-- Childcare
('Pattison College',  'Childcare',    'Nursery Fees'),
-- Travel / Holiday
('Dkn Belfast',       'Travel',       'Accommodation'),
('Booking.com',       'Travel',       'Holiday'),       -- matches Booking.com*AMSTERDAM etc
('RAJESH SADASHIV',   'Travel',       'Belfast Trip'),  -- shared trip expense paid to friend
-- Leisure & Family
('Dudley Zoo',        'Leisure',      'Family Activities'),
('Kids Pass',         'Leisure',      'Family Activities'),
('The Leam Boat',     'Leisure',      'Family Activities'),
('Hindu Religiou',    'Leisure',      'Religious'),
('Reward Gateway',    'Leisure',      'Entertainment'),
('bet365',            'Leisure',      'Gambling'),
('EasyJet',           'Travel',       'Flights'),
-- Shopping
('Temu',              'Shopping',     'Online'),
('Poundland',         'Shopping',     'Discount Store'),
('B&M',               'Shopping',     'Discount Store'),
('Shoe Zone',         'Shopping',     'Clothing'),
('Primark',           'Shopping',     'Clothing'),
('Donald Taylor',     'Shopping',     'Personal Transfer'),
('To Aspora',         'Shopping',     'Online'),
-- Food at work
('CONNECT CATERING',  'Food at Work', 'Office Food'),
('PPOINT',            'Food at Work', 'Office Food'),
('JAGUAR LAND ROVER COVENTRY', 'Food at Work', 'Office Vending'),  -- paid_out only; salary excluded by transaction_class filter
-- Cash
('CASH NOTEMAC',      'Cash',         'ATM Withdrawal'),
('CASH NOTE',         'Cash',         'ATM Withdrawal'),
-- Personal Car
('Barber',            'Personal Care','Haircut'),
('H Jackson',         'Personal Care','Misc');          -- small local shop Belfast
