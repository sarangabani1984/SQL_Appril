-- ============================================================================
-- LEVEL 1: FOUNDATIONAL JOINS & SET OPERATIONS
-- Real-world e-commerce, HR, and financial scenarios
-- ============================================================================

-- ============================================================================
-- DATABASE SETUP
-- ============================================================================
IF DB_ID('InterviewL1_Joins') IS NOT NULL
    DROP DATABASE InterviewL1_Joins;

CREATE DATABASE InterviewL1_Joins;
USE InterviewL1_Joins;

-- ============================================================================
-- TOPIC 1: INNER JOINS - E-Commerce Scenario
-- Real-world use case: Match customers with their orders
-- ============================================================================

-- Table 1: Customers
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE
);

INSERT INTO Customers VALUES
(1, 'Alice Johnson', 'alice@email.com', 'New York', 'USA', '2024-01-15'),
(2, 'Bob Smith', 'bob@email.com', 'London', 'UK', '2024-02-10'),
(3, 'Charlie Brown', 'charlie@email.com', 'Toronto', 'Canada', '2024-03-05'),
(4, 'Diana Prince', 'diana@email.com', 'Sydney', 'Australia', '2024-03-20'),
(5, 'Edward Norton', 'edward@email.com', 'Berlin', 'Germany', '2024-04-01');
-- NOTE: Customer 6 (Fredrick) has no orders - won't appear in INNER JOIN

-- Table 2: Orders
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders VALUES
(1001, 1, '2024-01-20', 150.00, 'Completed'),
(1002, 1, '2024-02-15', 250.00, 'Completed'),
(1003, 2, '2024-02-20', 500.00, 'Completed'),
(1004, 3, '2024-03-10', 75.50, 'Pending'),
(1005, 4, '2024-03-25', 1200.00, 'Completed'),
(1006, 1, '2024-04-05', 300.00, 'Shipped'),
(1007, 2, '2024-04-10', 425.00, 'Completed');
-- NOTE: Customer 5 (Edward) has no orders YET

-- Table 3: Products
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    supplier_id INT
);

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 999.99, 10),
(102, 'Mouse', 'Electronics', 29.99, 10),
(103, 'Desk Chair', 'Furniture', 299.99, 20),
(104, 'Monitor', 'Electronics', 399.99, 10),
(105, 'Keyboard', 'Electronics', 79.99, 10);

-- Table 4: Order_Items (Order line items)
DROP TABLE IF EXISTS Order_Items;
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Order_Items VALUES
(1, 1001, 102, 2, 29.99),
(2, 1002, 101, 1, 999.99),
(3, 1003, 103, 1, 299.99),
(4, 1003, 102, 5, 29.99),
(5, 1004, 105, 3, 79.99),
(6, 1005, 101, 2, 999.99),
(7, 1006, 104, 1, 399.99),
(8, 1007, 103, 1, 299.99);

-- ============================================================================
-- TOPIC 1: INNER JOINS - QUESTIONS
-- ============================================================================

PRINT '=== TOPIC 1: INNER JOINS ===';
PRINT '';

-- ============================================================================
-- Q1.1: Find all customers and their orders
-- ============================================================================
PRINT 'Q1.1: List all customers who have placed orders with order details';
PRINT 'Expected output: customer_id, customer_name, order_id, order_date, amount';
PRINT '';

PRINT 'ANSWER Q1.1:';
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

PRINT '';
PRINT 'Explanation: INNER JOIN returns only matching records. ';
PRINT 'Customer 5 (Edward) will NOT appear because they have no orders.';
PRINT '';

-- ============================================================================
-- Q1.2: Multi-table INNER JOINs - Orders with Products
-- ============================================================================
PRINT 'Q1.2: Show customer name, order ID, product name, and quantity ordered';
PRINT 'Expected: customer_name, order_id, product_name, quantity';
PRINT '';

PRINT 'ANSWER Q1.2:';
SELECT
    c.customer_name,
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

PRINT '';
PRINT 'Explanation: Chaining multiple INNER JOINs to connect all related tables.';
PRINT 'All four conditions must be met for a row to be included.';
PRINT '';

