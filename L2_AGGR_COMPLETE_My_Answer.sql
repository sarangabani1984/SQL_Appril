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




-- Q5.3: Find the highest-paid employee in each department (with their name and salary)

with cte as (
select 
d.dept_name,
e.emp_name,
e.salary, RANK() OVER (PARTITION BY d.dept_name ORDER BY e.salary DESC) as salary_rank
from Departments d
join Employees e
on d.dept_id = e.dept_id)

SELECT * from cte WHERE salary_rank = 1 




