-- Task 1
-- Display all orders with a row number ordered by order date
-- Display: order id, order date, row number 

SELECT
    id AS order_id,
    order_date,
    ROW_NUMBER() OVER (ORDER BY order_date) AS "row_number"
FROM orders;


-- Rank products by price from the most expensive to the cheapest
-- Display: product name, price, rank

SELECT
	name AS product_name,
    price,
    RANK() OVER (ORDER BY price DESC) AS "rank"
FROM Products;


-- Task 3
-- Rank products by price using DENSE_RANK()
-- Compare the result with RANK()

SELECT
	name AS product_name,
    price,
    RANK() OVER (ORDER BY price DESC) AS "rank",
    DENSE_RANK() OVER (ORDER BY price DESC) AS "dense_rank"
FROM Products;


-- Task 4
-- Find the top 3 most expensive products in each category
-- Display: category, product, price, rank

WITH products_by_category AS (
	SELECT 
		c.name AS category,
		p.name AS product,
		p.price,
		RANK() OVER (PARTITION BY c.id ORDER BY price DESC) AS rk
	FROM Products p
	JOIN Categories c
		ON c.id=p.category_id
)
SELECT
	category,
    product,
    price,
    rk AS "rank"
FROM products_by_category
WHERE rk<=3;


-- Task 5
-- Show every order with the total spending of that customer
-- Display: customer, order id, order amount, customer total spending

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer,
    o.id AS order_id,
    o.total_amount AS order_amount,
    SUM(o.total_amount) OVER (PARTITION BY c.id) AS customer_spending
FROM Orders o
JOIN Customers c
	ON c.id=o.customer_id
ORDER BY c.id, c.first_name,
	c.last_name, o.id;


-- Task 6
-- Calculate running total of sales ordered by date
-- Display: order date, order amount, cumulative revenue

SELECT
	order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date, id) AS cumulative_revenue
FROM Orders;


-- Task 7
-- Find the previous order amount for every order
-- Display: order id, date, amount, previous order amount

SELECT
	id AS order_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (ORDER BY order_date) AS previous_order_amount
FROM Orders;


-- Task 8
-- Find the next order date for every order

SELECT
	id AS order_id,
    order_date,
    total_amount,
    LEAD(order_date) OVER (ORDER BY order_date) AS next_order_date
FROM Orders;


-- Task 9
-- Compare each product price with the average price of its category
-- Display: product, category, price, category average price


SELECT
	p.name AS product,
    c.name AS category,
    p.price,
    ROUND(AVG(p.price) OVER (PARTITION BY c.id), 2) AS category_avg_price
FROM Products p
JOIN Categories c
	ON c.id=p.category_id;
    
    
-- Task 10
-- Find products whose price is above the category average
-- Use window functions only
WITH products_by_category AS (
	SELECT
		p.name AS product,
		c.name AS category,
		p.price,
		ROUND(AVG(p.price) OVER (PARTITION BY c.id), 2) AS category_avg_price
	FROM Products p
	JOIN Categories c
		ON c.id=p.category_id
)
SELECT 
	product, category, price, category_avg_price
FROM products_by_category
WHERE category_avg_price<price
ORDER BY category, product;


-- Task 11
-- Calculate each customer's percentage contribution to total revenue.
-- Display: customer, total spent, percentage

WITH customers_contibution AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
		SUM(o.total_amount) OVER (PARTITION BY c.id) AS total_spent, (
			SELECT SUM(total_amount) FROM Orders
		) AS total_revenue
	FROM Orders o
	JOIN Customers c
		ON c.id=o.customer_id
)
SELECT 
	customer, total_spent, ROUND(total_spent / total_revenue * 100, 4) AS percentage
FROM customers_contibution
GROUP BY customer, total_spent;


-- Task 12
-- Find the first order of every customer.

WITH customers_orders AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
		o.order_date,
		ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY o.order_date) AS row_num
	FROM Orders o
	JOIN Customers c
		ON c.id=o.customer_id
)
SELECT 
	customer, order_date
FROM customers_orders
WHERE row_num=1;