-- ============================================================================
-- Q1.3: INNER JOIN with Filtering (WHERE clause)
-- ============================================================================
PRINT 'Q1.3: Find customers from USA who spent more than $200 in total';
PRINT 'Expected: customer_name, total_spent, city';
PRINT '';

PRINT 'ANSWER Q1.3:';
SELECT
    c.customer_name,
    SUM(o.amount) AS total_spent,
    c.city
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
GROUP BY c.customer_id, c.customer_name, c.city
HAVING SUM(o.amount) > 200
ORDER BY total_spent DESC;

PRINT '';
PRINT 'Explanation: Combine INNER JOIN with aggregation.';
PRINT 'WHERE filters individual rows (country = USA)';
PRINT 'HAVING filters grouped results (total > 200)';
PRINT '';

-- ============================================================================
-- TOPIC 2: LEFT JOINs - HR Scenario
-- Real-world use case: Find which employees haven''t submitted timesheets
-- ============================================================================

DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Timesheets;

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    hire_date DATE
);

INSERT INTO Employees VALUES
(101, 'Alice Cooper', 'Engineering', '2023-01-15'),
(102, 'Bob Dylan', 'Engineering', '2023-02-10'),
(103, 'Charlie Parker', 'Sales', '2023-03-20'),
(104, 'Diana Ross', 'HR', '2023-04-01'),
(105, 'Edward Scissor', 'Finance', '2023-05-10'),
(106, 'Fiona Apple', 'Marketing', '2023-06-01');

