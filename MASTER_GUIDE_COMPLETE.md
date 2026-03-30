# 🎓 SENIOR SQL INTERVIEW CURRICULUM - COMPLETE MASTER GUIDE

## 📋 OVERVIEW
This comprehensive curriculum covers **20 Core SQL Topics** across **5 Difficulty Levels** designed to prepare you for senior-level data engineering interviews.

---

## 📊 CURRICULUM AT A GLANCE

| Level | Difficulty | Topics | Questions | Focus |
|-------|-----------|--------|-----------|-------|
| **1** | ⭐⭐ | Joins, Set Operations | 12 | Foundation |
| **2** | ⭐⭐⭐ | Aggregation, CASE, COALESCE | 12 | Business Logic |
| **3** | ⭐⭐⭐⭐ | Window Functions, LAG/LEAD | 16 | **MOST CRITICAL** |
| **4** | ⭐⭐⭐⭐ | Dedup, Self-Joins, Pivoting | 12 | Production Patterns |
| **5** | ⭐⭐⭐⭐⭐ | Normalization, Optimization | 12 | Architecture & Theory |

**Total: 60+ Questions with Complete Answers**

---

## 📁 FILE STRUCTURE & HOW TO USE

### **Setup & Documentation**
```
SENIOR_INTERVIEW_CURRICULUM.md          ← Curriculum overview (this document)
```

### **Level 1: Foundational Joins & Set Operations**
```
L1_JOINS_COMPLETE.sql
├── Creates: InterviewL1_Joins database
├── Topics:
│   ├── Topic 1: INNER JOINs (E-commerce) - 3 questions
│   ├── Topic 2: LEFT JOINs (HR) - 3 questions
│   ├── Topic 3: UNION vs UNION ALL (Finance) - 3 questions
│   └── Topic 4: INTERSECT & MINUS (Marketing) - 3 questions
└── Total: 12 Questions (Full answers included)
```

**Key Concepts:**
- Understanding different JOIN types and their use cases
- Set operations and their performance implications
- WHERE clause with joins for complex filtering

**Practice Goal:** Master joins before moving to advanced topics

---

### **Level 2: Aggregation & Logical Filtering**
```
L2_AGGREGATION_COMPLETE.sql
├── Creates: InterviewL2_Aggregation database
├── Topics:
│   ├── Topic 5: GROUP BY & HAVING (Sales) - 3 questions
│   ├── Topic 6: CASE WHEN (HR Classification) - 3 questions
│   ├── Topic 7: COALESCE (NULL Handling) - 2 questions
│   └── Topic 8: WHERE vs HAVING (Complete Comparison) - 3 questions
└── Total: 12 Questions (Full answers included)
```

**Key Concepts:**
- Difference between WHERE (row-level) and HAVING (aggregate-level)
- Conditional aggregation using CASE WHEN
- NULL value handling strategies

**Practice Goal:** Understand how aggregation changes query logic

---

### **Level 3: Advanced Analytical Patterns (Window Functions)**
```
L3_WINDOW_FUNCTIONS_COMPLETE.sql
├── Creates: InterviewL3_WindowFunctions database
├── Topics:
│   ├── Topic 9: ROW_NUMBER, RANK, DENSE_RANK (Leaderboards) - 4 questions
│   ├── Topic 10: LAG & LEAD (Time-Series, Growth) - 4 questions
│   ├── Topic 11: Cumulative Sum & Moving Average - 3 questions
│   └── Topic 12: PARTITION BY & Complex Framing - 2 questions
└── Total: 16 Questions (Full answers included)
```

**Key Concepts:**
- Ranking functions and tie handling
- Time-series analysis with LAG/LEAD
- Running totals and moving averages
- PARTITION BY vs GROUP BY (CRITICAL difference)

**Practice Goal:** Master window functions (REQUIRED for senior role)

---

### **Level 4: Data Integrity & Performance**
```
L4_DATA_INTEGRITY_COMPLETE.sql
├── Creates: InterviewL4_DataIntegrity database
├── Topics:
│   ├── Topic 13: Deduplication with ROW_NUMBER (CDW) - 3 questions
│   ├── Topic 14: Self-Joins & Hierarchies (Org Chart) - 3 questions
│   ├── Topic 15: Pivoting Data (CASE-based PIVOT) - 3 questions
│   └── Topic 16: Recursive CTEs (Deep Hierarchies) - 3 questions
└── Total: 12 Questions (Full answers included)
```

**Key Concepts:**
- Production deduplication patterns
- Self-joins for hierarchical data
- Pivoting without PIVOT syntax (more flexible)
- Recursive CTEs for tree structures

**Practice Goal:** Handle real-world data quality issues

---

