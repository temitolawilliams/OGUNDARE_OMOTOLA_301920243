# University Student Result Portal — database design

My case study records student, course, enrollment, result.

## Users

- Students viewing their own published results
- Instructors recording assessment results
- Registrars managing courses and enrollments

## Main operations

- Create course enrollments
- Record and publish assessment results
- View a student's transcript
- Summarize published results by course and term

## Entities

| Entity | Information stored |
| --- | --- |
| student | Stores minimal synthetic student records without names or real-world identifiers. |
| course | Stores course catalog details used by the portal. |
| enrollment | Links one student to one course for a particular academic term. |
| result | Stores an enrollment's assessment score and publication state. |

## student

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| student_key | BIGINT | PK | Yes |
| cohort_year | INTEGER |  | Yes |
| active | BOOLEAN |  | Yes |


## course

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| course_key | BIGINT | PK | Yes |
| course_code | TEXT | Unique | Yes |
| title | TEXT |  | Yes |
| credits | INTEGER |  | Yes |
- Unique key: (course_code).

## enrollment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| enrollment_key | BIGINT | PK | Yes |
| student_key | BIGINT | FK | Yes |
| course_key | BIGINT | FK | Yes |
| term_code | TEXT |  | Yes |
| status | TEXT |  | Yes |
- student_key → student.student_key
- course_key → course.course_key
- Unique key: (student_key, course_key, term_code).

## result

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| result_key | BIGINT | PK | Yes |
| enrollment_key | BIGINT | FK, Unique | Yes |
| score | NUMERIC(18,2) |  | Yes |
| outcome | TEXT |  | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
| published_at | TIMESTAMPTZ |  | No |
- enrollment_key → enrollment.enrollment_key
- Unique key: (enrollment_key).

## Relationships and business rules

- Each course has a distinct catalog code.
- Every enrollment references an existing student record.
- Every enrollment references an existing course record.
- A student can have at most one enrollment for the same course and term.
- A recorded score must be between zero and one hundred inclusive.
- Every result references an existing enrollment.
- Each enrollment has at most one result record.

## Assumptions

- All example keys and values are synthetic; student_key is an opaque internal surrogate, not a real student identifier.
- An enrollment is for one student, one course, and one term; retakes in the same course require a different term.
- Each enrollment has at most one result record, and a result is considered published only when published_at is present.
- Normalization example: enrollment stores student_key and course_key as foreign keys; student and course attributes remain in their respective tables, while result refers to enrollment rather than repeating those ancestor keys.

