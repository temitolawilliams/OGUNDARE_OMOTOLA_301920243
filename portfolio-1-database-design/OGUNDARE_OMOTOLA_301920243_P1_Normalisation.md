# University Student Result Portal — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| student_key | enrollment records (list) |
| --- | --- |
| 101 | [301] |
| 102 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| enrollment.enrollment_key | enrollment.student_key | enrollment.course_key | enrollment.term_code | student.student_key | course.course_key | course.course_code |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026S | 101 | 201 | SYN101 |
| 302 | 102 | 202 | 2026F | 102 | 202 | SYN202 |

Key: enrollment_key.

## 2NF: depend on the whole key

enrollment: student_key is a proper part of candidate key (student_key, course_key, term_code), and determines student details. enrollment: course_key is a proper part of candidate key (student_key, course_key, term_code), and determines course details.

## student_example

| student.student_key |
| --- |
| 101 |
| 102 |

## course_example

| course.course_key | course.course_code |
| --- | --- |
| 201 | SYN101 |
| 202 | SYN202 |

## enrollment_example

| enrollment.enrollment_key | enrollment.student_key | enrollment.course_key | enrollment.term_code |
| --- | --- | --- | --- |
| 301 | 101 | 201 | 2026S |
| 302 | 102 | 202 | 2026F |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## student

| student_key | cohort_year | active |
| --- | --- | --- |
| 101 | 2025 | true |
| 102 | 2026 | true |

## course

| course_key | course_code | title | credits |
| --- | --- | --- | --- |
| 201 | SYN101 | Synthetic Foundations | 3 |
| 202 | SYN202 | Synthetic Methods | 4 |

## enrollment

| enrollment_key | student_key | course_key | term_code | status |
| --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026S | active |
| 302 | 102 | 202 | 2026F | active |

## result

| result_key | enrollment_key | score | outcome | recorded_at | published_at |
| --- | --- | --- | --- | --- | --- |
| 401 | 301 | 88.5 | pass | 2026-03-01T10:00:00+00:00 | 2026-03-05T12:00:00+00:00 |

## Dependencies

- student: (student_key) → cohort_year, active
- course: (course_key) → course_code, title, credits
- enrollment: (enrollment_key) → student_key, course_key, term_code, status
- result: (result_key) → enrollment_key, score, outcome, recorded_at, published_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
