INSERT INTO dim.merchant_category VALUES
-- Transport
('Trainline','Transport','Train'),
('Bolt','Transport','Taxi'),
('NX BUS CONTACTLESS','Transport','Public Transport'),
('TFL TRAVEL CH','Transport','Public Transport'),
('NATIONAL EXPRESS','Travel','Bus'),
-- Housing
('JPK Leisure LTD TA','Housing','Rent'),
('Coventry CC','Housing','Council Tax'),
-- Utilities
('EDF Energy','Utilities','Electricity'),
('VIRGIN MEDIA PYMTS','Utilities','Internet'),
('O2','Utilities','Mobile'),
-- Groceries
('Lidl','Groceries','Supermarket'),
('LIDL GB COVENTRY','Groceries','Supermarket'),
('Asda','Groceries','Supermarket'),
('ASDA STORES','Groceries','Supermarket'),
('ICELAND','Groceries','Supermarket'),
('Opus Foods','Groceries','Indian Groceries'),
('Swan Delights Supe','Groceries','Supermarket'),
-- Dining
('Malabar Bites','Dining','Restaurant'),
('CONNECT CATERING L','Dining','Restaurant'),
('Greggs','Dining','Fast Food'),
('Damaskenos Shawarm','Dining','Restaurant'),
('Biryani Guys','Dining','Restaurant'),
-- Shopping
('Temu','Shopping','Online Shopping'),
('PRIMARK','Shopping','Retail'),
-- Gym / Health
('Coventry Sports Fo','Health','Gym'),
-- Subscriptions
('Kids Pass','Subscription','Family'),
-- Benefits
('Reward Gateway','Benefits','Work Benefits');

-- adding missing merchants again:
INSERT INTO dim.merchant_category VALUES

('Edf Energy','Utilities','Electricity'),
('Coventry Cc','Housing','Council Tax'), 
('EasyJet','Travel','Flights'),
('PayPoint','Utilities','Bill Payment'),
('Zeelo','Transport','Shuttle'),
('Asian Fresh Fish','Groceries','Fish Market'),
('Uber','Transport','Taxi'),
('bet365','Entertainment','Betting'),
('Dudley Zoo','Entertainment','Family Activity'),
('Charlie''s Halal Meat','Groceries','Meat Shop');


-- added Salary category
INSERT INTO dim.merchant_category
(merchant_name, category, sub_category)
VALUES
('JAGUAR LAND ROVER','Income','Salary');

-- more categories from HSBC transactions:
INSERT INTO dim.merchant_category VALUES
('LIDL','Groceries','Supermarket'),
('ASDA','Groceries','Supermarket'),
('TESCO','Groceries','Supermarket'),
('grocery coventry market','Groceries','Local Market'),
('Mum and Dads sup Coventry','Groceries','Indian Grocery'),
('PPOINT_*AFRICA','Groceries','Local Grocery'),
('SUMUP JADE HOUSE','Food','Takeaway'),
('ASDA PETROL','Transport','Fuel'),
('CROSSCOUNTRY','Transport','Train'),
('O2 Recharge','Telecom','Mobile'),
('Trading 212 London Investment','Investment','Stocks'),
('401672 64363663 INTERNET TRANSFER','Loan','Home Loan'),
('Pravin Maske Revoult','Transfer','Transfer to Revolut'),
('AJABE A HUSBAND TRANSFER','Transfer','Internal Transfer');

INSERT INTO dim.merchant_category VALUES
('Payment from MASKE','Transfer','Internal Transfer'),
('SUMUP *JADE HOUSE COVENTRY','Food','Takeaway'),
('To Donald Taylor','Entertainment','Family Activity');