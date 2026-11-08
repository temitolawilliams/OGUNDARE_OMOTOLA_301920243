-- Fictional sample records for University Student Result Portal.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."student" ("student_key", "cohort_year", "active") VALUES (101, 2025, TRUE);
INSERT INTO portfolio."student" ("student_key", "cohort_year", "active") VALUES (102, 2026, TRUE);
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits") VALUES (201, 'SYN101', 'Synthetic Foundations', 3);
INSERT INTO portfolio."course" ("course_key", "course_code", "title", "credits") VALUES (202, 'SYN202', 'Synthetic Methods', 4);
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status") VALUES (301, 101, 201, '2026S', 'active');
INSERT INTO portfolio."enrollment" ("enrollment_key", "student_key", "course_key", "term_code", "status") VALUES (302, 102, 202, '2026F', 'active');
INSERT INTO portfolio."result" ("result_key", "enrollment_key", "score", "outcome", "recorded_at", "published_at") VALUES (401, 301, 88.5, 'pass', '2026-03-01T10:00:00Z', '2026-03-05T12:00:00Z');
COMMIT;
