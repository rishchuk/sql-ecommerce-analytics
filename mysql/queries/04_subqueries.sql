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

SELECT name, price
FROM Products p
WHERE price>(
    SELECT AVG(price)
    FROM Products
    WHERE category_id=p.category_id
);


-- Task 10
-- Find customers who have at least one completed payment

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer
FROM Customers c
WHERE EXISTS (
	SELECT 1
    FROM Orders o
    JOIN Payments p
		ON o.id=p.order_id
	WHERE o.customer_id=c.id
		AND p.status='COMPLETED'
);


-- Task 11
-- Find products ordered more than 5 times
SELECT p.name FROM Products p
WHERE id IN (
	SELECT product_id
    FROM Order_Items
    GROUP BY product_id
    HAVING COUNT(order_id)>5
);


-- Task 12
-- Find customers whose latest order is after 2026-01-01

SELECT
    CONCAT(c.first_name, ' ', c.last_name) as customer
FROM Customers c
WHERE (
    SELECT MAX(order_date)
    FROM Orders o
    WHERE o.customer_id = c.id
) > '2026-01-01';


-- Task 13
-- Display categories together with the number of products

SELECT c.name, (
	SELECT COUNT(*)
	FROM Products
	WHERE c.id=category_id
    GROUP BY category_id
) AS prod_count
FROM Categories c;


-- Task 14
-- Find products whose stock quantity is below the average stock quantity

SELECT name, stock_quantity
FROM Products
WHERE stock_quantity<(
	SELECT AVG(stock_quantity)
    FROM Products
);


-- Task 15
-- Find customers who have spent the maximum amount

SELECT customer, total_amount
FROM (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
        SUM(o.total_amount) AS total_amount
	FROM Customers c
    JOIN Orders o
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
) AS customer_amount
WHERE total_amount=(
	SELECT 
		SUM(total_amount) 
	FROM Orders 
    GROUP BY customer_id 
    ORDER BY SUM(total_amount) DESC LIMIT 1
);


-- Task 16
-- Find orders containing the most expensive product

SELECT order_id FROM Order_Items
WHERE product_id=(
	SELECT id 
    FROM Products
    ORDER BY price DESC
    LIMIT 1
);


-- Task 17
-- Find categories that contain products costing more than 1000

SELECT name FROM Categories
WHERE id IN (
	SELECT category_id
    FROM Products
    WHERE price>1000
);


-- Task 18
-- Find customers who purchased products from more than one category

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS customer 
FROM Customers c
WHERE 1<(
	SELECT COUNT(DISTINCT p.category_id)
    FROM Orders o
    JOIN Order_Items oi
		ON o.id=oi.order_id
     JOIN Products p
		ON p.id=oi.product_id
	WHERE c.id=o.customer_id
);


-- Task 19
-- Find products whose revenue is above the average product revenue

SELECT product, revenue 
FROM (
	SELECT
        p.name AS product,
        SUM(oi.quantity*oi.unit_price) AS revenue
    FROM Products p
    JOIN Order_Items oi
        ON p.id=oi.product_id
    GROUP BY p.id, p.name
) prod_revenue
WHERE revenue>(
	SELECT AVG(revenue)
    FROM (
		SELECT
			SUM(quantity*unit_price) AS revenue
		FROM Order_Items
        GROUP BY product_id
    ) AS avg_prod
);


-- Task 20
-- Create a customer performance report.
-- Display:
-- | Customer | Orders | Total Spent | Average Order |
-- Only include customers whose total spending is above the average customer spending

SELECT 
	Customer, customer_order AS 'Orders', total_spent AS 'Total Spent', 
    ROUND(total_spent / customer_order, 2) AS 'Average Order'
FROM (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) as Customer,
        COUNT(DISTINCT o.id) AS customer_order,
        SUM(total_amount) as total_spent
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
) AS report
WHERE total_spent>(
	SELECT AVG(customer_spent)
    FROM (
		SELECT 
			SUM(total_amount) as customer_spent
		FROM Orders
        GROUP BY customer_id
    ) AS customer_total
);