SELECT
	DISTINCT
	CONCAT(c.first_name, ' ', c.last_name) AS customer,
	FIRST_VALUE(o.order_date) OVER (PARTITION BY c.id ORDER BY o.order_date) AS first_order
FROM Orders o
JOIN Customers c
	ON c.id=o.customer_id;
    

-- Task 13
-- Find the latest order of every customer.

WITH customers_ordes AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
        o.order_date,
        ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY o.order_date DESC) AS row_num
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
)
SELECT 
	customer, order_date
FROM customers_ordes
WHERE row_num=1;


SELECT 
	DISTINCT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    FIRST_VALUE(o.order_date) OVER (PARTITION BY c.id ORDER BY o.order_date DESC) AS last_order
FROM Orders o
JOIN Customers c
	ON c.id=o.customer_id;


-- Task 14
-- Find the second most expensive product in every category

WITH products_by_category AS (
	SELECT
		c.name AS category,
		p.name AS product,
        p.price,
        ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY p.price DESC) AS row_num
	FROM Products p
    JOIN Categories c
		ON c.id=p.category_id
)
SELECT 
	category, product, price
FROM products_by_category
WHERE row_num=2;


-- Task 15
-- Calculate monthly revenue and month-over-month growth.
-- Display: month, revenue, previous month revenue, growth

WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
    year, month, revenue,
    LAG(revenue) OVER (ORDER BY year, month) AS prev_revenue,
	revenue-LAG(revenue) OVER (ORDER BY year, month) AS growth
FROM monthly_sales
ORDER BY year, month;


-- Task 16
-- Create a customer ranking by spending.
-- Display: customer, total spent, rank

WITH customers_spent AS (
	SELECT
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
		SUM(o.total_amount) AS total_spent
	FROM Orders o
	JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT 
	customer, 
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) as "rank"
FROM customers_spent;


-- Task 17
-- Find the best-selling product in every category
-- Based on quantity sold

WITH selling_products_by_category AS (
	SELECT 
		c.name AS category,
		p.name AS product,
		SUM(oi.quantity) AS quantity_sold,
		RANK() OVER (
				PARTITION BY c.id
				ORDER BY SUM(oi.quantity) DESC
			) AS rk
	FROM Order_Items oi
	JOIN Products p
		ON p.id=oi.product_id
	JOIN Categories c
		ON c.id=p.category_id
	GROUP BY c.id, c.name, p.id, p.name
)
SELECT category, product, quantity_sold
FROM selling_products_by_category
WHERE rk=1;


-- Task 18
-- Find customers whose spending increased compared with their previous order

WITH customers_spending AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
        o.total_amount,
        COALESCE(LAG(o.total_amount) OVER (PARTITION BY c.id ORDER BY o.order_date), 0) AS previous_order
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
)
SELECT 
	customer, total_amount, previous_order
FROM customers_spending
WHERE total_amount>previous_order
ORDER BY customer;


-- Task 19
-- Create a sales leaderboard
-- Display: customer, orders count, total spent, rank

WITH sales_leaderboard AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
        COUNT(o.id) AS orders_count,
        SUM(o.total_amount) AS total_spent
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT 
	customer,
    orders_count,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC,
						orders_count DESC) AS "rank"
FROM sales_leaderboard;


-- Task 20
-- Create a complete customer analytics report
-- Display:
-- | Customer | Orders | Total Spent | Avg Order | Rank | Previous Spending |

WITH customer_analytics_report AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS customer,
        COUNT(o.id) AS orders,
        SUM(o.total_amount) AS total_spent,
        ROUND(AVG(o.total_amount), 2) AS avg_order
	FROM Orders o
    JOIN Customers c
		ON c.id=o.customer_id
	GROUP BY c.id, c.first_name, c.last_name
)
SELECT 
	customer,
    orders,
    total_spent,
    avg_order,
    RANK() OVER (ORDER BY total_spent DESC, orders DESC) AS "rank",
	LAG(total_spent) OVER (ORDER BY total_spent DESC, orders DESC) AS previous_spending
FROM customer_analytics_report
ORDER BY total_spent DESC, orders DESC;