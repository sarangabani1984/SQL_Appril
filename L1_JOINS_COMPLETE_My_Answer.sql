

use InterviewL1_Joins

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

SELECT 
customer_name,
o.order_id,
p.product_name,
oi.quantity
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
on oi.order_id = o.order_id
JOIN Products p
on p.product_id = oi.product_id;


SELECT 
    C.customer_name,
    SUM(o.amount) AS total_spent,
    C.city                          -- ← Add this
FROM Customers AS C
JOIN Orders AS O
ON C.customer_id = O.customer_id
WHERE C.country = 'USA'
GROUP BY C.customer_name, C.city    -- ← Add city here too
HAVING SUM(o.amount) > 200;