-- ============================================================================
-- LEVEL 2: AGGREGATION & LOGICAL FILTERING
-- GROUP BY, HAVING, CASE WHEN, COALESCE
-- ============================================================================

IF DB_ID('InterviewL2_Aggregation') IS NOT NULL
    DROP DATABASE InterviewL2_Aggregation;

CREATE DATABASE InterviewL2_Aggregation;
USE InterviewL2_Aggregation;

-- ============================================================================
-- TOPIC 5: GROUP BY & HAVING - Sales Scenario
-- Real-world: Find departments with above-average salaries
-- ============================================================================

DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    manager_id INT,
    budget DECIMAL(15, 2)
);

INSERT INTO Departments VALUES
(10, 'Engineering', 101, 500000.00),
(20, 'Sales', 102, 300000.00),
(30, 'Finance', 103, 200000.00),
(40, 'Marketing', 104, 150000.00);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Employees VALUES
(101, 'Alice Cooper', 10, 120000.00, '2020-01-15'),
(102, 'Bob Dylan', 20, 95000.00, '2021-02-10'),
(103, 'Charlie Parker', 30, 110000.00, '2020-03-20'),
(104, 'Diana Ross', 40, 85000.00, '2021-04-01'),
(105, 'Edward Norton', 10, 105000.00, '2022-05-10'),
(106, 'Fiona Apple', 10, 95000.00, '2022-06-01'),
(107, 'George Martin', 20, 90000.00, '2021-07-15'),
(108, 'Hannah Montana', 20, 88000.00, '2023-08-20'),
(109, 'Iris West', 30, 102000.00, '2021-09-10'),
(110, 'Jack Sparrow', 30, 98000.00, '2022-10-01');

PRINT '=== TOPIC 5: GROUP BY & HAVING ===';
PRINT '';

-- ============================================================================
-- Q5.1: Basic GROUP BY - Average salary by department
-- ============================================================================
PRINT 'Q5.1: Find the average salary by department';
PRINT 'Expected: dept_name, avg_salary, employee_count';
PRINT '';

PRINT 'ANSWER Q5.1:';
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_salary DESC;

PRINT '';
PRINT 'Explanation: GROUP BY creates one row per department.';
PRINT 'Aggregate functions (AVG, COUNT, MIN, MAX) work on grouped data.';
PRINT '';

-- ============================================================================
-- Q5.2: WHERE vs HAVING - Filtering before and after aggregation
-- ============================================================================
PRINT 'Q5.2: Find departments with average salary > $100,000 AND more than 2 employees';
PRINT 'Expected: dept_name, avg_salary, employee_count';
PRINT '';

PRINT 'ANSWER Q5.2 - Correct use of WHERE vs HAVING:';
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS avg_salary
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.salary > 85000  -- ← Filters individual rows BEFORE aggregation
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.emp_id) > 2 AND AVG(e.salary) > 100000  -- ← Filters groups AFTER aggregation
ORDER BY avg_salary DESC;

PRINT '';
PRINT 'KEY INSIGHT: WHERE vs HAVING';
PRINT '  WHERE: Applied to individual rows BEFORE GROUP BY';
PRINT '  HAVING: Applied to groups AFTER GROUP BY (can use aggregates)';
PRINT '';

-- ============================================================================
-- Q5.3: Complex GROUP BY with multiple conditions
-- ============================================================================
PRINT 'Q5.3: Find the highest-paid employee in each department (with their salary).';
PRINT 'Expected: dept_name, emp_name, salary';
PRINT '';

PRINT 'ANSWER Q5.3 - Using window function alternative:';
WITH RankedEmployees AS (
    SELECT
        d.dept_name,
        e.emp_name,
        e.salary,
        ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rank_in_dept
    FROM Employees e
    INNER JOIN Departments d ON e.dept_id = d.dept_id
)
SELECT dept_name, emp_name, salary
FROM RankedEmployees
WHERE rank_in_dept = 1
ORDER BY salary DESC;

PRINT '';
PRINT 'Explanation: GROUP BY cannot easily fetch non-aggregate columns.';
PRINT 'Use window functions (PARTITION BY) instead for more control.';
PRINT '';

-- ============================================================================
-- TOPIC 6: CASE WHEN Statements - HR Classification
-- Real-world: Classify employees into salary bands
-- ============================================================================

