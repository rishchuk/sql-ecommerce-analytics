-- Task 1
-- Calculate total sales for every order
-- Display: order id, total amount

WITH Orders_amount (order_id, total_amount) AS (
	SELECT 
		id, SUM(total_amount) 
	FROM Orders
    GROUP BY id
)
SELECT order_id, total_amount FROM Orders_amount;


-- Task 2
-- Find orders whose total value is above the average order value.

WITH Orders_amount (order_id, total_amount) AS (
	SELECT 
		id,
        SUM(total_amount)
	FROM Orders
    GROUP BY id
)
SELECT order_id, total_amount
FROM Orders_amount
WHERE total_amount>(
	SELECT 
		AVG(total_amount)
	FROM Orders_amount
);


-- Task 3
-- Calculate total spending for every customer.
-- Display: customer, total spent

WITH Customers_spent (customer, total_spent) AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name),
        SUM(o.total_amount)
	FROM Orders o
	JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT customer, total_spent FROM Customers_spent;


-- Task 4
-- Find customers who spent more than the average customer spending

WITH Customers_spent (customer, total_spent) AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name),
        SUM(total_amount)
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT customer, total_spent
FROM Customers_spent
WHERE total_spent>(
	SELECT 
		AVG(total_spent) 
    FROM Customers_spent
);


-- Task 5
-- Calculate revenue for every product.
-- Display: product, revenue

WITH Product_revenue (product, revenue) AS (
	SELECT 
		p.name,
        SUM(oi.quantity*oi.unit_price)
	FROM Order_Items oi
    JOIN Products p
		ON p.id=oi.product_id
	GROUP BY p.id, p.name
)
SELECT product, revenue FROM Product_revenue;


-- Task 6
-- Find products whose revenue is above the average product revenue

WITH Product_revenue (product, revenue) AS (
	SELECT 
		p.name,
        SUM(oi.quantity*oi.unit_price)
	FROM Order_Items oi
    JOIN Products p
		ON p.id=oi.product_id
	GROUP BY p.id, p.sku, p.name
)
SELECT product, revenue 
FROM Product_revenue
WHERE revenue>(
	SELECT AVG(revenue)
    FROM Product_revenue
);


-- Task 7
-- Find the customer who spent the most

WITH Max_customer_spent (customer, total_spent) AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name),
        SUM(o.total_amount) 
	FROM Customers c
    JOIN Orders o
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT customer, total_spent 
FROM Max_customer_spent
ORDER BY total_spent DESC LIMIT 1;


-- Task 8
-- Calculate total revenue for every category.
-- Display: category, revenue

WITH Total_revenue (category, revenue) AS (
	SELECT 
		c.name,
        SUM(oi.quantity*oi.unit_price)
	FROM Order_Items oi
    JOIN Products p
		ON p.id=oi.product_id
	JOIN Categories c
		ON c.id=p.category_id
	GROUP BY c.id, c.name
)
SELECT category, revenue FROM Total_revenue;


-- Task 9
-- Find categories whose revenue is above the average category revenue

WITH Categories_revenue (category, revenue) AS (
	SELECT 
		c.name,
        SUM(oi.quantity*oi.unit_price)
	FROM Order_Items oi
	JOIN Products p
		ON p.id=oi.product_id
	JOIN Categories c
		ON c.id=p.category_id
	GROUP BY c.id, c.name
)
SELECT category, revenue 
FROM Categories_revenue
WHERE revenue>(
	SELECT AVG(revenue)
    FROM Categories_revenue
);


-- Task 10
-- Calculate monthly sales.
-- Display: year, month, revenue

WITH Monthly_sales (year, month, revenue) AS (
	SELECT 
		YEAR(order_date), 
        MONTH(order_date), 
		SUM(total_amount)
	FROM Orders
	GROUP BY YEAR(order_date), MONTH(order_date) 
)
SELECT year, month, revenue 
FROM Monthly_sales
ORDER BY year, month;