-- =============================================================
-- 001_merchant_category_seed.sql
-- Keyword → category mapping for all known merchants
-- Add new rows here as new merchants appear
-- =============================================================

TRUNCATE TABLE dim.merchant_category RESTART IDENTITY;

INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES
-- Groceries
('LIDL',            'Groceries',    'Supermarket'),
('ASDA',            'Groceries',    'Supermarket'),
('TESCO',           'Groceries',    'Supermarket'),
('ICELAND',         'Groceries',    'Supermarket'),
('ALDI',            'Groceries',    'Supermarket'),
('Opus Foods',      'Groceries',    'Asian Grocery'),
('Asian Fresh Fish','Groceries',    'Fish & Meat'),
('SWAN DELIGHTS',   'Groceries',    'Asian Grocery'),
('Charlie',         'Groceries',    'Fish & Meat'),
('Mum and Dads',    'Groceries',    'Supermarket'),
-- Dining & Takeaway
('JADE HOUSE',      'Dining',       'Takeaway'),
('Malabar Bites',   'Dining',       'Takeaway'),
-- Transport
('Trainline',       'Transport',    'Train'),
('Zeelo',           'Transport',    'Bus'),
('Bolt',            'Transport',    'Taxi'),
('Uber',            'Transport',    'Taxi'),
('ASDA PETROL',     'Transport',    'Fuel'),
-- Bills & Utilities
('Edf Energy',      'Bills',        'Energy'),
('EDF',             'Bills',        'Energy'),
('VIRGIN MEDIA',    'Bills',        'Broadband'),
('O2 Recharge',     'Bills',        'Mobile'),
('LycaMobile',      'Bills',        'Mobile'),
('PayPoint',        'Bills',        'Utilities'),
('Coventry Cc',     'Bills',        'Council Tax'),
-- Rent
('JPK Leisure',     'Rent',         'Rent'),
-- Gym & Leisure
('Coventry Sports', 'Health',       'Gym'),
('Dudley Zoo',      'Leisure',      'Family Activities'),
('Kids Pass',       'Leisure',      'Family Activities'),
('Reward Gateway',  'Leisure',      'Entertainment'),
('bet365',          'Leisure',      'Gambling'),
('EasyJet',         'Travel',       'Flights'),
-- Food at work
('CONNECT CATERING','Food at Work', 'Office Food'),
('PPOINT',          'Food at Work', 'Office Food'),
-- Online Shopping
('Temu',            'Shopping',     'Online'),
('Donald Taylor',   'Shopping',     'Personal Transfer');