CREATE TABLE Timesheets (
    timesheet_id INT PRIMARY KEY,
    emp_id INT,
    week_ending DATE,
    hours_worked INT,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Timesheets VALUES
(1, 101, '2024-03-29', 40),
(2, 102, '2024-03-29', 40),
(3, 103, '2024-03-29', 35),
(4, 104, '2024-03-29', 40),
-- NOTE: Employee 105 (Edward) missing timesheet for this week
-- NOTE: Employee 106 (Fiona) missing timesheet for this week
(5, 101, '2024-04-05', 42),
(6, 102, '2024-04-05', 38);

PRINT '=== TOPIC 2: LEFT JOINs ===';
PRINT '';

-- ============================================================================
-- Q2.1: Find employees with and without timesheets
-- ============================================================================
PRINT 'Q2.1: List all employees and show if they submitted a timesheet for week ending 2024-03-29';
PRINT 'Expected: emp_name, department, hours_worked (NULL if not submitted)';
PRINT '';

PRINT 'ANSWER Q2.1:';
SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    t.hours_worked,
    CASE WHEN t.timesheet_id IS NULL THEN 'NOT SUBMITTED' ELSE 'SUBMITTED' END AS status
FROM Employees e
LEFT JOIN Timesheets t ON e.emp_id = t.emp_id AND t.week_ending = '2024-03-29'
ORDER BY e.emp_id;

PRINT '';
PRINT 'Explanation: LEFT JOIN keeps ALL employees, even those without timesheets.';
PRINT 'Edward (105) and Fiona (106) will show NULL in timesheet columns.';
PRINT '';

-- ============================================================================
-- Q2.2: Find employees who NEVER submitted any timesheet
-- ============================================================================
PRINT 'Q2.2: Find employees who have NEVER submitted a timesheet';
PRINT 'Expected: emp_name, department';
PRINT '';

PRINT 'ANSWER Q2.2:';
SELECT
    e.emp_id,
    e.emp_name,
    e.department
FROM Employees e
LEFT JOIN Timesheets t ON e.emp_id = t.emp_id
WHERE t.timesheet_id IS NULL
ORDER BY e.emp_name;

PRINT '';
PRINT 'Explanation: LEFT JOIN + WHERE IS NULL finds unmatched employees.';
PRINT 'This is the standard pattern for "find rows with no related records".';
PRINT '';

-- ============================================================================
-- Q2.3: Count employees with/without timesheets
-- ============================================================================
PRINT 'Q2.3: Show total employees and how many submitted timesheets for each week';
PRINT 'Expected: week_ending, submitted_count, not_submitted_count';
PRINT '';

PRINT 'ANSWER Q2.3:';
SELECT
    t.week_ending,
    COUNT(DISTINCT CASE WHEN t.timesheet_id IS NOT NULL THEN e.emp_id END) AS submitted_count,
    COUNT(DISTINCT e.emp_id) - COUNT(DISTINCT CASE WHEN t.timesheet_id IS NOT NULL THEN e.emp_id END) AS not_submitted_count,
    COUNT(DISTINCT e.emp_id) AS total_employees
FROM Employees e
LEFT JOIN Timesheets t ON e.emp_id = t.emp_id
GROUP BY t.week_ending
ORDER BY t.week_ending;

PRINT '';
PRINT 'Explanation: LEFT JOIN allows aggregation of matching vs non-matching records.';
PRINT '';

-- ============================================================================
-- TOPIC 3: UNION vs UNION ALL - Finance Scenario
-- Real-world: Combine transactions from multiple accounts
-- ============================================================================

DROP TABLE IF EXISTS Checking_Accounts;
DROP TABLE IF EXISTS Savings_Accounts;

CREATE TABLE Checking_Accounts (
    transaction_id INT PRIMARY KEY,
    account_number VARCHAR(20),
    amount DECIMAL(10, 2),
    transaction_date DATE,
    description VARCHAR(100)
);

INSERT INTO Checking_Accounts VALUES
(1, 'CHK-001', 500.00, '2024-03-25', 'Salary Deposit'),
(2, 'CHK-001', 50.00, '2024-03-26', 'ATM Withdrawal'),
(3, 'CHK-002', 200.00, '2024-03-25', 'Transfer In'),
(4, 'CHK-001', 100.00, '2024-03-27', 'Restaurant'),
(5, 'CHK-002', 100.00, '2024-03-27', 'Duplicate Fee');

CREATE TABLE Savings_Accounts (
    transaction_id INT PRIMARY KEY,
    account_number VARCHAR(20),
    amount DECIMAL(10, 2),
    transaction_date DATE,
    description VARCHAR(100)
);

INSERT INTO Savings_Accounts VALUES
(101, 'SAV-001', 1000.00, '2024-03-20', 'Monthly Interest'),
(102, 'SAV-002', 500.00, '2024-03-21', 'Interest Accrual'),
(103, 'SAV-001', 1000.00, '2024-03-20', 'Duplicate Interest'); -- Duplicate row

PRINT '=== TOPIC 3: UNION vs UNION ALL ===';
PRINT '';

-- ============================================================================
-- Q3.1: UNION (removes duplicates)
-- ============================================================================
PRINT 'Q3.1: Combine all transactions from checking and savings accounts (no duplicates)';
PRINT 'Expected: account_number, amount, transaction_date, description';
PRINT '';

PRINT 'ANSWER Q3.1 - UNION (removes duplicates):';
SELECT account_number, amount, transaction_date, description
FROM Checking_Accounts
UNION
SELECT account_number, amount, transaction_date, description
FROM Savings_Accounts
ORDER BY transaction_date, amount;

PRINT '';
PRINT 'Explanation: UNION removes duplicate rows. Performance cost: higher.';
PRINT 'Use when you want unique rows, but data deduplication is expensive.';
PRINT '';

-- ============================================================================
-- Q3.2: UNION ALL (keeps duplicates)
-- ============================================================================
PRINT 'Q3.2: Combine all transactions (keep all, including duplicates)';
PRINT 'Expected: Same columns, but with duplicate rows if they exist';
PRINT '';

PRINT 'ANSWER Q3.2 - UNION ALL (keeps duplicates):';
SELECT account_number, amount, transaction_date, description
FROM Checking_Accounts
UNION ALL
SELECT account_number, amount, transaction_date, description
FROM Savings_Accounts
ORDER BY transaction_date, amount;

PRINT '';
PRINT 'Explanation: UNION ALL is faster - no deduplication overhead.';
PRINT 'Use when performance matters and you''re confident there are no duplicates.';
PRINT '';

-- ============================================================================
-- Q3.3: PERFORMANCE COMPARISON
-- ============================================================================
PRINT 'Q3.3: When should you use UNION vs UNION ALL?';
PRINT '';
PRINT 'ANSWER Q3.3:';
PRINT 'USE UNION when:';
PRINT '  1. You EXPECT duplicates across datasets';
PRINT '  2. Business logic requires unique records';
PRINT '  3. Data quality issues are known (e.g., ETL errors)';
PRINT '';
PRINT 'USE UNION ALL when:';
PRINT '  1. You''re aggregating non-overlapping datasets (e.g., daily + monthly data)';
PRINT '  2. Performance is critical (no sort/dedup overhead)';
PRINT '  3. You trust data quality and duplicates are impossible';
PRINT '';

-- ============================================================================
-- TOPIC 4: INTERSECT & MINUS - Marketing Scenario
-- Real-world: Find customers in BOTH campaigns vs exclusive customers
-- ============================================================================

DROP TABLE IF EXISTS Email_Campaign;
DROP TABLE IF EXISTS SMS_Campaign;

CREATE TABLE Email_Campaign (
    customer_id INT,
    customer_name VARCHAR(100),
    signup_date DATE
);

INSERT INTO Email_Campaign VALUES
(1, 'Alice Johnson', '2024-01-15'),
(2, 'Bob Smith', '2024-02-10'),
(3, 'Charlie Brown', '2024-03-05'),
(4, 'Diana Prince', '2024-03-20');

CREATE TABLE SMS_Campaign (
    customer_id INT,
    customer_name VARCHAR(100),
    signup_date DATE
);

INSERT INTO SMS_Campaign VALUES
(2, 'Bob Smith', '2024-02-10'),
(3, 'Charlie Brown', '2024-03-05'),
(5, 'Edward Norton', '2024-05-01');

PRINT '=== TOPIC 4: INTERSECT & MINUS ===';
PRINT '';

-- ============================================================================
-- Q4.1: INTERSECT - Customers in BOTH campaigns
-- ============================================================================
PRINT 'Q4.1: Find customers who opted into BOTH email AND SMS campaigns';
PRINT 'Expected: customer_id, customer_name';
PRINT '';

PRINT 'ANSWER Q4.1 - Using INTERSECT:';
SELECT customer_id, customer_name
FROM Email_Campaign
INTERSECT
SELECT customer_id, customer_name
FROM SMS_Campaign
ORDER BY customer_id;

PRINT '';
PRINT 'Explanation: INTERSECT returns rows that exist in BOTH sets.';
PRINT 'Result: Bob (2) and Charlie (3) are in both campaigns.';
PRINT '';

-- ============================================================================
-- Q4.2: MINUS - Customers in Email but NOT SMS
-- ============================================================================
PRINT 'Q4.2: Find customers who opted into EMAIL but refused SMS';
PRINT 'Expected: customer_id, customer_name';
PRINT '';

PRINT 'ANSWER Q4.2 - Using MINUS (or EXCEPT in some databases):';
SELECT customer_id, customer_name
FROM Email_Campaign
MINUS
SELECT customer_id, customer_name
FROM SMS_Campaign
ORDER BY customer_id;

PRINT '';
PRINT 'Explanation: MINUS returns rows in first set but NOT in second.';
PRINT 'Result: Alice (1) and Diana (4) are email-only customers.';
PRINT '';

-- ============================================================================
-- Q4.3: Set Operations with LEFT JOIN (Alternative approach)
-- ============================================================================
PRINT 'Q4.3: Replicate INTERSECT & MINUS using LEFT JOIN (more flexible)';
PRINT '';

PRINT '-- Finding BOTH (using INNER JOIN):';
SELECT DISTINCT
    e.customer_id,
    e.customer_name
FROM Email_Campaign e
INNER JOIN SMS_Campaign s ON e.customer_id = s.customer_id;

PRINT '';
PRINT '-- Finding Email-only (using LEFT JOIN with IS NULL):';
SELECT
    e.customer_id,
    e.customer_name
FROM Email_Campaign e
LEFT JOIN SMS_Campaign s ON e.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

PRINT '';
PRINT 'Explanation: JOINs are more flexible than set operations.';
PRINT 'You can add additional columns, filtering, and aggregations.';
PRINT '';

PRINT '=== END OF LEVEL 1: JOINS & SET OPERATIONS ===';