PRINT '=== TOPIC 6: CASE WHEN STATEMENTS ===';
PRINT '';

-- ============================================================================
-- Q6.1: Simple CASE WHEN - Salary classification
-- ============================================================================
PRINT 'Q6.1: Classify employees into salary bands: Junior (<90k), Senior (90-110k), Lead (>110k)';
PRINT 'Expected: emp_name, salary, salary_band';
PRINT '';

PRINT 'ANSWER Q6.1:';
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary < 90000 THEN 'Junior'
        WHEN salary BETWEEN 90000 AND 110000 THEN 'Senior'
        ELSE 'Lead'
    END AS salary_band
FROM Employees
ORDER BY salary DESC;

PRINT '';
PRINT 'Explanation: CASE WHEN returns different values based on conditions.';
PRINT 'Always include ELSE to handle unexpected values.';
PRINT '';

-- ============================================================================
-- Q6.2: CASE WHEN with GROUP BY (aggregation category)
-- ============================================================================
PRINT 'Q6.2: Count how many employees are in each salary band per department';
PRINT 'Expected: dept_name, Junior_count, Senior_count, Lead_count';
PRINT '';

PRINT 'ANSWER Q6.2 - CASE WHEN for conditional aggregation:';
SELECT
    d.dept_name,
    COUNT(CASE WHEN e.salary < 90000 THEN 1 END) AS junior_count,
    COUNT(CASE WHEN e.salary BETWEEN 90000 AND 110000 THEN 1 END) AS senior_count,
    COUNT(CASE WHEN e.salary > 110000 THEN 1 END) AS lead_count
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_name;

PRINT '';
PRINT 'Explanation: CASE inside aggregate functions (COUNT, SUM) creates conditional sums.';
PRINT 'This is called "Pivot-like" functionality without PIVOT syntax.';
PRINT '';

-- ============================================================================
-- Q6.3: Bonus calculation with CASE WHEN
-- ============================================================================
PRINT 'Q6.3: Calculate bonus: 5% for salary <90k, 7% for 90-110k, 10% for >110k';
PRINT 'Expected: emp_name, salary, bonus_amount, total_compensation';
PRINT '';

PRINT 'ANSWER Q6.3:';
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary < 90000 THEN salary * 0.05
        WHEN salary BETWEEN 90000 AND 110000 THEN salary * 0.07
        ELSE salary * 0.10
    END AS bonus_amount,
    salary + CASE
        WHEN salary < 90000 THEN salary * 0.05
        WHEN salary BETWEEN 90000 AND 110000 THEN salary * 0.07
        ELSE salary * 0.10
    END AS total_compensation
FROM Employees
ORDER BY total_compensation DESC;

PRINT '';
PRINT 'Explanation: CASE WHEN can transform numerical data for calculations.';
PRINT 'Better than: CREATE new tables or use multiple queries.';
PRINT '';

-- ============================================================================
-- TOPIC 7: COALESCE - Handle NULL values
-- Real-world: Commission data with many NULLs
-- ============================================================================

DROP TABLE IF EXISTS Sales_History;

