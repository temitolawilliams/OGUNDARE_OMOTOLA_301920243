# University Student Result Portal — ER diagram

```mermaid
erDiagram
    direction LR
    student {
        bigint student_key PK
        integer cohort_year
        boolean active
    }
    course {
        bigint course_key PK
        text course_code UK
        text title
        integer credits
    }
    enrollment {
        bigint enrollment_key PK
        bigint student_key FK
        bigint course_key FK
        text term_code
        text status
    }
    result {
        bigint result_key PK
        bigint enrollment_key FK,UK
        numeric score
        text outcome
        timestamptz recorded_at
        timestamptz published_at "Optional"
    }
    student ||--o{ enrollment : "student_key"
    course ||--o{ enrollment : "course_key"
    enrollment ||--o| result : "enrollment_key"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/OGUNDARE_OMOTOLA_301920243_ERDiagram.png)
