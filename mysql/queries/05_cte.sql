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


-- Task 11
-- Find the month with the highest revenue

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
ORDER BY revenue DESC
LIMIT 1;


-- Task 12
-- Create an order summary.
-- Display: order id, customer, number of products, order total

WITH Order_summary (order_id, customer, number_of_products, order_total) AS (
	SELECT 
		o.id, 
        CONCAT(c.first_name, ' ', c.last_name),
        SUM(oi.quantity),
        o.total_amount
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	JOIN Order_Items oi
		ON o.id=oi.order_id
	GROUP BY o.id, c.first_name,
        c.last_name, o.total_amount
)
SELECT 
	order_id, customer, 
    number_of_products, order_total
FROM Order_summary;


-- Task 13
-- Calculate the average product price for every category.
-- Then show only categories above the global average

WITH Avg_prod_pirce_by_category (category, avg_price) AS (
	SELECT 
		c.name,
        AVG(p.price)
	FROM Products p
    JOIN Categories c
		ON c.id=p.category_id
	GROUP BY c.id, c.name
)
SELECT category, avg_price
FROM Avg_prod_pirce_by_category
WHERE avg_price>(
	SELECT AVG(avg_price)
    FROM Avg_prod_pirce_by_category
);


-- Task 14
-- Create a customer statistics report.
-- Display: customer, orders, total spent, average order value

WITH Statistics_report (customer, orders, total_spent, average_order_value) AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name),
		COUNT(o.id),
        SUM(o.total_amount),
        AVG(o.total_amount)
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT 
	customer, orders, total_spent, average_order_value 
FROM Statistics_report;


-- Task 15
-- Find customers whose average order value is above the average order value of all customers

WITH Customers_average (customer, average_order_value) AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name), 
        AVG(o.total_amount)
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT customer, average_order_value
FROM Customers_average
WHERE average_order_value>(
	SELECT AVG(average_order_value)
    FROM Customers_average
);


-- Task 16
-- Find products that generated no revenue

WITH Product_with_no_revenue (product, revenue) AS (
	SELECT 
		p.name,
        COALESCE(SUM(oi.quantity * oi.unit_price), 0)
	FROM Products p
    LEFT JOIN Order_Items oi
		ON p.id=oi.product_id
	 GROUP BY p.id, p.name
)
SELECT product
FROM Product_with_no_revenue
WHERE revenue=0;


-- Task 17
-- Create a category performance report.
-- Display: category, products, revenue, average price, stock quantity

WITH Performance_report (category, products, revenue, average_price, stock_quantity) AS (
	SELECT
		c.name,
        COUNT(DISTINCT p.id),
        COALESCE(SUM(oi.quantity*oi.unit_price), 0),
        AVG(p.price),
        SUM(p.stock_quantity)
	FROM Categories c
    JOIN Products p
		ON c.id=p.category_id
	LEFT JOIN Order_Items oi
		ON p.id=oi.product_id
	GROUP BY c.id, c.name
)
SELECT 
	category, products, revenue, average_price, stock_quantity
FROM Performance_report;


-- Task 18
-- Find the top 3 customers by spending

WITH Customers_spent (customer, total_amount) AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name),
        SUM(o.total_amount)
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT customer, total_amount
FROM Customers_spent
ORDER BY total_amount DESC
LIMIT 3;


-- Task 19
-- Create a sales dashboard.
-- Display: total customers, total orders, total products, total revenue

WITH All_customers AS (
	SELECT COUNT(*) AS total_customers
    FROM Customers
), 
All_orders AS (
	SELECT COUNT(*) AS total_orders,
		SUM(total_amount) AS total_revenue
    FROM Orders
),
All_products AS (
	SELECT COUNT(*) AS total_products
    FROM Products
)
SELECT 
	c.total_customers, o.total_orders, p.total_products, o.total_revenue
FROM All_orders o 
CROSS JOIN All_customers c
CROSS JOIN All_products p;


-- Task 20
-- Create a complete business report
-- Display:
-- | Customer | Orders | Total Spent | Avg Order |
-- Prepare the data so that it can later be extended with window functions

WITH Business_report (customer, orders, total_spent, avg_order) AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name),
        COUNT(o.id),
        SUM(o.total_amount),
        AVG(o.total_amount)
	FROM Customers c
	JOIN Orders o
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT 
	customer, orders, total_spent, avg_order
FROM Business_report
ORDER BY customer;