CREATE TABLE Sales_History (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    base_salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    bonus DECIMAL(10, 2),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Sales_History VALUES
(1, 101, 120000.00, NULL, 10000.00),
(2, 102, 95000.00, 5000.00, NULL),
(3, 103, 110000.00, NULL, NULL),
(4, 104, 85000.00, 3000.00, 2000.00),
(5, 105, 105000.00, NULL, 5000.00);

PRINT '=== TOPIC 7: COALESCE ===';
PRINT '';

-- ============================================================================
-- Q7.1: Using COALESCE to handle NULLs
-- ============================================================================
PRINT 'Q7.1: Calculate total compensation using COALESCE (NULL handling)';
PRINT 'Expected: emp_name, base_salary, commission, bonus, total_compensation';
PRINT '';

PRINT 'ANSWER Q7.1:';
SELECT
    e.emp_name,
    sh.base_salary,
    COALESCE(sh.commission, 0) AS commission,
    COALESCE(sh.bonus, 0) AS bonus,
    sh.base_salary + COALESCE(sh.commission, 0) + COALESCE(sh.bonus, 0) AS total_compensation
FROM Employees e
LEFT JOIN Sales_History sh ON e.emp_id = sh.emp_id
ORDER BY total_compensation DESC;

PRINT '';
PRINT 'Explanation: COALESCE(column, default_value) replaces NULL with a value.';
PRINT 'Alternative: ISNULL() or IFNULL() in different databases.';
PRINT '';

-- ============================================================================
-- Q7.2: COALESCE with multiple columns (first non-null)
-- ============================================================================
PRINT 'Q7.2: Show the highest value from commission, bonus, or 1000 (fallback)';
PRINT 'Expected: emp_name, highest_incentive';
PRINT '';

PRINT 'ANSWER Q7.2 - Using COALESCE logic:';
SELECT
    e.emp_name,
    CASE
        WHEN sh.commission IS NOT NULL THEN sh.commission
        WHEN sh.bonus IS NOT NULL THEN sh.bonus
        ELSE 1000.00
    END AS highest_incentive
FROM Employees e
LEFT JOIN Sales_History sh ON e.emp_id = sh.emp_id;

PRINT '';
PRINT 'Note: If using COALESCE for multiple values:';
PRINT 'SELECT COALESCE(commission, bonus, 1000) AS incentive FROM Sales_History;';
PRINT '';

-- ============================================================================
-- TOPIC 8: WHERE vs HAVING - Complete Comparison
-- Real-world: Sales filtering and comparison
-- ============================================================================

PRINT '=== TOPIC 8: WHERE vs HAVING (Complete Comparison) ===';
PRINT '';

-- ============================================================================
-- Q8.1: WHERE filters before GROUP BY
-- ============================================================================
PRINT 'Q8.1: Find total salary cost for each department (excluding employees hired after 2022)';
PRINT 'Expected: dept_name, total_salary, employee_count';
PRINT '';

PRINT 'ANSWER Q8.1 - WHERE performs row-level filtering:';
SELECT
    d.dept_name,
    SUM(e.salary) AS total_salary,
    COUNT(e.emp_id) AS employee_count
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id
WHERE YEAR(e.hire_date) <= 2022  -- ← WHERE filters rows BEFORE grouping
GROUP BY d.dept_id, d.dept_name;

PRINT '';
PRINT 'Explanation: WHERE clause is evaluated BEFORE GROUP BY.';
PRINT 'It filters individual rows, not groups.';
PRINT '';

-- ============================================================================
-- Q8.2: HAVING filters after GROUP BY
-- ============================================================================
PRINT 'Q8.2: Find departments with total salary cost > $400,000';
PRINT 'Expected: dept_name, total_salary, employee_count';
PRINT '';

PRINT 'ANSWER Q8.2 - HAVING performs group-level filtering:';
SELECT
    d.dept_name,
    SUM(e.salary) AS total_salary,
    COUNT(e.emp_id) AS employee_count
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING SUM(e.salary) > 400000;  -- ← HAVING filters groups AFTER aggregation

PRINT '';
PRINT 'Explanation: HAVING clause is evaluated AFTER GROUP BY.';
PRINT 'It filters aggregate results, not individual rows.';
PRINT '';

-- ============================================================================
-- Q8.3: WHERE + HAVING together
-- ============================================================================
PRINT 'Q8.3: Find departments with avg salary > $95k, excluding recent hires (post-2022), with 3+ employees';
PRINT '';

PRINT 'ANSWER Q8.3 - Using WHERE + HAVING together:';
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    MIN(e.hire_date) AS earliest_hire
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id
WHERE YEAR(e.hire_date) <= 2022  -- ← WHERE: filters rows first
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.emp_id) >= 3 AND AVG(e.salary) > 95000  -- ← HAVING: filters groups
ORDER BY avg_salary DESC;

PRINT '';
PRINT 'Execution order:';
PRINT '  1. FROM, JOIN: source data';
PRINT '  2. WHERE: filter rows (individual-level)';
PRINT '  3. GROUP BY: create groups';
PRINT '  4. Aggregate functions: COUNT, SUM, AVG, etc.';
PRINT '  5. HAVING: filter groups (aggregate-level)';
PRINT '  6. ORDER BY: sort results';
PRINT '';

PRINT '=== END OF LEVEL 2: AGGREGATION & LOGICAL FILTERING ===';
