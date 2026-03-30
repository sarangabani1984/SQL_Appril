-- ============================================================================
-- LEVEL 5: DATABASE THEORY & ADVANCED PATTERNS
-- Normalization, Denormalization, Query Troubleshooting, Performance
-- ============================================================================

IF DB_ID('InterviewL5_Theory') IS NOT NULL
    DROP DATABASE InterviewL5_Theory;

CREATE DATABASE InterviewL5_Theory;
USE InterviewL5_Theory;

-- ============================================================================
-- TOPIC 17: NORMALIZATION & 1st Normal Form (1NF)
-- Real-world design issue: Students with multiple courses
-- ============================================================================

PRINT '=== TOPIC 17: NORMALIZATION & 1NF ===';
PRINT '';
PRINT 'Problem: What''s wrong with this design?';
PRINT '';

-- WRONG DESIGN (violates 1NF - repeating groups)
DROP TABLE IF EXISTS StudentCourses_WRONG;

CREATE TABLE StudentCourses_WRONG (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    courses VARCHAR(500)  -- ← WRONG! Repeating groups
);

INSERT INTO StudentCourses_WRONG VALUES
(1, 'Alice', 'Math, Physics, Chemistry'),
(2, 'Bob', 'History, Geography'),
(3, 'Charlie', 'Math, Biology');

PRINT 'BEFORE Normalization (WRONG):';
SELECT * FROM StudentCourses_WRONG;

PRINT '';
PRINT 'Problems:';
PRINT '  1. Can''t query "which students take Math" easily';
PRINT '  2. Can''t create foreign key to Courses table';
PRINT '  3. Can''t aggregate (COUNT courses per student)';
PRINT '  4. Data redundancy and update anomalies';
PRINT '';

-- ============================================================================
-- Q17.1: Design the normalized schema (1NF)
-- ============================================================================
PRINT 'Q17.1: Redesign using 1NF (remove repeating groups)';
PRINT '';

PRINT 'SOLUTION - Normalized Design:';
PRINT 'Create separate table: StudentCourses (junction table)';
PRINT '';

DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS StudentCourses;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

INSERT INTO Students VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

INSERT INTO Courses VALUES
(101, 'Math'),
(102, 'Physics'),
(103, 'Chemistry'),
(104, 'History'),
(105, 'Geography'),
(106, 'Biology');

CREATE TABLE StudentCourses (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(1),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO StudentCourses VALUES
(1001, 1, 101, 'A'),
(1002, 1, 102, 'B'),
(1003, 1, 103, 'A'),
(1004, 2, 104, 'B'),
(1005, 2, 105, 'A'),
(1006, 3, 101, 'C'),
(1007, 3, 106, 'B');

PRINT 'AFTER Normalization (1NF):';
PRINT 'Students table:';
SELECT * FROM Students;
PRINT '';
PRINT 'Courses table:';
SELECT * FROM Courses;
PRINT '';
PRINT 'StudentCourses junction table:';
SELECT * FROM StudentCourses;
PRINT '';

-- ============================================================================
-- Q17.2: Benefits of normalized design
-- ============================================================================
PRINT 'Q17.2: Now these queries are simple:';
PRINT '';

PRINT 'a) Find all students taking Math:';
SELECT DISTINCT s.student_name
FROM Students s
INNER JOIN StudentCourses sc ON s.student_id = sc.student_id
INNER JOIN Courses c ON sc.course_id = c.course_id
WHERE c.course_name = 'Math';

PRINT '';
PRINT 'b) Count courses per student:';
SELECT
    s.student_name,
    COUNT(sc.course_id) AS course_count
FROM Students s
LEFT JOIN StudentCourses sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.student_name;

PRINT '';
PRINT 'Explanation: Normalized design enables:';
PRINT '  ✓ Easy filtering and aggregation';
PRINT '  ✓ Foreign key constraints (data integrity)';
PRINT '  ✓ No data redundancy';
PRINT '  ✓ Easier updates/deletes';
PRINT '';

-- ============================================================================
-- TOPIC 18: DENORMALIZATION & Trade-offs
-- Real-world: High-traffic analytics dashboard
-- ============================================================================

PRINT '=== TOPIC 18: DENORMALIZATION & TRADE-OFFS ===';
PRINT '';

PRINT 'Scenario: Dashboard queries 1M orders, joins 4 tables, runs 100x/day';
PRINT 'Problem: Queries are slow (5 seconds each)';
PRINT 'Solution: Pre-compute and store aggregate results (denormalization)';
PRINT '';

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderDashboard;

-- NORMALIZED (but slow for dashboards)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(12, 2)
);

INSERT INTO Orders VALUES
(1, 101, '2024-01-15', 500.00),
(2, 102, '2024-01-16', 750.00),
(3, 101, '2024-02-10', 1200.00),
(4, 103, '2024-02-15', 300.00),
(5, 102, '2024-03-05', 650.00);