### **Level 5: Database Theory & Advanced Patterns**
```
L5_DATABASE_THEORY_COMPLETE.sql
├── Creates: InterviewL5_Theory database
├── Topics:
│   ├── Topic 17: Normalization & 1NF Design (Students→Courses)
│   ├── Topic 18: Denormalization Trade-offs (Dashboard Optimization)
│   ├── Topic 19: Query Troubleshooting (Blown-up Joins)
│   └── Topic 20: Performance Optimization (5sec→500ms)
└── Total: 12 Questions (Full answers included)
```

**Key Concepts:**
- When and how to normalize (1NF, 2NF, 3NF)
- When to denormalize for performance
- Diagnosing and fixing cartesian products
- SARGable queries and index usage

**Practice Goal:** Think like an architect, not just a query writer

---

## 🚀 HOW TO USE THIS CURRICULUM

### **Step 1: Setup Phase (15 minutes)**
```sql
-- Run ALL scripts in order:
1. L1_JOINS_COMPLETE.sql
2. L2_AGGREGATION_COMPLETE.sql
3. L3_WINDOW_FUNCTIONS_COMPLETE.sql
4. L4_DATA_INTEGRITY_COMPLETE.sql
5. L5_DATABASE_THEORY_COMPLETE.sql

-- This creates 5 sample databases with realistic data
-- Ready to query immediately
```

### **Step 2: Self-Study Phase (1-2 weeks)**
```
For each Level (1-5):
  a) READ the database schema and understand sample data
  b) READ the business scenario/use case
  c) TRY to write the query yourself (DON'T peek at answer!)
  d) COMPARE your answer with the provided solution
  e) UNDERSTAND the explanation (why this approach)
  f) THINK about edge cases ("What if data was 1M rows?")
```

### **Step 3: Interview Prep Phase (1 week)**
```
- Pick random questions from each level
- Set a timer (15-20 minutes per question)
- Write complete answer without referring to solutions
- Practice explaining your approach verbally
- Discuss trade-offs and alternative approaches
```

### **Step 4: Mock Interview Phase (Final 3 days)**
```
- Ask a friend/colleague to interview you
- They ask questions, you answer without solutions visible
- Practice thinking out loud ("I need to understand the data first...")
- Discuss performance, edge cases, and optimization
```

---

## 🎯 INTERVIEW STRATEGY BY QUESTION TYPE

### **Type A: Foundational Questions (Levels 1-2)**
**Interviewer expects:** Speed + Accuracy
- Show you can write correct queries quickly
- Mention any assumptions or edge cases
- Ask: "Should I handle NULL values?"

### **Type B: Analytical Questions (Level 3)**
**Interviewer expects:** Deep understanding of window functions
- Explain PARTITION BY vs GROUP BY
- Discuss different ranking functions
- Show knowledge of execution order

### **Type C: Production Questions (Level 4)**
**Interviewer expects:** Real-world experience
- Mention deduplication patterns you've used
- Discuss handling data quality issues
- Show understanding of CTEs and recursion

### **Type D: Architecture Questions (Level 5)**
**Interviewer expects:** Thinking beyond the query
- Discuss normalization vs denormalization trade-offs
- Explain how to debug blown-up joins
- Propose indexing strategies

---

## ⏱️ RECOMMENDED TIMELINE

### **Week 1: Foundation**
- Day 1-2: Level 1 (Joins & Set Operations)
- Day 3-4: Level 2 (Aggregation)
- Day 5-7: Practice all Level 1-2 questions

### **Week 2: Advanced Patterns (CRITICAL)**
- Day 8-10: Level 3 (Window Functions)
- Day 11-14: Deep dive on window functions, practice extensively

### **Week 3: Production Patterns**
- Day 15-17: Level 4 (Data Integrity & Performance)
- Day 18-20: Practice Level 4 questions

### **Week 4: Theory & Optimization**
- Day 21-23: Level 5 (Database Theory)
- Day 24-28: Mock interviews, random question drilling

---

## 📌 TOP 20 CONCEPTS YOU MUST MASTER

### **MUST-KNOW (Non-negotiable)**
- ✅ INNER, LEFT, RIGHT, FULL OUTER JOINs
- ✅ GROUP BY vs PARTITION BY (critical distinction!)
- ✅ WHERE vs HAVING
- ✅ ROW_NUMBER, RANK, DENSE_RANK (and when to use each)
- ✅ LAG/LEAD for time-series analysis
- ✅ Running totals with ROWS BETWEEN
- ✅ Deduplication with ROW_NUMBER
- ✅ Self-joins for hierarchies
- ✅ CASE WHEN for conditional logic
- ✅ Handling NULLs (COALESCE, CASE)

