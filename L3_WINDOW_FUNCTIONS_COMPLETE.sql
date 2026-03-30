-- ============================================================================
-- LEVEL 3: ADVANCED ANALYTICAL PATTERNS - WINDOW FUNCTIONS
-- Most Critical for Senior Role - ROW_NUMBER, RANK, LAG, LEAD, Cumulative Sum
-- ============================================================================

IF DB_ID('InterviewL3_WindowFunctions') IS NOT NULL
    DROP DATABASE InterviewL3_WindowFunctions;

CREATE DATABASE InterviewL3_WindowFunctions;
USE InterviewL3_WindowFunctions;

-- ============================================================================
-- TOPIC 9: RANKING Functions - ROW_NUMBER, RANK, DENSE_RANK
-- Real-world: E-commerce product leaderboard with tie handling
-- ============================================================================

DROP TABLE IF EXISTS Product_Sales;

CREATE TABLE Product_Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    month VARCHAR(10),
    revenue DECIMAL(12, 2),
    units_sold INT
);

INSERT INTO Product_Sales VALUES
(1, 101, 'Laptop Pro', 'January', 50000.00, 25),
(2, 102, 'Monitor', 'January', 15000.00, 30),
(3, 103, 'Keyboard', 'January', 12000.00, 150),
(4, 104, 'Mouse', 'January', 5000.00, 250),
(5, 101, 'Laptop Pro', 'February', 55000.00, 27),
(6, 102, 'Monitor', 'February', 14000.00, 28),
(7, 105, 'Desk', 'February', 14000.00, 14),  -- Tied revenue with Monitor
(8, 103, 'Keyboard', 'February', 10000.00, 100),
(9, 101, 'Laptop Pro', 'March', 52000.00, 26),
(10, 104, 'Mouse', 'March', 6500.00, 325);

PRINT '=== TOPIC 9: RANKING FUNCTIONS ===';
PRINT 'Key Insight: ROW_NUMBER, RANK, DENSE_RANK handle ties differently!';
PRINT '';

-- ============================================================================
-- Q9.1: ROW_NUMBER - Simple sequential ranking (ignores ties)
-- ============================================================================
PRINT 'Q9.1: Rank products by revenue each month using ROW_NUMBER';
PRINT 'Expected: month, rank, product_name, revenue';
PRINT '';

PRINT 'ANSWER Q9.1 - ROW_NUMBER (sequential, no tie gaps):';
SELECT
    month,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY revenue DESC) AS rank,
    product_name,
    revenue
FROM Product_Sales
ORDER BY month, rank;

PRINT '';
PRINT 'Explanation: ROW_NUMBER assigns sequential numbers.';
PRINT 'If two products tie at $14k, one gets rank 2, other gets rank 3.';
PRINT '';

-- ============================================================================
-- Q9.2: RANK - Handling ties (gaps in rank)
-- ============================================================================
PRINT 'Q9.2: Rank products by revenue handling ties properly';
PRINT 'Expected: month, rank, product_name, revenue';
PRINT '';

PRINT 'ANSWER Q9.2 - RANK (creates gaps with ties):';
SELECT
    month,
    RANK() OVER (PARTITION BY month ORDER BY revenue DESC) AS rank,
    product_name,
    revenue
FROM Product_Sales
ORDER BY month, rank;

PRINT '';
PRINT 'Explanation: RANK gives same rank to tied values.';
PRINT 'February: Monitor and Desk both $14k both get rank 2.';
PRINT 'Next rank is 4 (skips 3). Useful for "top N per group".';
PRINT '';

-- ============================================================================
-- Q9.3: DENSE_RANK - Handling ties (no gaps)
-- ============================================================================
PRINT 'Q9.3: Rank products by revenue without gaps (DENSE_RANK)';
PRINT 'Expected: month, rank, product_name, revenue';
PRINT '';

PRINT 'ANSWER Q9.3 - DENSE_RANK (no gaps with ties):';
SELECT
    month,
    DENSE_RANK() OVER (PARTITION BY month ORDER BY revenue DESC) AS rank,
    product_name,
    revenue
