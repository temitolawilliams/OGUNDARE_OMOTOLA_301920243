-- University Student Result Portal: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."student" (
  "student_key" bigint NOT NULL,
  "cohort_year" bigint NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_student" PRIMARY KEY ("student_key")
);
CREATE TABLE portfolio."course" (
  "course_key" bigint NOT NULL,
  "course_code" text NOT NULL,
  "title" text NOT NULL,
  "credits" bigint NOT NULL,
  CONSTRAINT "pk_course" PRIMARY KEY ("course_key"),
  CONSTRAINT "uq_course_0" UNIQUE ("course_code")
);
CREATE TABLE portfolio."enrollment" (
  "enrollment_key" bigint NOT NULL,
  "student_key" bigint NOT NULL,
  "course_key" bigint NOT NULL,
  "term_code" text NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_enrollment" PRIMARY KEY ("enrollment_key"),
  CONSTRAINT "uq_enrollment_0" UNIQUE ("student_key", "course_key", "term_code")
);
CREATE TABLE portfolio."result" (
  "result_key" bigint NOT NULL,
  "enrollment_key" bigint NOT NULL,
  "score" numeric(18,2) NOT NULL,
  "outcome" text NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  "published_at" timestamptz,
  CONSTRAINT "pk_result" PRIMARY KEY ("result_key"),
  CONSTRAINT "uq_result_0" UNIQUE ("enrollment_key")
);
ALTER TABLE portfolio."enrollment" ADD CONSTRAINT "fk_enrollment_0" FOREIGN KEY ("student_key") REFERENCES portfolio."student" ("student_key");
ALTER TABLE portfolio."enrollment" ADD CONSTRAINT "fk_enrollment_1" FOREIGN KEY ("course_key") REFERENCES portfolio."course" ("course_key");
ALTER TABLE portfolio."result" ADD CONSTRAINT "fk_result_0" FOREIGN KEY ("enrollment_key") REFERENCES portfolio."enrollment" ("enrollment_key");
ALTER TABLE portfolio."result" ADD CONSTRAINT "score_range" CHECK (("score" >= 0) AND ("score" <= 100));
COMMIT;
