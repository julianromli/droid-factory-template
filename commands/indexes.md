---
description: Scan codebase for missing database indexes
argument-hint: <optional-path>
---

Analyze the database schema and queries in `$ARGUMENTS` (or entire codebase if not specified) to identify missing indexes.

## Tasks

1. **Scan for slow queries** - Look for queries without proper index coverage
2. **Analyze foreign keys** - Check if foreign key columns have indexes
3. **Review JOIN operations** - Identify columns used in JOINs without indexes
4. **Check WHERE clauses** - Find frequently filtered columns lacking indexes
5. **Examine ORDER BY** - Look for sorting operations on non-indexed columns

## Output

Provide a summary of:
- Missing indexes with CREATE INDEX statements
- Potential redundant indexes to remove
- Performance impact estimates