FROM Product_Sales
ORDER BY month, rank;

PRINT '';
PRINT 'Explanation: DENSE_RANK avoids gaps. Tied products get same rank,';
PRINT 'but next rank is still sequential (no skipping).';
PRINT 'February: Both $14k products get rank 2, next is rank 3.';
PRINT '';

-- ============================================================================
-- Q9.4: Practical Use - Find Top 2 products per month
-- ============================================================================
PRINT 'Q9.4: Find top 2 products by revenue for each month';
PRINT 'Expected: month, product_name, revenue, rank';
PRINT '';

PRINT 'ANSWER Q9.4 - Using window function + CTE:';
WITH RankedProducts AS (
    SELECT
        month,
        product_name,
        revenue,
        RANK() OVER (PARTITION BY month ORDER BY revenue DESC) AS rank
    FROM Product_Sales
)
SELECT month, product_name, revenue, rank
FROM RankedProducts
WHERE rank <= 2
ORDER BY month, rank;

PRINT '';
PRINT 'Explanation: PARTITION BY creates separate rankings per month.';
PRINT 'ORDER BY determines ranking order (highest revenue first).';
PRINT 'WHERE rank <= 2 filters to top 2 products.';
PRINT '';

-- ============================================================================
-- TOPIC 10: LAG & LEAD - Time-Series Analysis
-- Real-world: Calculate month-over-month growth
-- ============================================================================

DROP TABLE IF EXISTS Monthly_Revenue;

CREATE TABLE Monthly_Revenue (
    month VARCHAR(10),
    product_id INT,
    product_name VARCHAR(100),
    revenue DECIMAL(12, 2)
);

INSERT INTO Monthly_Revenue VALUES
('January', 101, 'Laptop', 50000.00),
('January', 102, 'Monitor', 15000.00),
('February', 101, 'Laptop', 55000.00),
('February', 102, 'Monitor', 14000.00),
('March', 101, 'Laptop', 52000.00),
('March', 102, 'Monitor', 16500.00),
('April', 101, 'Laptop', 58000.00),
('April', 102, 'Monitor', 18000.00);

PRINT '=== TOPIC 10: LAG & LEAD - TIME-SERIES ANALYSIS ===';
PRINT '';

-- ============================================================================
-- Q10.1: LAG - Get previous month''s value
-- ============================================================================
PRINT 'Q10.1: Show current and previous month revenue for Laptop';
PRINT 'Expected: month, current_revenue, previous_revenue, growth_amount';
PRINT '';

PRINT 'ANSWER Q10.1 - LAG() to get previous value:';
SELECT
    month,
    revenue AS current_revenue,
    LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) AS previous_revenue,
    revenue - LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) AS growth_amount
FROM Monthly_Revenue
WHERE product_name = 'Laptop'
ORDER BY month;

PRINT '';
PRINT 'Explanation: LAG() accesses the previous row''s value.';
PRINT 'Syntax: LAG(column, offset, default) OVER (PARTITION BY ... ORDER BY ...)';
PRINT 'January has NULL (no previous month).';
PRINT '';

-- ============================================================================
-- Q10.2: LEAD - Get next month''s value
-- ============================================================================
PRINT 'Q10.2: Show current and next month revenue for Monitor';
PRINT 'Expected: month, current_revenue, next_revenue';
PRINT '';

PRINT 'ANSWER Q10.2 - LEAD() to get next value:';
SELECT
    month,
    revenue AS current_revenue,
    LEAD(revenue) OVER (PARTITION BY product_id ORDER BY month) AS next_revenue
FROM Monthly_Revenue
WHERE product_name = 'Monitor'
ORDER BY month;

PRINT '';
PRINT 'Explanation: LEAD() accesses the next row''s value.';
PRINT 'April has NULL (no next month).';
PRINT '';

-- ============================================================================
-- Q10.3: Month-over-Month Growth Rate
-- ============================================================================
PRINT 'Q10.3: Calculate Month-over-Month growth rate for all products (%)';
PRINT 'Expected: product_name, month, revenue, prev_revenue, growth_pct';
PRINT '';

