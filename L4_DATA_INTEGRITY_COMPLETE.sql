-- ============================================================================
-- LEVEL 4: DATA INTEGRITY & PERFORMANCE
-- Deduplication, Self-Joins, Hierarchies, Pivoting, CTEs
-- ============================================================================

IF DB_ID('InterviewL4_DataIntegrity') IS NOT NULL
    DROP DATABASE InterviewL4_DataIntegrity;

CREATE DATABASE InterviewL4_DataIntegrity;
USE InterviewL4_DataIntegrity;

-- ============================================================================
-- TOPIC 13: DEDUPLICATION with ROW_NUMBER
-- Real-world: Remove duplicate customer records
-- ============================================================================

DROP TABLE IF EXISTS Customer_Data;

CREATE TABLE Customer_Data (
    customer_id INT PRIMARY KEY,
    email VARCHAR(100),
    phone VARCHAR(20),
    name VARCHAR(100),
    city VARCHAR(50),
    load_date DATE
);

INSERT INTO Customer_Data VALUES
(1, 'alice@example.com', '555-1001', 'Alice Johnson', 'New York', '2024-01-15'),
(2, 'bob@example.com', '555-1002', 'Bob Smith', 'London', '2024-01-15'),
(3, 'alice@example.com', '555-1001', 'Alice Johnson', 'New York', '2024-01-20'),  -- DUPLICATE
(4, 'charlie@example.com', '555-1003', 'Charlie Brown', 'Toronto', '2024-01-15'),
(5, 'bob@example.com', '555-1002', 'Bob Smith', 'London', '2024-01-25'),  -- DUPLICATE
(6, 'diana@example.com', '555-1004', 'Diana Prince', 'Sydney', '2024-02-01');

PRINT '=== TOPIC 13: DEDUPLICATION ===';
PRINT '';

-- ============================================================================
-- Q13.1: Identify duplicate records
-- ============================================================================
PRINT 'Q13.1: Find duplicate customer records (same email)';
PRINT 'Expected: email, count, customer_ids';
PRINT '';

PRINT 'ANSWER Q13.1 - Finding duplicates:';
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM Customer_Data
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

PRINT '';
PRINT 'Explanation: GROUP BY + HAVING COUNT(*) > 1 finds groups with 2+ rows.';
PRINT '';

-- ============================================================================
-- Q13.2: Mark duplicates using ROW_NUMBER
-- ============================================================================
PRINT 'Q13.2: Assign row numbers to duplicates (keep latest load_date as primary)';
PRINT '';

PRINT 'ANSWER Q13.2 - Deduplication strategy:';
WITH DeduplicatedData AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY load_date DESC) AS rn
    FROM Customer_Data
)
SELECT
    customer_id,
    email,
    phone,
    name,
    city,
    load_date,
    CASE WHEN rn = 1 THEN 'KEEP' ELSE 'DELETE' END AS action
FROM DeduplicatedData
ORDER BY email, rn;

PRINT '';
PRINT 'Explanation: ROW_NUMBER assigns 1 to latest (DESC), 2 to earlier, etc.';
PRINT 'Keep rows with rn = 1, delete rows with rn > 1.';
PRINT '';

-- ============================================================================
-- Q13.3: Create clean table (deduplicated)
-- ============================================================================
PRINT 'Q13.3: Create a deduplicated copy (removing duplicates)';
PRINT '';

PRINT 'ANSWER Q13.3 - Actual deduplication:';
DROP TABLE IF EXISTS Customer_Data_Clean;

CREATE TABLE Customer_Data_Clean AS
WITH Deduplicated AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY load_date DESC) AS rn
    FROM Customer_Data
)
SELECT
    customer_id,
    email,
    phone,
    name,
    city,
    load_date
FROM Deduplicated
WHERE rn = 1;

SELECT * FROM Customer_Data_Clean;

PRINT '';
PRINT 'Result: 4 deduplicated records (removed 2 duplicates)';
PRINT '';

-- ============================================================================
-- TOPIC 14: SELF-JOINS & HIERARCHIES
-- Real-world: Find employees earning more than their managers
-- ============================================================================

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    manager_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

