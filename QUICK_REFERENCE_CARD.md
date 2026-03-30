# 🎯 SQL INTERVIEW QUICK REFERENCE CARD
## Print this and keep it on your desk during practice!

---

## 📊 QUERY EXECUTION ORDER (CRITICAL!)
```
1. FROM, JOIN clauses       ← Get base data
2. WHERE clause              ← Filter rows (BEFORE grouping)
3. GROUP BY clause           ← Create groups
4. Aggregate functions       ← COUNT, SUM, AVG, MIN, MAX
5. HAVING clause             ← Filter groups (AFTER aggregation)
6. Window functions          ← Run on ALL rows in partition
7. SELECT clause             ← Choose which columns
8. DISTINCT                  ← Remove duplicates
9. ORDER BY clause           ← Sort results
10. LIMIT/TOP                ← Limit number of rows
```

---

## 🔀 JOIN TYPES AT A GLANCE

```
INNER JOIN      → Only matching rows from both tables
LEFT JOIN       → All from left + matching from right (NULLs if no match)
RIGHT JOIN      → All from right + matching from left (NULLs if no match)
FULL OUTER      → All rows from both tables (NULLs where no match)
CROSS JOIN      → Cartesian product (avoid!)

SYNTAX:
SELECT ...
FROM table1 t1
INNER/LEFT/RIGHT/FULL JOIN table2 t2
ON t1.key = t2.key
WHERE ...
```

---

## 📈 WINDOW FUNCTIONS QUICK GUIDE

### **FRAME DEFINITION** (most confusing part)
```
UNCONSTRAINED:
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  → All rows in partition

RUNNING TOTAL:
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  → From first row to current row

MOVING AVERAGE:
  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  → Current row + 2 rows before

NEXT ROW:
  ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
  → Current row + next row
```

### **COMMON PATTERNS**
```
-- Running total
SUM(amount) OVER (PARTITION BY customer_id ORDER BY date 
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

-- Ranking
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)
RANK() OVER (PARTITION BY department ORDER BY salary DESC)
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC)

-- Previous/Next value
LAG(sales, 1, 0) OVER (ORDER BY month)      -- Previous value
LEAD(sales, 1, 0) OVER (ORDER BY month)     -- Next value

-- Percentage
(sales / SUM(sales) OVER (PARTITION BY category)) * 100

-- Moving average
AVG(value) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
```

---

## 🎯 RANKING FUNCTIONS - WHICH ONE?

```
ROW_NUMBER()
├─ Assignment: 1, 2, 3, 4, 5, ...
├─ Behavior with ties: Different number per row
├─ Use when: You need unique sequential number
└─ Example: "Get top 1 product per department"

RANK()
├─ Assignment: 1, 2, 2, 4, 5, ...
├─ Behavior with ties: Same rank for ties, gap after
├─ Use when: You want fair ranking with gaps
└─ Example: "Rank employees by salary (ties possible)"

DENSE_RANK()
├─ Assignment: 1, 2, 2, 3, 4, ...
├─ Behavior with ties: Same rank for ties, no gap
├─ Use when: You want continuous ranking
└─ Example: "Get top 3 selling products"
```

---

## 🧮 GROUP BY vs PARTITION BY

```
GROUP BY                           PARTITION BY
─────────────────────────────────────────────────────
Reduces rows                       Keeps all rows
Must use aggregates                Accesses all rows in group
Can't select non-aggregate cols    Can select non-aggregate cols
Returns 1 row per group            Returns 1 row per original row
FOR: Summarizing data              FOR: Analytical calculations

Example:                           Example:
SELECT customer, COUNT(*)          SELECT customer, order_id, amount,
FROM orders                        SUM(amount) OVER (PARTITION BY customer)
GROUP BY customer                  FROM orders
```

---

## WHERE vs HAVING

```
WHERE                              HAVING
─────────────────────────────────────────────────────
Row-level filtering                Group-level filtering
Applied BEFORE GROUP BY            Applied AFTER GROUP BY
Can't use aggregates               Can use aggregates
Used with individual rows          Used with grouped data

Syntax:
WHERE salary > 80000 (individual employees)
GROUP BY department
HAVING COUNT(*) >= 5 (groups with 5+ people)
```

---

## 🔄 SET OPERATIONS

```
UNION
├─ Combines rows from two queries
├─ Removes duplicates (slower)
└─ Use: When you want unique rows only
   SELECT col FROM table1
   UNION
   SELECT col FROM table2

UNION ALL
├─ Combines rows from two queries
├─ Keeps duplicates (faster)
└─ Use: When duplicates are okay (or expected)
   SELECT col FROM table1
   UNION ALL
   SELECT col FROM table2

INTERSECT
├─ Rows that exist in BOTH queries
└─ Use: "Find values in A AND B"
   SELECT col FROM table1
   INTERSECT
   SELECT col FROM table2

MINUS / EXCEPT
├─ Rows in first query but NOT in second
└─ Use: "Find values in A but NOT in B"
   SELECT col FROM table1
   MINUS/EXCEPT
   SELECT col FROM table2
```

---

## 🔧 NULL HANDLING

