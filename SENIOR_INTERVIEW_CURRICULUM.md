# 🎓 SENIOR SQL INTERVIEW CURRICULUM
## 20 Core Topics Across 5 Difficulty Levels

**Objective:** Evaluate ability to handle structured data, optimize for performance, and solve complex business problems using SQL.

---

# 📚 CURRICULUM STRUCTURE

## **LEVEL 1: Foundational Joins & Set Operations** (4 Topics)
*Foundation for all SQL work*

### Topic 1: INNER JOINs
- **Real-world use case:** E-commerce: Match customers with their orders
- **3 questions with answers** → See: `L1_T1_INNER_JOINS.sql`

### Topic 2: LEFT JOINs  
- **Real-world use case:** HR: Find employees who haven't submitted timesheets
- **3 questions with answers** → See: `L1_T2_LEFT_JOINS.sql`

### Topic 3: UNION vs UNION ALL
- **Real-world use case:** Finance: Combine transactions from multiple accounts
- **3 questions with answers** → See: `L1_T3_UNION.sql`

### Topic 4: INTERSECT & MINUS
- **Real-world use case:** Marketing: Find customers in both email AND SMS campaigns
- **3 questions with answers** → See: `L1_T4_INTERSECT_MINUS.sql`

---

## **LEVEL 2: Aggregation & Logical Filtering** (4 Topics)
*Business intelligence & reporting*

### Topic 5: GROUP BY & HAVING
- **Real-world use case:** Sales: Find departments with average salary > company average
- **3 questions with answers** → See: `L2_T5_GROUP_BY_HAVING.sql`

### Topic 6: CASE WHEN Statements
- **Real-world use case:** HR: Classify employees as "Junior", "Senior", "Lead"
- **3 questions with answers** → See: `L2_T6_CASE_WHEN.sql`

### Topic 7: COALESCE
- **Real-world use case:** Data quality: Handle missing commission fields
- **3 questions with answers** → See: `L2_T7_COALESCE.sql`

### Topic 8: WHERE vs HAVING
- **Real-world use case:** Analytics: Filter raw vs aggregate data differently
- **3 questions with answers** → See: `L2_T8_WHERE_HAVING.sql`

---

## **LEVEL 3: Advanced Analytical Patterns (Window Functions)** (4 Topics)
*Senior-level requirement - Most critical area*

### Topic 9: ROW_NUMBER(), RANK(), DENSE_RANK()
- **Real-world use case:** Sales: Rank products by revenue (with tie handling)
- **4 questions with answers** → See: `L3_T9_RANKING.sql`

### Topic 10: LAG() and LEAD()
- **Real-world use case:** Finance: Calculate month-over-month growth rates
- **4 questions with answers** → See: `L3_T10_LAG_LEAD.sql`

### Topic 11: Cumulative Sum (ROWS BETWEEN)
- **Real-world use case:** Logistics: Running total of shipments
- **4 questions with answers** → See: `L3_T11_CUMULATIVE_SUM.sql`

### Topic 12: Partitioning & Framing
- **Real-world use case:** Marketing: Calculate 7-day moving average of clicks
- **4 questions with answers** → See: `L3_T12_PARTITIONING.sql`

---

## **LEVEL 4: Data Integrity & Performance** (4 Topics)
*Production-grade real-world patterns*

### Topic 13: Deduplication with ROW_NUMBER()
- **Real-world use case:** Data warehouse: Remove duplicate customer records
- **3 questions with answers** → See: `L4_T13_DEDUPLICATION.sql`

### Topic 14: Self-Joins & Hierarchies
- **Real-world use case:** Org chart: Find employees earning more than their managers
- **4 questions with answers** → See: `L4_T14_SELF_JOINS.sql`

### Topic 15: Pivoting Data (CASE + GROUP BY)
- **Real-world use case:** Finance: Convert monthly sales by product to wide format
- **4 questions with answers** → See: `L4_T15_PIVOTING.sql`

### Topic 16: Complex CTEs & Recursion
- **Real-world use case:** Supply chain: Trace product from supplier → warehouse → customer
- **3 questions with answers** → See: `L4_T16_CTEs.sql`

---

## **LEVEL 5: Database Theory & Advanced Patterns** (4 Topics)
*Architectural thinking & debugging*

### Topic 17: Normalization & 1NF
- **Real-world use case:** Design student→courses relationship (avoid repeating groups)
- **3 questions with answers** → See: `L5_T17_NORMALIZATION.sql`

### Topic 18: Denormalization Trade-offs
- **Real-world use case:** Pre-computed aggregates for high-traffic dashboards
- **3 questions with answers** → See: `L5_T18_DENORMALIZATION.sql`

### Topic 19: Query Troubleshooting
- **Real-world use case:** "Blown-up joins" returning 10x expected rows
- **3 questions with answers** → See: `L5_T19_TROUBLESHOOTING.sql`

### Topic 20: Performance Optimization
- **Real-world use case:** Optimize 5-second query to 500ms using indexing strategy
- **3 questions with answers** → See: `L5_T20_OPTIMIZATION.sql`

---

# 🎯 HOW TO USE THIS CURRICULUM

**Approach:**
1. Read the scenario
2. Understand the dataset & schema
3. Try the question yourself
4. Compare with the provided answer
5. Study the explanation (why this approach works)

**Interview Mindset:**
- Explain NOT just the "what" but the "why"
- Discuss trade-offs (performance vs readability)
- Ask clarifying questions about business requirements
- Mention indexes, normalization, and constraints

---

# ⏱️ ESTIMATED TIME
- **Complete Curriculum:** 30-40 hours of deliberate practice
- **Per Topic:** 30-45 minutes
- **Interview Prep Timeline:** 2-4 weeks at 2 hours/day

---

# 📊 TOPICS AT A GLANCE

| Level | Topic | Difficulty | Real-World Relevance |
|-------|-------|-----------|----------------------|
| 1 | Joins | ⭐⭐ | E-commerce, CRM |
| 1 | Set Operations | ⭐⭐ | Multi-source integration |
| 1 | INTERSECT/MINUS | ⭐⭐⭐ | Data quality, audits |
| 2 | GROUP BY/HAVING | ⭐⭐ | All reporting |
| 2 | CASE WHEN | ⭐⭐ | ETL, transformation |
| 2 | COALESCE | ⭐⭐ | Data quality handling |
| 3 | Ranking | ⭐⭐⭐⭐ | Leaderboards, top-N |
| 3 | LAG/LEAD | ⭐⭐⭐⭐ | Time-series, growth analysis |
| 3 | Cumulative Sum | ⭐⭐⭐⭐ | Running totals, KPIs |
| 4 | Deduplication | ⭐⭐⭐ | Data quality, master data |
| 4 | Self-Joins | ⭐⭐⭐ | Hierarchies, organizational |
| 4 | Pivoting | ⭐⭐⭐ | BI reports, data transformation |
| 5 | Normalization | ⭐⭐⭐⭐⭐ | Schema design, hiring question |
| 5 | Query Debugging | ⭐⭐⭐⭐⭐ | Production support |

---

**Next Steps:**
1. Run the main setup script: `INTERVIEW_SETUP_COMPLETE.sql`
2. Work through Level 1 first
3. Progressively move to more advanced levels
4. For each topic, solve the questions before checking answers

**Interview Tips:**
- After presenting answer: "Would you like me to optimize this further?"
- Always discuss: Performance implications, edge cases (NULLs, duplicates)
- Ask: "What if the data size increased 100x?"
