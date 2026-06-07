-- =============================================================
-- 001_merchant_category_seed.sql
-- Complete merchant keyword mapping — Jan through May 2026
-- Run with Execute Script (F5) in DBeaver, not Execute Statement
-- Each INSERT is separate so a single failure doesn't kill the rest
-- =============================================================

TRUNCATE TABLE dim.merchant_category RESTART IDENTITY;

-- Groceries — supermarkets
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('grocery coventry', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('ADSA STORES', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('ASDA STORES', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Asda', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('LIDL', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('TESCO', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Iceland', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('ALDI', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Co-op', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Sainsbury', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('SPAR Food & Fuel', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Spar', 'Groceries', 'Supermarket');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Mum and Dads', 'Groceries', 'Supermarket');

-- Groceries — specialist / fresh
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Opus Foods', 'Groceries', 'Asian Grocery');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Swan Delights', 'Groceries', 'Asian Grocery');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Al Halal', 'Groceries', 'Fish & Meat');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Charlie', 'Groceries', 'Fish & Meat');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Asian Fresh Fish', 'Groceries', 'Fish & Meat');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Fishy Business', 'Groceries', 'Fish & Meat');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Adams Fruits', 'Groceries', 'Fresh Produce');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Dost Frust', 'Groceries', 'Fresh Produce');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Fruit Veg Baket', 'Groceries', 'Fresh Produce');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Ik Fresh Fruit', 'Groceries', 'Fresh Produce');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('D.a Betts', 'Groceries', 'Fresh Produce');

-- Dining & Takeaway
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('JADE HOUSE', 'Dining', 'Takeaway');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Malabar Bites', 'Dining', 'Takeaway');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Uber Eats', 'Dining', 'Delivery');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Lahore Qalandar', 'Dining', 'Restaurant');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Walker Catering', 'Dining', 'Restaurant');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Jerry', 'Dining', 'Takeaway');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('The Chai Bar', 'Dining', 'Cafe');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('City Grill', 'Dining', 'Restaurant');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('The Spirit House', 'Dining', 'Restaurant');

-- Transport — trains
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Trainline', 'Transport', 'Train');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Zeelo', 'Transport', 'Bus');

-- Transport — taxi
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Bolt', 'Transport', 'Taxi');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Phone A Cab', 'Transport', 'Taxi');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Uber', 'Transport', 'Taxi');

-- Transport — fuel (specific before generic to win DISTINCT ON length race)
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('ASDA PETROL', 'Transport', 'Fuel');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('MORRISON Fuel', 'Transport', 'Fuel');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Motor Fuel Group', 'Transport', 'Fuel');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Gloucester Services', 'Transport', 'Fuel');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Morrison', 'Transport', 'Fuel');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Esso', 'Transport', 'Fuel');

-- Transport — parking
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('RingGo', 'Transport', 'Parking');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('APCOA Parking', 'Transport', 'Parking');

-- Bills & Utilities
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Edf Energy', 'Bills', 'Energy');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('EDF', 'Bills', 'Energy');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Severn Trent', 'Bills', 'Water');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('VIRGIN MEDIA', 'Bills', 'Broadband');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('O2 Recharge', 'Bills', 'Mobile');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('LycaMobile', 'Bills', 'Mobile');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('PayPoint', 'Bills', 'Utilities');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Coventry Cc', 'Bills', 'Council Tax');

-- Rent
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('JPK Leisure', 'Rent', 'Rent');

-- Health
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Coventry Sports', 'Health', 'Gym');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Crest Pharmacy', 'Health', 'Pharmacy');

-- Childcare
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Pattison College', 'Childcare', 'Nursery Fees');

-- Visa & Immigration
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Bb Ukvi', 'Visa', 'Parents Visa');

-- Travel — accommodation
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Dkn Belfast', 'Travel', 'Accommodation');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Premier Inn', 'Travel', 'Accommodation');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Premier', 'Travel', 'Accommodation');

-- Travel — flights & holidays
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Booking.com', 'Travel', 'Holiday');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('EasyJet', 'Travel', 'Flights');

-- Travel — day trips & road trip
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Longleat', 'Travel', 'Day Trip');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Lulworth', 'Travel', 'Day Trip');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Coastal Trail', 'Travel', 'Day Trip');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Dart Valley Railway', 'Travel', 'Day Trip');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('RAJESH SADASHIV', 'Travel', 'Belfast Trip');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Poonam', 'Travel', 'Torquay Trip');

-- Leisure & Family
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Dudley Zoo', 'Leisure', 'Family Activities');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Kids Pass', 'Leisure', 'Family Activities');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('The Leam Boat', 'Leisure', 'Family Activities');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Hindu Religiou', 'Leisure', 'Religious');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Reward Gateway', 'Leisure', 'Entertainment');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('bet365', 'Leisure', 'Gambling');

-- Shopping
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Temu', 'Shopping', 'Online');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Poundland', 'Shopping', 'Discount Store');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('B&M', 'Shopping', 'Discount Store');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Shoe Zone', 'Shopping', 'Clothing');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Primark', 'Shopping', 'Clothing');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Donald Taylor', 'Shopping', 'Personal Transfer');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('To Aspora', 'Shopping', 'Online');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Hemanel Business', 'Shopping', 'Online');

-- Food at work
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('CONNECT CATERING', 'Food at Work', 'Office Food');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('PPOINT', 'Food at Work', 'Office Food');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Jaguar Land Rover Coventry', 'Food at Work', 'Office Vending');

-- Cash
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('CASH NOTEMAC', 'Cash', 'ATM Withdrawal');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('CASH NOTE', 'Cash', 'ATM Withdrawal');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('ATM CASH', 'Cash', 'ATM Withdrawal');

-- Personal Care
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('Barber', 'Personal Care', 'Haircut');
INSERT INTO dim.merchant_category (keyword, category, subcategory) VALUES ('H Jackson', 'Personal Care', 'Misc');

SELECT COUNT(*) AS rows_inserted FROM dim.merchant_category;
