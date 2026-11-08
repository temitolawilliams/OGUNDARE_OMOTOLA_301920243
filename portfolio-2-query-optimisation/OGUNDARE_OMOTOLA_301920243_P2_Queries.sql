-- Show related student, enrollment, course, result records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find course records where course_code matches "SYN101" (up to 20).
SELECT * FROM portfolio."course"
WHERE "course_code" IS NOT DISTINCT FROM 'SYN101'
ORDER BY "course_key"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."course"
WHERE "course_code" IS NOT DISTINCT FROM 'SYN101'
ORDER BY "course_key"
LIMIT 20;

-- Count enrollment records for each student_key (up to 20 groups).
SELECT "student_key", count(*) AS record_count
FROM portfolio."enrollment"
GROUP BY "student_key"
ORDER BY record_count DESC, "student_key" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "student_key", count(*) AS record_count
FROM portfolio."enrollment"
GROUP BY "student_key"
ORDER BY record_count DESC, "student_key" NULLS LAST
LIMIT 20;

-- Find result records where published_at matches "2026-03-05T12:00:00Z" (up to 20).
SELECT * FROM portfolio."result"
WHERE "published_at" IS NOT DISTINCT FROM '2026-03-05T12:00:00Z'
ORDER BY "result_key"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."result"
WHERE "published_at" IS NOT DISTINCT FROM '2026-03-05T12:00:00Z'
ORDER BY "result_key"
LIMIT 20;
