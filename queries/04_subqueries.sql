-- Task 1
-- Find products that cost more than the average product price
-- Display: product name, price

SELECT name, price 
FROM Products
WHERE price>(
	SELECT AVG(price)
	FROM Products
);


-- Task 2
-- Find customers who have placed at least one order
-- Display: first name, last name

SELECT c.first_name, c.last_name
FROM Customers c WHERE c.id IN (
	SELECT customer_id FROM Orders
);


-- Task 3
-- Find customers who have never placed an order

SELECT c.first_name, c.last_name
FROM Customers c WHERE c.id NOT IN (
	SELECT customer_id FROM Orders
);


SELECT c.first_name, c.last_name
FROM Customers c WHERE NOT EXISTS (
	SELECT 1 FROM Orders o
    WHERE o.customer_id=c.id
);


-- Task 4
-- Find products that have never been ordered
-- Display: product, name

SELECT name FROM Products
WHERE id NOT IN (
	SELECT product_id 
    FROM Order_Items
);

SELECT name FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Order_Items oi
    WHERE oi.product_id = p.id
);