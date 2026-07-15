-- 1. Count records

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM Customers

UNION ALL

SELECT 'products', COUNT(*) FROM Products

UNION ALL

SELECT 'orders', COUNT(*) FROM Orders

UNION ALL

SELECT 'order_items', COUNT(*) FROM Order_Items

UNION ALL

SELECT 'payments', COUNT(*) FROM Payments;


-- 2. Orders without customers
-- Should return 0 rows

SELECT o.id AS order_id FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.id
WHERE c.id IS NULL;


-- 3. Order items without orders
-- Should return 0 rows

SELECT oi.id AS order_item_id FROM Order_Items oi
LEFT JOIN Orders o ON oi.order_id = o.id
WHERE o.id IS NULL;


-- 4. Order items without products
-- Should return 0 rows

SELECT oi.id AS order_item_id FROM Order_Items oi
LEFT JOIN Products p ON oi.product_id = p.id
WHERE p.id IS NULL;


-- 5. Payments without orders
-- Should return 0 rows

SELECT p.id AS payment_id FROM Payments p
LEFT JOIN Orders o ON p.order_id = o.id
WHERE o.id IS NULL;


-- 6. Check duplicate emails
-- Should return 0 rows

SELECT email, COUNT(*) AS duplicates FROM Customers
GROUP BY email HAVING COUNT(*) > 1;


-- 7. Check duplicate SKU
-- Should return 0 rows

SELECT sku, COUNT(*) AS duplicates FROM Products
GROUP BY sku HAVING COUNT(*) > 1;


-- 8. Orders with incorrect total amount
-- Compare orders.total_amount with order_items calculation

SELECT o.id AS order_id, o.total_amount AS stored_amount,
SUM(oi.quantity * oi.unit_price) AS calculated_amount
FROM Orders o
JOIN Order_Items oi ON o.id = oi.order_id
GROUP BY o.id, o.total_amount
HAVING ROUND(o.total_amount,2) <> ROUND(SUM(oi.quantity * oi.unit_price), 2);


-- 9. Products with negative stock
-- Should return 0 rows

SELECT * FROM Products WHERE stock_quantity < 0;


-- 10. Orders without items
-- Should return 0

SELECT o.id AS order_id FROM Orders o
LEFT JOIN Order_Items oi ON o.id = oi.order_id
WHERE oi.id IS NULL;


-- 11. Payment amount mismatch
-- Compare payment with order total

SELECT p.order_id, p.amount AS payment_amount, o.total_amount AS order_amount
FROM Payments p 
JOIN Orders o ON p.order_id = o.id 
WHERE p.amount <> o.total_amount;