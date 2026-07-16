-- Task 1
-- Retrieve all columns from the Customers table

SELECT * FROM Customers;


-- Task 2
-- Retrieve only the customer's first name, last name, and email

SELECT first_name, last_name, email FROM Customers;


-- Task 3
-- Find all customers who live in cities that start with 'New'

SELECT * FROM Customers WHERE city LIKE 'New%';


-- Task 4
-- Retrieve all products with a price greater than 1000

SELECT * FROM Products WHERE price>1000;


-- Task 5
-- Retrieve products priced between 200 and 800 (inclusive)

SELECT * FROM Products WHERE price BETWEEN 200 AND 800;


-- Task 6
-- Find products with less than 10 items in stock

SELECT * FROM Products WHERE stock_quantity<10;


-- Task 7
-- Retrieve all products ordered by: price (descending), product name (ascending)

SELECT * FROM Products ORDER BY price DESC, name ASC;


-- Task 8
-- Retrieve the top 5 most expensive products

SELECT * FROM Products ORDER BY price DESC LIMIT 5;


-- Task 9
-- Retrieve a list of unique customer cities

SELECT DISTINCT city FROM Customers WHERE city IS NOT NULL;


-- Task 10
-- Retrieve all orders with status: PAID and SHIPPED

SELECT * FROM Orders WHERE status IN ('PAID', 'SHIPPED');


-- Task 11
-- Retrieve all cancelled order

SELECT * FROM Orders WHERE status='CANCELLED';


-- Task 12
-- For each product, display: product name, price, price including 20% tax

SELECT name, price, ROUND(price*1.20, 2) AS price_with_tax FROM Products;


-- Task 13
-- For each product, display: product name, price, price after a 15% discount

SELECT name, price, ROUND(0.85*price, 2) AS price_after_discount FROM Products;


-- Task 14
-- Display the customer's full name in a single column

SELECT CONCAT(first_name, ' ' , last_name) AS full_name FROM Customers;


-- Task 15
-- Find products whose name starts with the letter S

SELECT * FROM Products WHERE name LIKE 'S%';


-- Task 16
-- Find products whose name ends with Pro

SELECT * FROM Products WHERE name LIKE '%Pro';


-- Task 17
-- Find products whose name contains the word Air

SELECT * FROM Products WHERE name LIKE '%Air%';


-- Task 18
-- Retrieve customers whose email ends "net"

SELECT * FROM Customers WHERE email LIKE '%net';


-- Task 19
-- Find all products that are out of stock (stock_quantity=0)

SELECT * FROM Products WHERE stock_quantity=0;


-- Task 20
-- Display all product names in uppercase

SELECT UPPER(name) AS product_name FROM Products;


-- Task 21
-- Display the length of each product name

SELECT name, LENGTH(name) AS name_length FROM Products;


-- Task 22
-- Round the price of each product to the nearest whole number

SELECT ROUND(price) AS whole_price FROM Products; 