PRINT 'Slow normalized query (joined with 4 tables):';
PRINT 'SELECT customer_name, COUNT(*), SUM(amount)';
PRINT 'FROM Orders o';
PRINT 'JOIN Customers c ON ...';
PRINT 'JOIN Regions r ON ...';
PRINT 'JOIN Products p ON ...';
PRINT 'GROUP BY customer_name;';
PRINT '';
PRINT '^ Execution time: 5 seconds (too slow for dashboard)';
PRINT '';

-- DENORMALIZED (fast dashboard)
CREATE TABLE OrderDashboard (
    dashboard_date DATE,
    total_orders INT,
    total_revenue DECIMAL(15, 2),
    avg_order_value DECIMAL(10, 2),
    last_updated DATETIME
);

INSERT INTO OrderDashboard VALUES
('2024-03-30', 5, 3400.00, 680.00, GETDATE());

PRINT 'Fast denormalized query:';
PRINT 'SELECT * FROM OrderDashboard;';
PRINT '';
PRINT '^ Execution time: 10ms (instant!)';
PRINT '';

-- ============================================================================
-- Q18.1: When to denormalize
-- ============================================================================
PRINT 'Q18.1: Decision: When is denormalization appropriate?';
PRINT '';
PRINT 'DENORMALIZE when:';
PRINT '  1. Query performance is bottleneck (>1 second on high-traffic queries)';
PRINT '  2. Data is read-heavy (not frequently updated)';
PRINT '  3. Consistency can be maintained (use triggers, scheduled jobs)';
PRINT '  4. Storage is cheaper than CPU (cloud databases)';
PRINT '';
PRINT 'DON''T denormalize when:';
PRINT '  1. Data is frequently updated (inconsistency risk)';
PRINT '  2. Query is run infrequently (not worth pre-computing)';
PRINT '  3. Storage is limited (denormalization uses more space)';
PRINT '  4. Correctness is critical (no room for staleness)';
PRINT '';

-- ============================================================================
-- TOPIC 19: QUERY TROUBLESHOOTING
-- Real-world: "Blown-up join" returning 10x expected rows
-- ============================================================================

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Payments;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO Customers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount DECIMAL(10, 2)
);

INSERT INTO Orders VALUES
(101, 1, 500.00),
(102, 1, 750.00),   -- Alice has 2 orders
(103, 2, 300.00);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_amount DECIMAL(10, 2)
);

INSERT INTO Payments VALUES
(1001, 101, 250.00),
(1002, 101, 250.00),  -- Order 101 has 2 payments
(1003, 102, 750.00),
(1004, 103, 300.00);

PRINT '=== TOPIC 19: QUERY TROUBLESHOOTING ===';
PRINT '';

-- ============================================================================
-- Q19.1: Blown-up join example
-- ============================================================================
PRINT 'Q19.1: Problem - This query returns TOO MANY rows (cartesian product)';
PRINT '';

PRINT 'WRONG APPROACH:';
SELECT
    c.customer_name,
    COUNT(*) AS row_count
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id, c.customer_name;

PRINT '';
PRINT 'Result: Blown up! Alice''s count = 2 (should be 1)';
PRINT 'Why: Alice has 2 orders × 2 payments on order 101 = 4 rows (inflate count)';
PRINT '';

-- ============================================================================
-- Q19.2: Diagnose the issue
-- ============================================================================
PRINT 'Q19.2: Diagnose: What''s causing the duplication?';
PRINT '';

PRINT 'Step 1: Check Customers → Orders join:';
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS order_count
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

PRINT '';
PRINT 'Step 2: Check Orders → Payments join:';
SELECT
    o.order_id,
    COUNT(DISTINCT p.payment_id) AS payment_count
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id
GROUP BY o.order_id;

PRINT '';
PRINT 'Finding: Order 101 has 2 payments (cartesian product).';
PRINT '';

-- ============================================================================
-- Q19.3: Fix the problem
-- ============================================================================
PRINT 'Q19.3: Solution - Use aggregation BEFORE joining';
PRINT '';

PRINT 'CORRECT APPROACH:';
WITH OrderPaymentSummary AS (
    SELECT
        order_id,
        COUNT(DISTINCT payment_id) AS payment_count,
        SUM(payment_amount) AS total_paid
    FROM Payments
    GROUP BY order_id
)
SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(o.order_amount) AS total_order_value,
    SUM(ops.total_paid) AS total_paid
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN OrderPaymentSummary ops ON o.order_id = ops.order_id
GROUP BY c.customer_id, c.customer_name;

PRINT '';
PRINT 'Success! Correct counts now.';
PRINT '';

PRINT 'KEY PRINCIPLE: Aggregate before the join (if rows will multiply)';
PRINT '';

-- ============================================================================
-- TOPIC 20: PERFORMANCE OPTIMIZATION
-- Real-world: Optimize a 5-second query to 500ms
-- ============================================================================

DROP TABLE IF EXISTS Large_Orders;

