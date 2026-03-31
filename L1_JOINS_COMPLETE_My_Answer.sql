

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