INSERT INTO Employees VALUES
(1, 'CEO Alice', NULL, 250000.00),
(2, 'VP Sales Bob', 1, 180000.00),
(3, 'Sales Manager Charlie', 2, 120000.00),
(4, 'Sales Rep Diana', 3, 95000.00),
(5, 'Sales Rep Edward', 3, 115000.00),  -- Earns more than their manager Charlie (120k)? NO
(6, 'VP Engineering Frank', 1, 200000.00),
(7, 'Engineer Grace', 6, 150000.00),
(8, 'Engineer Henry', 6, 180000.00),  -- Earns more than their manager Frank (200k)? NO
(9, 'Special Consultant Iris', 1, 220000.00);  -- Earns more than CEO Alice? NO

PRINT '=== TOPIC 14: SELF-JOINS & HIERARCHIES ===';
PRINT '';

-- ============================================================================
-- Q14.1: Self-join - Employee and Manager info
-- ============================================================================
PRINT 'Q14.1: Show each employee with their manager''s name and salary';
PRINT 'Expected: emp_name, manager_name, emp_salary, mgr_salary';
PRINT '';

PRINT 'ANSWER Q14.1 - Basic self-join:';
SELECT
    e.emp_name,
    m.emp_name AS manager_name,
    e.salary AS emp_salary,
    m.salary AS mgr_salary
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

PRINT '';
PRINT 'Explanation: Self-join connects Employees table to itself.';
PRINT 'e = employee, m = manager (both from same table).';
PRINT '';

-- ============================================================================
-- Q14.2: Find employees earning more than their manager
-- ============================================================================
PRINT 'Q14.2: Find employees who earn MORE than their direct manager';
PRINT 'Expected: emp_name, emp_salary, manager_name, mgr_salary, difference';
PRINT '';

PRINT 'ANSWER Q14.2 - Salary comparison:';
SELECT
    e.emp_name,
    e.salary AS emp_salary,
    m.emp_name AS manager_name,
    m.salary AS mgr_salary,
    e.salary - m.salary AS salary_difference
FROM Employees e
INNER JOIN Employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary
ORDER BY salary_difference DESC;

PRINT '';
PRINT 'Explanation: INNER JOIN ensures only matched pairs.';
PRINT 'WHERE e.salary > m.salary finds the anomalies.';
PRINT '';

-- ============================================================================
-- Q14.3: Organizational hierarchy depth
-- ============================================================================
PRINT 'Q14.3: Show organizational chain (employee → manager → VP → CEO)';
PRINT '';

PRINT 'ANSWER Q14.3 - Multi-level join:';
SELECT
    e1.emp_name AS employee,
    e2.emp_name AS direct_manager,
    e3.emp_name AS managers_manager,
    e4.emp_name AS company_leadership
FROM Employees e1
LEFT JOIN Employees e2 ON e1.manager_id = e2.emp_id
LEFT JOIN Employees e3 ON e2.manager_id = e3.emp_id
LEFT JOIN Employees e4 ON e3.manager_id = e4.emp_id
WHERE e1.manager_id IS NOT NULL
ORDER BY e1.emp_id;

PRINT '';
PRINT 'Explanation: Chain multiple self-joins to show organizational hierarchy.';
PRINT 'This is limited to 3-4 levels. Use RECURSIVE CTE for deeper trees.';
PRINT '';

-- ============================================================================
-- TOPIC 15: PIVOTING DATA
-- Real-world: Convert monthly sales by product to wide format
-- ============================================================================

DROP TABLE IF EXISTS Monthly_Sales;

CREATE TABLE Monthly_Sales (
    sales_id INT PRIMARY KEY,
    product VARCHAR(50),
    month VARCHAR(20),
    revenue DECIMAL(12, 2)
);

INSERT INTO Monthly_Sales VALUES
(1, 'Laptop', 'January', 50000.00),
(2, 'Laptop', 'February', 55000.00),
(3, 'Laptop', 'March', 52000.00),
(4, 'Monitor', 'January', 15000.00),
(5, 'Monitor', 'February', 14000.00),
(6, 'Monitor', 'March', 16500.00),
(7, 'Keyboard', 'January', 12000.00),
(8, 'Keyboard', 'February', 10000.00),
(9, 'Keyboard', 'March', 11000.00);

PRINT '=== TOPIC 15: PIVOTING DATA ===';
PRINT '';

-- ============================================================================
-- Q15.1: PIVOT using CASE WHEN (no PIVOT syntax)
-- ============================================================================
PRINT 'Q15.1: Convert products (rows) to months (columns)';
PRINT 'Expected: Product | January | February | March';
PRINT '';