### **SHOULD-KNOW (Strong advantage)**
- ✅ Recursive CTEs for deep hierarchies
- ✅ Pivoting data without PIVOT syntax
- ✅ UNION vs UNION ALL (performance implications)
- ✅ Detecting and fixing blown-up joins
- ✅ SARGable queries (index-friendly)
- ✅ Normalization (1NF, 2NF, 3NF concepts)
- ✅ Denormalization trade-offs
- ✅ Set operations (INTERSECT, MINUS/EXCEPT)
- ✅ HAVING in complex scenarios
- ✅ Query optimization strategies

---

## 🔍 COMMON INTERVIEW PATTERNS

### **Pattern 1: "Walk me through your thought process"**
Interviewer wants to see:
1. Ask clarifying questions about requirements
2. Discuss the schema and relationships
3. Write simple version first, then optimize
4. Explain trade-offs you're making

### **Pattern 2: "Can you optimize this query?"**
They will give you a slow query. Respond with:
1. Identify the bottleneck (full scan? missing index?)
2. Propose indexes
3. Rewrite for SARGability
4. Show before/after performance

### **Pattern 3: "What would you do differently at scale?"**
At 1M rows vs 1B rows:
1. Partition strategy?
2. Index design?
3. Caching layer?
4. Denormalization needed?

### **Pattern 4: "Tell me about the most complex query..."**
Share:
1. Business problem you solved
2. Your approach (why you chose it)
3. Challenges you faced
4. How you optimized it

---

## 💡 INSIDER TIPS FOR SENIOR INTERVIEW

### **Do:**
- ✓ Ask clarifying questions: "Should I handle X edge case?"
- ✓ Explain your approach before writing code
- ✓ Mention indexes and performance considerations
- ✓ Discuss different approaches and their trade-offs
- ✓ Handle NULLs explicitly (don't ignore them)
- ✓ Use CTEs for readability (even if not required)
- ✓ Mention how you'd validate results

### **Don't:**
- ✗ Write query immediately without understanding schema
- ✗ Ignore NULL values (a common mistake)
- ✗ Create cartesian products (test your data volumes!)
- ✗ Ignore performance implications
- ✗ Use shortcuts that reduce readability
- ✗ Forget about edge cases ("What if no data exists?")
- ✗ Assume you know the schema without asking

---

## 🧪 SELF-ASSESSMENT

**Before Interview, Answer:**
- [ ] Can I explain PARTITION BY vs GROUP BY in 2 minutes?
- [ ] Can I write RANK vs ROW_NUMBER from memory?
- [ ] Can I identify a blown-up join in a 5-table query?
- [ ] Can I design a normalized schema for a complex scenario?
- [ ] Can I propose indexing strategy for slow query?
- [ ] Can I design a solution handling 1B rows?
- [ ] Can I explain LAG/LEAD with real-world example?
- [ ] Can I pivot data using CASE WHEN?
- [ ] Can I write recursive CTE for org chart?
- [ ] Can I design denormalized table for high-traffic dashboard?

**Ready for Interview if: ✓ 8-10/10**

---

## 📞 QUICK REFERENCE DURING PRACTICE

### **When stuck, remember:**

**What JOIN should I use?**
- INNER: Both sides must match
- LEFT: All from left, matched from right
- RIGHT: All from right, matched from left
- FULL OUTER: All from both sides

**GROUP BY or PARTITION BY?**
- GROUP BY: Reduces rows, must use aggregate functions
- PARTITION BY: Keeps all rows, accesses all in group

**WHERE or HAVING?**
- WHERE: Row level, before GROUP BY, can't use aggregates
- HAVING: Group level, after GROUP BY, requires aggregates

**Which RANK function?**
- ROW_NUMBER: Always sequential (1,2,3,4...)
- RANK: Allows ties (1,2,2,4...)
- DENSE_RANK: No gaps (1,2,2,3...)

---

## 🎓 FINAL WORDS

This curriculum represents what senior data engineers are expected to know. Not every company will test all topics, but:

- **Levels 1-3** are must-know (100% of companies)
- **Level 4** is likely tested (80-90% of companies)
- **Level 5** is checked in final rounds (50-70% of companies)

**Success comes from:**
1. Understanding the WHY (not just the HOW)
2. Practicing consistently (20+ questions minimum)
3. Explaining clearly (like teaching someone)
4. Thinking about edge cases (NULLs, duplicates, scale)
5. Discussing trade-offs (performance vs readability)

---

## 📚 ADDITIONAL RESOURCES

**For deeper learning:**
- Practice with real large datasets (1M+ rows)
- Study query execution plans (explain/analyze)
- Learn about indexing strategies
- Understand transactions and locks
- Read academic papers on database design

**When you're ready:**
- Take online assessments (LeetCode, HackerRank)
- Practice with real interview questions (Blind, Glassdoor)
- Record yourself answering questions
- Get peer reviews from senior engineers

---

**Good luck! You've got this! 🚀**

