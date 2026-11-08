# University Student Result Portal — SQL queries

## 1. Show related student, enrollment, course, result records (up to 20).

```sql
SELECT t0."student_key" AS "student_student_key",
       t0."cohort_year" AS "student_cohort_year",
       t1."enrollment_key" AS "enrollment_enrollment_key",
       t1."term_code" AS "enrollment_term_code",
       t3."course_key" AS "course_course_key",
       t3."course_code" AS "course_course_code",
       t2."result_key" AS "result_result_key",
       t2."score" AS "result_score"
FROM portfolio."student" t0
JOIN portfolio."enrollment" t1 ON t1."student_key" = t0."student_key"
JOIN portfolio."result" t2 ON t2."enrollment_key" = t1."enrollment_key"
JOIN portfolio."course" t3 ON t1."course_key" = t3."course_key"
ORDER BY t0."student_key", t1."enrollment_key", t3."course_key", t2."result_key"
LIMIT 20;
```

| student_student_key | student_cohort_year | enrollment_enrollment_key | enrollment_term_code | course_course_key | course_course_code | result_result_key | result_score |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 101 | 2025 | 301 | 2026S | 201 | SYN101 | 401 | 88.5 |

## 2. Find course records where course_code matches "SYN101" (up to 20).

```sql
SELECT * FROM portfolio."course"
WHERE "course_code" IS NOT DISTINCT FROM 'SYN101'
ORDER BY "course_key"
LIMIT 20;
```

| course_key | course_code | title | credits |
| --- | --- | --- | --- |
| 201 | SYN101 | Synthetic Foundations | 3 |

## 3. Count enrollment records for each student_key (up to 20 groups).

```sql
SELECT "student_key", count(*) AS record_count
FROM portfolio."enrollment"
GROUP BY "student_key"
ORDER BY record_count DESC, "student_key" NULLS LAST
LIMIT 20;
```

| student_key | record_count |
| --- | --- |
| 101 | 1 |
| 102 | 1 |

## 4. Find result records where published_at matches "2026-03-05T12:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."result"
WHERE "published_at" IS NOT DISTINCT FROM '2026-03-05T12:00:00Z'
ORDER BY "result_key"
LIMIT 20;
```

| result_key | enrollment_key | score | outcome | recorded_at | published_at |
| --- | --- | --- | --- | --- | --- |
| 401 | 301 | 88.5 | pass | 2026-03-01T10:00:00+00:00 | 2026-03-05T12:00:00+00:00 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.239 | 1.238, 1.294, 1.239 | Sort → Seq Scan | 139 |
| After index | 0.198 | 0.224, 0.198, 0.194 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.239 ms to 0.198 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.206..1.208 rows=25 loops=1)
  Seq Scan on result (actual time=0.016..1.17 rows=25 loops=1)
Planning Time: 0.34 ms
Execution Time: 1.238 ms
```

### Before index, run 2

```text
Sort (actual time=1.258..1.259 rows=25 loops=1)
  Seq Scan on result (actual time=0.017..1.219 rows=25 loops=1)
Planning Time: 0.509 ms
Execution Time: 1.294 ms
```

### Before index, run 3

```text
Sort (actual time=1.206..1.208 rows=25 loops=1)
  Seq Scan on result (actual time=0.015..1.171 rows=25 loops=1)
Planning Time: 0.352 ms
Execution Time: 1.239 ms
```

### After index, run 1

```text
Sort (actual time=0.17..0.172 rows=25 loops=1)
  Bitmap Heap Scan on result (actual time=0.027..0.134 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=25 loops=1)
Planning Time: 0.546 ms
Execution Time: 0.224 ms
```

### After index, run 2

```text
Sort (actual time=0.145..0.147 rows=25 loops=1)
  Bitmap Heap Scan on result (actual time=0.027..0.109 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=25 loops=1)
Planning Time: 0.616 ms
Execution Time: 0.198 ms
```

### After index, run 3

```text
Sort (actual time=0.141..0.143 rows=25 loops=1)
  Bitmap Heap Scan on result (actual time=0.026..0.109 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=25 loops=1)
Planning Time: 0.538 ms
Execution Time: 0.194 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run OGUNDARE_OMOTOLA_301920243_P2_Queries.sql, then OGUNDARE_OMOTOLA_301920243_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/OGUNDARE_OMOTOLA_301920243_P2_QueryResults.png) · [Index comparison](screenshots/OGUNDARE_OMOTOLA_301920243_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