-- Simulate large table
CREATE TABLE Large_Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    amount DECIMAL(12, 2),
    status VARCHAR(20)
);

-- Insert sample data (in real scenario: millions of rows)
DECLARE @counter INT = 1;
WHILE @counter <= 1000
BEGIN
    INSERT INTO Large_Orders VALUES
    (@counter, MOD(@counter, 100), MOD(@counter, 50), 
     DATEADD(DAY, -MOD(@counter, 365), '2024-01-01'),
     ROUND(RAND() * 10000, 2), 'Completed');
    SET @counter = @counter + 1;
END;

PRINT '=== TOPIC 20: PERFORMANCE OPTIMIZATION ===';
PRINT '';
PRINT 'Scenario: Query takes 5 seconds, needs to be 500ms';
PRINT '';

-- ============================================================================
-- Q20.1: Non-optimized query (slow)
-- ============================================================================
PRINT 'Q20.1: Original slow query (5 seconds):';
PRINT '';

PRINT 'SELECT';
PRINT '    customer_id,';
PRINT '    COUNT(*) as order_count,';
PRINT '    AVG(amount) as avg_order,';
PRINT '    SUM(CASE WHEN status=''Completed'' THEN amount ELSE 0 END) as completed_revenue';
PRINT 'FROM Large_Orders';
PRINT 'WHERE YEAR(order_date) = 2024';
PRINT 'GROUP BY customer_id';
PRINT 'HAVING SUM(amount) > 500;';
PRINT '';

PRINT 'Problems:';
PRINT '  ✗ No index on order_date';
PRINT '  ✗ No index on customer_id';
PRINT '  ✗ YEAR() function prevents index usage (non-SARGable)';
PRINT '  ✗ No HAVING clause optimization';
PRINT '';

-- ============================================================================
-- Q20.2: Optimized query (500ms)
-- ============================================================================
PRINT 'Q20.2: Optimized query (500ms) - Multiple strategies:';
PRINT '';

-- Strategy 1: Add indexes
PRINT '-- Add these indexes:';
PRINT 'CREATE INDEX idx_order_date ON Large_Orders(order_date, customer_id);';
PRINT 'CREATE INDEX idx_customer_id ON Large_Orders(customer_id, status, amount);';
PRINT '';

-- Strategy 2: Rewrite WHERE to be SARGable (index-friendly)
PRINT '-- Rewrite WHERE clause to be SARGable (able to seek in index):';
SELECT
    customer_id,
    COUNT(*) as order_count,
    AVG(amount) as avg_order,
    SUM(CASE WHEN status='Completed' THEN amount ELSE 0 END) as completed_revenue
FROM Large_Orders
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'  -- ← SARGable
GROUP BY customer_id
HAVING SUM(amount) > 500
ORDER BY completed_revenue DESC;

PRINT '';
PRINT 'Optimization techniques applied:';
PRINT '  ✓ Avoid functions on indexed columns (use BETWEEN instead of YEAR())';
PRINT '  ✓ Add WHERE clause (reduce rows before GROUP BY)';
PRINT '  ✓ Create covering indexes (all columns in query on index)';
PRINT '  ✓ Use HAVING for group-level filtering (after aggregation)';
PRINT '';

-- ============================================================================
-- Q20.3: Comparison of optimization impact
-- ============================================================================
PRINT 'Q20.3: Impact of each optimization:';
PRINT '';

PRINT 'Without Index: 5000ms';
PRINT '+ Index on (order_date, customer_id): 2000ms';
PRINT '+ SARGable WHERE clause: 1000ms';
PRINT '+ Covering index: 500ms';
PRINT '';

PRINT 'Final result: 5000ms → 500ms (10x faster!)';
PRINT '';

PRINT '=== END OF LEVEL 5: DATABASE THEORY ===';
PRINT '';
PRINT '=== CURRICULUM COMPLETE ===';
PRINT '';
PRINT 'You have covered:';
PRINT '  ✓ 20 Core SQL Topics';
PRINT '  ✓ 5 Levels of Difficulty';
PRINT '  ✓ 60+ Real-world Questions & Answers';
PRINT '  ✓ Production-Grade Patterns';
PRINT '';
PRINT 'Next Steps:';
PRINT '  1. Run all scripts to create databases';
PRINT '  2. Practice each question WITHOUT looking at answers';
PRINT '  3. Compare your approach with provided solutions';
PRINT '  4. Focus on understanding WHY, not just HOW';
PRINT '  5. Ask yourself: "What if data size 100x? What indexes needed?"';
PRINT '';
PRINT 'Interview Tips:';
PRINT '  • Always discuss trade-offs (performance vs readability)';
PRINT '  • Mention indexes, normalization, edge cases';
PRINT '  • Explain execution order (FROM, WHERE, GROUP BY, HAVING, ORDER BY)';
PRINT '  • Ask clarifying questions about business requirements';
PRINT '';
