-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. student pk. Expected: pk_student, SQLSTATE 23505.
INSERT INTO portfolio."student" ("student_key", "cohort_year", "active")
VALUES (101, 2027, TRUE);

-- 2. student nn key. Expected: student_key, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_key", "cohort_year", "active")
VALUES (NULL, 2027, TRUE);

-- 3. student nn cohort. Expected: cohort_year, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_key", "cohort_year", "active")
VALUES (9001, NULL, TRUE);

-- 4. student nn active. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_key", "cohort_year", "active")
VALUES (9002, 2027, NULL);

-- 5. course pk. Expected: pk_course, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits")
VALUES (201, 'SYN303', 'Synthetic Alternate', 3);

-- 6. course unique. Expected: uq_course_0, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits")
VALUES (9003, 'SYN101', 'Synthetic Duplicate Code', 2);

-- 7. course nn key. Expected: course_key, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits")
VALUES (NULL, 'SYN304', 'Synthetic Missing Key', 3);

-- 8. course nn code. Expected: course_code, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits")
VALUES (9004, NULL, 'Synthetic Missing Code', 3);

-- 9. course nn title. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits")
VALUES (9005, 'SYN305', NULL, 3);

-- 10. course nn credits. Expected: credits, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits")
VALUES (9006, 'SYN306', 'Synthetic Missing Credits', NULL);

-- 11. enrollment pk. Expected: pk_enrollment, SQLSTATE 23505.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (301, 101, 201, '2027S', 'active');

-- 12. enrollment unique. Expected: uq_enrollment_0, SQLSTATE 23505.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9007, 101, 201, '2026S', 'active');

-- 13. enrollment student fk. Expected: fk_enrollment_0, SQLSTATE 23503.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9008, 99001, 201, '2027S', 'active');

-- 14. enrollment course fk. Expected: fk_enrollment_1, SQLSTATE 23503.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9009, 101, 99002, '2027S', 'active');

-- 15. enrollment nn key. Expected: enrollment_key, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (NULL, 101, 201, '2027S', 'active');

-- 16. enrollment nn student. Expected: student_key, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9010, NULL, 201, '2027S', 'active');

-- 17. enrollment nn course. Expected: course_key, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9011, 101, NULL, '2027S', 'active');

-- 18. enrollment nn term. Expected: term_code, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9012, 101, 201, NULL, 'active');

-- 19. enrollment nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status")
VALUES (9013, 101, 201, '2027S', NULL);

-- 20. result pk. Expected: pk_result, SQLSTATE 23505.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (401, 302, 75, 'pass', '2026-04-01T10:00:00Z', NULL);

-- 21. result unique. Expected: uq_result_0, SQLSTATE 23505.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9014, 301, 75, 'pass', '2026-04-02T10:00:00Z', NULL);

-- 22. result enrollment fk. Expected: fk_result_0, SQLSTATE 23503.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9015, 99003, 75, 'pass', '2026-04-03T10:00:00Z', NULL);

-- 23. result nn key. Expected: result_key, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (NULL, 302, 75, 'pass', '2026-04-04T10:00:00Z', NULL);

-- 24. result nn enrollment. Expected: enrollment_key, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9016, NULL, 75, 'pass', '2026-04-05T10:00:00Z', NULL);

-- 25. result nn score. Expected: score, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9017, 302, NULL, 'pass', '2026-04-06T10:00:00Z', NULL);

-- 26. result nn outcome. Expected: outcome, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9018, 302, 75, NULL, '2026-04-07T10:00:00Z', NULL);

-- 27. result nn recorded. Expected: recorded_at, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9019, 302, 75, 'pass', NULL, NULL);

-- 28. result score check. Expected: score_range, SQLSTATE 23514.
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at")
VALUES (9020, 302, 101, 'pass', '2026-04-08T10:00:00Z', NULL);
