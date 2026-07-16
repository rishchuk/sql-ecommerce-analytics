-- Task 1
-- Retrieve all orders with customer information.
-- Display: order id,  order date, order status, customer first name, customer last name

SELECT o.id, o.order_date, o.status, c.first_name, c.last_name 
FROM Orders o JOIN Customers c ON c.id=o.customer_id;


-- Task 2
-- Retrieve all products with their category names.
-- Display: product name, price, category name

SELECT p.name AS product_name, p.price, c.name AS category_name FROM Products p
JOIN Categories c ON c.id=p.category_id;


-- Task 3
-- Retrieve all order items with product information.
-- Display: order id, product name, quantity, unit price

SELECT oi.order_id, p.name, oi.quantity, oi.unit_price FROM Order_Items oi
JOIN Products p ON p.id=oi.product_id;


-- Task 4
-- Retrieve complete order information:
-- Display: order id, customer name, product name, quantity, unit price
-- Tables involved: Customers, Orders, Order_Items, Products

SELECT o.id, CONCAT(c.first_name,' ',c.last_name) AS 'Customer name', p.name, oi.quantity, oi.unit_price FROM Orders o
JOIN Customers c ON c.id=o.customer_id JOIN Order_Items oi ON o.id=oi.order_id
JOIN Products p ON p.id=oi.product_id;


-- Task 5
-- Retrieve all customers and their orders.
-- Include customers who have no orders.
-- Display: customer name, order id, order status

SELECT CONCAT(c.first_name,' ',c.last_name) AS 'Customer name', o.id, o.status FROM Customers c
LEFT JOIN Orders o ON c.id=o.customer_id;


-- Task 6
-- Find customers who have never placed an order.
-- Display: customer id, first name, last name

SELECT c.id, c.first_name, c.last_name FROM Customers c
LEFT JOIN Orders o ON c.id=o.customer_id WHERE o.id IS NULL;


-- Task 7
-- Retrieve all products and their categories.
-- Include products without categories.

SELECT p.name AS product_name, c.name AS category_name FROM Products p
LEFT JOIN Categories c ON c.id=p.category_id;


-- Task 8
-- Find categories that do not have any products.
-- Display: category id, category name

SELECT c.id, c.name FROM Categories c
LEFT JOIN Products p ON c.id=p.category_id WHERE p.id IS NULL;


-- Task 9
-- Retrieve all orders with payment information.
-- Display: order id, order status, payment amount, payment method, payment status

SELECT o.id, o.status, p.amount, p.payment_method, p.status FROM Orders o
JOIN Payments p ON o.id=p.order_id;


-- Task 10
-- Retrieve customers with completed payments.
-- Display: customer name, order id, payment amount

SELECT CONCAT(c.first_name, ' ', c.last_name) AS 'Customer name', o.id, p.amount FROM Orders o
JOIN Customers c ON c.id=o.customer_id
JOIN Payments p ON o.id=p.order_id
WHERE p.status = 'COMPLETED';


-- Task 11
-- Retrieve all products purchased in orders.
-- Display: product name, order id, customer id

SELECT p.name, o.id, c.id FROM Orders o
JOIN Customers c ON c.id=o.customer_id
JOIN Order_Items oi ON o.id=oi.order_id
JOIN Products p ON p.id=oi.product_id;


-- Task 12
-- Find products that have never been ordered.
-- Display: product id, product name

SELECT p.id, p.name FROM Products AS p
LEFT JOIN Order_Items AS oi ON p.id = oi.product_id
WHERE oi.id IS NULL;


-- Task 13
-- Retrieve order information sorted by customer last name.
-- Display: customer last name, order id, order date

SELECT c.last_name, o.id, o.order_date FROM Orders o
JOIN Customers c ON c.id=o.customer_id ORDER BY c.last_name;


-- Task 14
-- Retrieve all delivered orders with customer information.
-- Display: customer name, order id, order date

SELECT CONCAT(c.first_name, ' ', c.last_name) AS 'Customer name', o.id, o.order_date FROM Orders o
JOIN Customers c ON c.id=o.customer_id WHERE o.status='DELIVERED';


-- Task 15
-- Create a complete order report

SELECT CONCAT(c.first_name, ' ', c.last_name) AS Customer,
	o.id AS 'Order ID', p.name AS Product, oi.quantity as Quantity,
    oi.unit_price AS Price, pay.status AS 'Payment Status'
FROM Orders o JOIN Order_Items oi ON o.id=oi.order_id
JOIN Products p ON p.id=oi.product_id JOIN Customers c ON c.id=o.customer_id
JOIN Payments pay ON o.id=pay.order_id ORDER BY o.id, p.name;