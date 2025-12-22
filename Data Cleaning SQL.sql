-- Use Database
USE boat;

-- View Tables
SHOW TABLES;


-- View Data
SELECT * FROM boat_customer;
SELECT * FROM order_boat;
SELECT * FROM order_detail;
SELECT * FROM product;
SELECT * FROM boat_return;


-- 1. CUSTOMER TABLE CLEANING
-- Check structure
DESCRIBE boat_customer;

-- Update data types
ALTER TABLE boat_customer
MODIFY COLUMN phone VARCHAR(15),
MODIFY COLUMN postal_code VARCHAR(10);


-- Convert registration_date to DATE format
SET SQL_SAFE_UPDATES = 0;

UPDATE boat_customer
SET registration_date = STR_TO_DATE(registration_date, '%d-%m-%Y')
WHERE registration_date IS NOT NULL;

ALTER TABLE boat_customer
MODIFY COLUMN Registration_date date;

-- Remove duplicates
SELECT customer_id, COUNT(*) AS duplicates
FROM boat_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

CREATE TABLE customer AS
SELECT DISTINCT
    customer_id,
    name,
    last_name,
    gender,
    age,
    email,
    phone,
    city,
    state,
    postal_code,
    registration_date
FROM boat_customer;

-- Standardize gender
UPDATE boat_customer
SET gender = CASE 
    WHEN gender = 'm' THEN 'Male'
    WHEN gender = 'f' THEN 'Female'
    ELSE gender
END;


-- 2. ORDER_BOAT TABLE CLEANING
DESCRIBE order_boat;

-- Convert dates to DATE format
UPDATE order_boat
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y'),
    shipped_date = STR_TO_DATE(shipped_date, '%d-%m-%Y'),
    delivery_date = STR_TO_DATE(delivery_date, '%d-%m-%Y')
WHERE order_date IS NOT NULL
   OR shipped_date IS NOT NULL
   OR delivery_date IS NOT NULL;

ALTER TABLE order_boat
MODIFY COLUMN order_date DATE,
MODIFY COLUMN shipped_date DATE,
MODIFY COLUMN delivery_date DATE;

-- Remove duplicates
SELECT order_id, COUNT(*) AS duplicates
FROM order_boat
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) AS duplicates
FROM order_boat
GROUP BY customer_id
HAVING COUNT(*) > 1;

CREATE TABLE orders AS
SELECT DISTINCT
    order_id,
    customer_id,
    order_date,
    shipped_date,
    delivery_date,
    payment_method,
    shipping_address,
    order_status,
    order_channel
FROM order_boat;

-- 3. ORDER_DETAIL TABLE CLEANING
DESCRIBE order_details;

# Change data type 
ALTER TABLE order_details
MODIFY COLUMN discount_percent DECIMAL(10,2),
MODIFY COLUMN rating DECIMAL(2,1);

-- Remove duplicates
SELECT order_detail_id, COUNT(*) AS duplicates
FROM order_details
GROUP BY order_detail_id
HAVING COUNT(*) > 1;

CREATE TABLE order_detail AS
SELECT DISTINCT
    order_detail_id,
    order_id,
    product_id,
    quantity,
    unit_price
FROM order_details;



-- 4. PRODUCT TABLE CLEANING

ALTER TABLE product_table
MODIFY COLUMN cost_price DECIMAL(10,2);

ALTER TABLE product_table
MODIFY COLUMN rating DECIMAL(2,1);

-- Remove duplicates
SELECT product_id, COUNT(*) AS duplicates
FROM product_table
GROUP BY product_id
HAVING COUNT(*) > 1;

CREATE TABLE product AS
SELECT DISTINCT
    product_id,
    product_name,
    cost_price,
    category,
    rating,
    color,
    model_number,
    review,
    review_tag
FROM product_table;


-- 5. RETURNS TABLE CLEANING
-- Convert return_date to DATE format
UPDATE return_table
SET return_date = STR_TO_DATE(return_date, '%d-%m-%Y')
WHERE return_date IS NOT NULL;

alter table return_table
modify column return_date date ;

-- Remove duplicates
SELECT return_id, COUNT(*) AS duplicates
FROM return_table
GROUP BY return_id
HAVING COUNT(*) > 1;

SELECT order_detail_id, COUNT(*) AS duplicates
FROM return_table
GROUP BY order_detail_id
HAVING COUNT(*) > 1;

CREATE TABLE returns AS
SELECT DISTINCT
    return_id,
    order_detail_id,
    return_date,
    reason,
    refund_status
FROM return_table;