PRINT 'ANSWER Q10.3 - MoM growth calculation:';
SELECT
    product_name,
    month,
    revenue,
    LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) AS prev_revenue,
    ROUND(
        ((revenue - LAG(revenue) OVER (PARTITION BY product_id ORDER BY month)) /
         LAG(revenue) OVER (PARTITION BY product_id ORDER BY month)) * 100,
        2
    ) AS growth_pct
FROM Monthly_Revenue
ORDER BY product_name, month;

PRINT '';
PRINT 'Explanation: (Current - Previous) / Previous * 100 = Growth Rate %';
PRINT 'First month shows NULL (no previous data).';
PRINT '';

-- ============================================================================
-- Q10.4: Detecting Trends (consecutive increases/decreases)
-- ============================================================================
PRINT 'Q10.4: Identify products with 2+ consecutive months of growth';
PRINT '';

PRINT 'ANSWER Q10.4 - Detecting trends:';
WITH GrowthData AS (
    SELECT
        product_name,
        month,
        revenue,
        LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) AS prev_revenue,
        CASE 
            WHEN revenue > LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) THEN 1
            ELSE 0
        END AS is_growth
    FROM Monthly_Revenue
)
SELECT
    product_name,
    month,
    revenue,
    prev_revenue,
    is_growth
FROM GrowthData
ORDER BY product_name, month;

PRINT '';
PRINT 'Explanation: Use CASE to flag growth months (1 if growth, 0 if not).';
PRINT 'Can extend with GROUP_CONCAT to find consecutive growth periods.';
PRINT '';

-- ============================================================================
-- TOPIC 11: CUMULATIVE SUM - ROWS BETWEEN
-- Real-world: Running total of shipments
-- ============================================================================

DROP TABLE IF EXISTS Daily_Shipments;

CREATE TABLE Daily_Shipments (
    ship_date DATE,
    product_id INT,
    product_name VARCHAR(100),
    units_shipped INT
);

INSERT INTO Daily_Shipments VALUES
('2024-03-01', 101, 'Laptop', 5),
('2024-03-02', 101, 'Laptop', 8),
('2024-03-03', 101, 'Laptop', 6),
('2024-03-04', 101, 'Laptop', 10),
('2024-03-05', 101, 'Laptop', 7),
('2024-03-01', 102, 'Monitor', 20),
('2024-03-02', 102, 'Monitor', 15),
('2024-03-03', 102, 'Monitor', 25),
('2024-03-04', 102, 'Monitor', 18);

PRINT '=== TOPIC 11: CUMULATIVE SUM - ROWS BETWEEN ===';
PRINT '';

-- ============================================================================
-- Q11.1: Running total (cumulative sum)
-- ============================================================================
PRINT 'Q11.1: Calculate running total of units shipped for Laptop';
PRINT 'Expected: ship_date, units_shipped, running_total';
PRINT '';