PRINT 'ANSWER Q15.1 - CASE WHEN pivot:';
SELECT
    product,
    SUM(CASE WHEN month = 'January' THEN revenue ELSE 0 END) AS January,
    SUM(CASE WHEN month = 'February' THEN revenue ELSE 0 END) AS February,
    SUM(CASE WHEN month = 'March' THEN revenue ELSE 0 END) AS March,
    SUM(revenue) AS Total
FROM Monthly_Sales
GROUP BY product
ORDER BY product;

PRINT '';
PRINT 'Explanation: SUM(CASE) is the most flexible pivoting approach.';
PRINT 'Works in all databases. Can add formatting, calculations, etc.';
PRINT '';

-- ============================================================================
-- Q15.2: Unpivoting (opposite of pivot)
-- ============================================================================
PRINT 'Q15.2: If months were columns, convert back to rows (UNPIVOT)';
PRINT '';

PRINT 'ANSWER Q15.2 - Unpivoting (UNION approach):';
SELECT product, 'January' AS month, 
    SUM(CASE WHEN month = 'January' THEN revenue ELSE 0 END) AS revenue
FROM Monthly_Sales
GROUP BY product
UNION ALL
SELECT product, 'February' AS month,
    SUM(CASE WHEN month = 'February' THEN revenue ELSE 0 END) AS revenue
FROM Monthly_Sales
GROUP BY product
UNION ALL
SELECT product, 'March' AS month,
    SUM(CASE WHEN month = 'March' THEN revenue ELSE 0 END) AS revenue
FROM Monthly_Sales
GROUP BY product
ORDER BY product, month;

PRINT '';
PRINT 'Explanation: UNPIVOT creates multiple rows from columns.';
PRINT '';

-- ============================================================================
-- Q15.3: Year-over-year comparison (more complex pivot)
-- ============================================================================
PRINT 'Q15.3: Compare same month across different years (if data existed)';
PRINT '';

PRINT 'Key insight for YoY analysis:';
PRINT 'CREATE pivot with: YEAR as rows, MONTH as columns';
PRINT 'Or: MONTH as rows, YEAR as columns';
PRINT '';

-- ============================================================================
-- TOPIC 16: RECURSIVE CTEs (Complex Data)
-- Real-world: Trace product through supply chain
-- ============================================================================

DROP TABLE IF EXISTS Supply_Chain;

CREATE TABLE Supply_Chain (
    level_id INT PRIMARY KEY,
    level_name VARCHAR(50),
    source_id INT,
    parent_level_id INT,
    product_count INT
);

INSERT INTO Supply_Chain VALUES
(1, 'Supplier', NULL, NULL, 1000),     -- Root: Supplier has 1000 units
(2, 'Factory', 1, 1, 950),             -- From Supplier 1
(3, 'Warehouse', 2, 2, 900),           -- From Factory 2
(4, 'Distribution', 3, 3, 850),        -- From Warehouse 3
(5, 'Retail', 4, 4, 800);              -- From Distribution 4

PRINT '=== TOPIC 16: RECURSIVE CTEs ===';
PRINT '';

-- ============================================================================
-- Q16.1: Recursive CTE - Trace supply chain
-- ============================================================================
PRINT 'Q16.1: Trace product movement from Supplier to Retail';
PRINT '';

PRINT 'ANSWER Q16.1 - Recursive CTE:';
WITH SupplyChainTrace AS (
    -- Anchor: Start from Supplier
    SELECT
        level_id,
        level_name,
        parent_level_id,
        product_count,
        0 AS depth,
        CAST(level_name AS VARCHAR(MAX)) AS chain
    FROM Supply_Chain
    WHERE parent_level_id IS NULL  -- Root node
    
    UNION ALL
    
    -- Recursive: Follow the chain
    SELECT
        s.level_id,
        s.level_name,
        s.parent_level_id,
        s.product_count,
        t.depth + 1,
        t.chain + ' → ' + s.level_name
    FROM Supply_Chain s
    INNER JOIN SupplyChainTrace t ON s.parent_level_id = t.level_id
)
SELECT
    level_id,
    level_name,
    product_count,
    depth,
    CAST(((product_count::FLOAT / 1000) * 100) AS DECIMAL(5,2)) AS pct_of_original,
    chain AS supply_route
FROM SupplyChainTrace
ORDER BY depth;

PRINT '';
PRINT 'Explanation: First SELECT is the anchor (starting point).';
PRINT 'UNION ALL joins with recursive part that follows relationships.';
PRINT 'Recursive CTE expands until no more parent_level_id matches.';
PRINT '';

PRINT '=== END OF LEVEL 4: DATA INTEGRITY & PERFORMANCE ===';
