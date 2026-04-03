SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

SELECT 
d.dept_name,
avg(e.salary) as avg_salary,
COUNT(e.emp_id) as employee_count
FROM Departments d
LEFT JOIN Employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC;


-- Q5.2: Find departments with average salary > $100,000 AND more than 2 employees

SELECT 
d.dept_name,
avg(e.salary) as avg_salary,
COUNT(e.emp_id) as employee_count
FROM Departments d
LEFT JOIN Employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING avg(e.salary) > 100000 AND COUNT(e.emp_id) > 2
ORDER BY avg_salary DESC;