PRINT 'ANSWER Q11.1 - Cumulative sum:';
SELECT
    ship_date,
    product_name,
    units_shipped,
    SUM(units_shipped) OVER (
        PARTITION BY product_id 
        ORDER BY ship_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Daily_Shipments
WHERE product_name = 'Laptop'
ORDER BY ship_date;

PRINT '';
PRINT 'Explanation: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW';
PRINT '  = Sum from first row up to current row.';
PRINT '';

-- ============================================================================
-- Q11.2: Moving average (7-day window)
-- ============================================================================
PRINT 'Q11.2: Calculate 3-day moving average for Monitor';
PRINT 'Expected: ship_date, units_shipped, avg_3day';
PRINT '';

PRINT 'ANSWER Q11.2 - Moving average:';
SELECT
    ship_date,
    product_name,
    units_shipped,
    ROUND(
        AVG(units_shipped) OVER (
            PARTITION BY product_id
            ORDER BY ship_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS avg_3day
FROM Daily_Shipments
WHERE product_name = 'Monitor'
ORDER BY ship_date;

PRINT '';
PRINT 'Explanation: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW';
PRINT '  = Average of current row + 2 previous rows (3-day window).';
PRINT 'Use case: Smooth out daily noise to see trends.';
PRINT '';

-- ============================================================================
-- Q11.3: Comparison: Running total vs Daily
-- ============================================================================
PRINT 'Q11.3: All products with daily, cumulative, and running avg';
PRINT '';

PRINT 'ANSWER Q11.3 - Complete running metrics:';
SELECT
    ship_date,
    product_name,
    units_shipped,
    SUM(units_shipped) OVER (
        PARTITION BY product_id ORDER BY ship_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_total,
    AVG(units_shipped) OVER (
        PARTITION BY product_id ORDER BY ship_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS avg_3day
FROM Daily_Shipments
ORDER BY product_id, ship_date;

PRINT '';

-- ============================================================================
-- TOPIC 12: PARTITION BY & FRAMING - Complex Window Functions
-- Real-world: Ranking within groups with multiple calculations
-- ============================================================================

DROP TABLE IF EXISTS Employee_Performance;

CREATE TABLE Employee_Performance (
    emp_id INT,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    month VARCHAR(10),
    sales DECIMAL(10, 2),
    target DECIMAL(10, 2)
);

INSERT INTO Employee_Performance VALUES
(101, 'Alice', 'Sales', 'January', 50000, 45000),
(101, 'Alice', 'Sales', 'February', 55000, 45000),
(101, 'Alice', 'Sales', 'March', 52000, 45000),
(102, 'Bob', 'Sales', 'January', 40000, 45000),
(102, 'Bob', 'Sales', 'February', 42000, 45000),
(102, 'Bob', 'Sales', 'March', 48000, 45000),
(201, 'Charlie', 'Engineering', 'January', 0, 0),
(201, 'Charlie', 'Engineering', 'February', 0, 0),
(201, 'Charlie', 'Engineering', 'March', 0, 0);

PRINT '=== TOPIC 12: PARTITION BY & FRAMING ===';
PRINT '';

-- ============================================================================
-- Q12.1: Complex partitioning with multiple aggregates
-- ============================================================================
PRINT 'Q12.1: Show employee performance with department rank and running avg';
PRINT 'Expected: emp_name, department, month, sales, dept_rank, running_avg';
PRINT '';

PRINT 'ANSWER Q12.1:';
SELECT
    emp_name,
    department,
    month,
    sales,
    RANK() OVER (PARTITION BY department, month ORDER BY sales DESC) AS dept_rank,
    AVG(sales) OVER (
        PARTITION BY emp_id ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS running_avg_sales
FROM Employee_Performance
ORDER BY department, month, dept_rank;

PRINT '';
PRINT 'Explanation: Multiple PARTITION BY creates nested groupings.';
PRINT 'Each window function can have its own PARTITION BY and ORDER BY.';
PRINT '';

-- ============================================================================
-- Q12.2: Percentage of department total
-- ============================================================================
PRINT 'Q12.2: Show each employee sales as % of department total';
PRINT 'Expected: emp_name, month, sales, dept_total, pct_of_dept';
PRINT '';

PRINT 'ANSWER Q12.2 - Ratio calculation:';
SELECT
    emp_name,
    month,
    sales,
    SUM(sales) OVER (PARTITION BY department, month) AS dept_total,
    ROUND(
        (sales / SUM(sales) OVER (PARTITION BY department, month)) * 100,
        2
    ) AS pct_of_dept
FROM Employee_Performance
WHERE sales > 0
ORDER BY month, emp_name;

PRINT '';
PRINT 'Explanation: Use a window function to calculate dept total,';
PRINT 'then divide individual sales by that total.';
PRINT '';

PRINT '=== END OF LEVEL 3: WINDOW FUNCTIONS ===';
PRINT 'KEY TAKEAWAY: Window functions are CRUCIAL for senior roles!';
PRINT 'Master PARTITION BY, ORDER BY, ROWS BETWEEN for any analytical task.';
