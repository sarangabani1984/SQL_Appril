-- ============================================================================
-- Q1.1: Find all customers and their orders
-- ============================================================================
PRINT 'Q1.1: List all customers who have placed orders with order details';
PRINT 'Expected output: customer_id, customer_name, order_id, order_date, amount';


use InterviewL1_Joins

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM Customers c
INNER JOIN Orders o 
ON c.customer_id = o.customer_id