```
COALESCE(col1, col2, col3, default)
→ Returns first non-null value
→ Example: COALESCE(commission, bonus, 0)

CASE WHEN col IS NULL THEN value ELSE col END
→ Explicit NULL check
→ Use in: SELECT, WHERE, GROUP BY

Never forget:
NULL = NULL → FALSE (not true!)
NULL IS NULL → TRUE (correct way)
```

---

## 📋 CASE WHEN PATTERNS

### **Simple CASE**
```sql
CASE
  WHEN salary < 60000 THEN 'Junior'
  WHEN salary BETWEEN 60000 AND 100000 THEN 'Senior'
  ELSE 'Lead'
END AS experience_level

-- For aggregation:
COUNT(CASE WHEN salary > 80000 THEN 1 END) AS high_earners
SUM(CASE WHEN status='Completed' THEN amount ELSE 0 END) AS revenue
```

### **Pivoting with CASE**
```sql
SELECT
  product,
  SUM(CASE WHEN month='Jan' THEN amount ELSE 0 END) AS Jan,
  SUM(CASE WHEN month='Feb' THEN amount ELSE 0 END) AS Feb,
  SUM(CASE WHEN month='Mar' THEN amount ELSE 0 END) AS Mar
FROM sales
GROUP BY product
```

---

## 🪢 SELF-JOINS

```
Employee and Manager relationship:
SELECT
  e.emp_name AS employee,
  m.emp_name AS manager,
  e.salary,
  m.salary
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary  -- Find people earning more than manager!
```

---

## 🗑️ DEDUPLICATION

```
-- Step 1: Mark duplicates with ROW_NUMBER
WITH Dedup AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
  FROM customers
)
-- Step 2: Keep only first (rn = 1)
SELECT * FROM Dedup WHERE rn = 1
```

---

## 🚀 PERFORMANCE TIPS

### **SARGable (can use index)**
```
✓ WHERE column = value
✓ WHERE column > value
✓ WHERE column BETWEEN x AND y
✓ WHERE column IN (a, b, c)

✗ WHERE YEAR(column) = 2024  (function on column!)
✗ WHERE column + 1 = value   (calculation on column!)
✗ WHERE CAST(column AS INT) = 5  (type conversion!)
```

### **Index Strategy**
```
Single column index:
CREATE INDEX idx_customer_id ON orders(customer_id)

Composite index (for joins):
CREATE INDEX idx_order ON orders(customer_id, order_date)

Covering index (includes data):
CREATE INDEX idx_performance ON orders(customer_id)
  INCLUDE (amount, status)
```

---

## 📝 CTE SYNTAX

```sql
WITH cte_name AS (
  SELECT ...  -- Define the CTE
),
another_cte AS (
  SELECT ...
)
SELECT ...    -- Use the CTEs
FROM cte_name
```

---

## 🔍 COMMON INTERVIEW MISTAKES

| Mistake | Fix |
|---------|-----|
| Forget about NULLs | Always use `IS NULL` or `COALESCE` |
| Cartesian product | Verify row count after joins |
| GROUP BY with non-aggregates | Either aggregate or add to GROUP BY |
| Invalid logic in WHERE | Remember: rules before filtering rows |
| Forget DISTINCT | COUNT(DISTINCT col) when needed |
| No indexes | Think about indexing at scale |
| SARGable queries | Avoid functions on indexed columns |

---

## ⏰ TIME MANAGEMENT IN INTERVIEW

```
20-minute question breakdown:
- 2 min: Ask clarifying questions about data
- 3 min: Draw schema / understand relationships
- 5 min: Write initial query (simple version)
- 7 min: Test mentally with sample data
- 2 min: Refine/optimize
- 1 min: Explain your approach

If stuck: "Let me start simple..." → build up complexity
```

---

## 🎯 RED FLAGS (Interviewer noticed!)

✗ Writing query without understanding data first
✗ Assuming column names (should ask!)
✗ Ignoring NULL values
✗ Not testing logic with sample rows
✗ "I don't know how to do this" vs "Let me work through this..."
✗ Can't explain WHY your query works

✓ Ask clarifying questions
✓ Explain approach before coding
✓ Handle edge cases
✓ Discuss trade-offs
✓ Test mentally with small data

---

## 🏆 FINAL CHECKLIST BEFORE INTERVIEW

- [ ] Can write all 5 JOIN types from memory
- [ ] Understand PARTITION BY deeply (not just syntax)
- [ ] Know ROW_NUMBER, RANK, DENSE_RANK differences
- [ ] Can write LAG/LEAD from memory
- [ ] Understand WHERE vs HAVING execution
- [ ] Know when to use GROUP BY vs PARTITION BY
- [ ] Can spot a cartesian product (blown-up join)
- [ ] Handle NULLs correctly
- [ ] Know SARGable queries
- [ ] Can design normalized schema
- [ ] Understand denormalization trade-offs

**Ready if: 9/10+ boxes checked ✓**

---

## 💡 PRO TIPS

**Before writing SQL:**
1. "Let me make sure I understand the schema..."
2. "Are there NULLs I should handle?"
3. "What's the expected volume of data?"
4. "Are there any performance considerations?"

**After writing SQL:**
1. "Let me trace through this with sample data..."
2. "What about edge cases like...?"
3. "Would indexes help here?"
4. "Is there a more efficient approach?"

---

**Print this card. Keep it near your desk. Reference it during practice. 💪**

