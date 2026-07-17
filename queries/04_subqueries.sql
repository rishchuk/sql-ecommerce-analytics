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


-- Task 5
-- Find orders whose total value is greater than the average order value
-- Calculate totals using Order_Items


SELECT order_id, total_value 
FROM (
	SELECT 
		order_id, SUM(quantity*unit_price) AS total_value
    FROM Order_Items
    GROUP BY order_id
) AS order_total
WHERE total_value>(
	SELECT 
    AVG(order_total)
    FROM (
		SELECT 
			SUM(quantity*unit_price) AS order_total
		FROM Order_Items
		GROUP BY order_id
    ) AS avg_order
);


-- Task 6
-- Find the most expensive product in each category

SELECT c.name, p.name, p.price 
FROM Products p 
JOIN Categories c ON c.id=p.category_id
WHERE p.price=(
	SELECT
		MAX(price)
    FROM Products
    WHERE category_id=p.category_id
);


-- Task 7
-- Find customers who spent more than the average customer spending

SELECT customer, total_spent
FROM (
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) AS customer,
        SUM(o.total_amount) AS total_spent
    FROM Customers c
    JOIN Orders o
        ON c.id = o.customer_id
    GROUP BY c.id, c.first_name, c.last_name
) AS customer_totals
WHERE total_spent>(
    SELECT AVG(total_spent)
    FROM (
        SELECT
            SUM(total_amount) AS total_spent
        FROM Orders
        GROUP BY customer_id
    ) AS totals
);


-- Task 8
-- Find categories whose average product price is above the overall average product price

SELECT c.name FROM Categories c
JOIN Products p 
	ON c.id=p.category_id
GROUP BY c.id, c.name
HAVING AVG(p.price) > (
    SELECT AVG(price)
    FROM Products
);


-- Task 9
-- Find products priced above the average price of their own category.
-- Use a correlated subquery

SELECT name, price
FROM Products p
WHERE price>(
    SELECT AVG(price)
    FROM Products
    WHERE category_id=p.category_id
);