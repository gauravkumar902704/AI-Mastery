-- ============================================================
--              POSTGRESQL PRACTICE DATABASE
-- ============================================================
-- Database contains:
-- 1. Departments
-- 2. Students
-- 3. Courses
-- 4. Enrollments
--
-- Purpose:
-- This database is created for practicing PostgreSQL queries,
-- constraints, joins, aggregate functions, subqueries, etc.
-- ============================================================



-- ============================================================
-- 1. CLEAN OLD TABLES
-- ============================================================
-- We drop the tables first so that the complete script can be
-- executed again and again with a fresh dataset.
--
-- Order is important because of FOREIGN KEY relationships.
-- Enrollments depends on students and courses.
-- Students and courses depend on departments.
-- ============================================================

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS departments;



-- ============================================================
-- 2. CREATE DEPARTMENTS TABLE
-- ============================================================
-- department_id:
--     Automatically generated unique ID.
--
-- department_name:
--     Department name must be unique and cannot be NULL.
--
-- location:
--     Physical location of the department.
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(50)
);



-- ============================================================
-- 3. INSERT DEPARTMENT DATA
-- ============================================================
-- ON CONFLICT prevents duplicate department names.
-- If the same department already exists, PostgreSQL ignores
-- that particular INSERT.
-- ============================================================

INSERT INTO departments
(department_name, location)
VALUES
('Computer Science', 'Block A'),
('Artificial Intelligence', 'Block B'),
('Electronics', 'Block C'),
('Mechanical', 'Block D'),
('Civil', 'Block E'),
('Information Technology', 'Block F')
ON CONFLICT (department_name)
DO NOTHING;



-- ============================================================
-- 4. VIEW DEPARTMENTS
-- ============================================================

SELECT * FROM departments;



-- ============================================================
-- 5. CREATE STUDENTS TABLE
-- ============================================================
-- student_id:
--     Automatically generated unique ID.
--
-- name:
--     Student name cannot be NULL.
--
-- email:
--     Every student must have a unique email.
--
-- age:
--     Age must be between 16 and 100.
--
-- department_id:
--     Foreign Key referencing departments table.
--
-- marks:
--     Marks must be between 0 and 100.
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INT CHECK (age >= 16 AND age <= 100),
    gender VARCHAR(10),
    city VARCHAR(50),
    department_id INT NOT NULL REFERENCES departments(department_id),
    marks DECIMAL(5,2) CHECK (marks >= 0 AND marks <= 100),
    admission_year INT
);



-- ============================================================
-- 6. INSERT STUDENT DATA
-- ============================================================
-- ON CONFLICT (email) prevents the same email from being
-- inserted more than once.
-- ============================================================

INSERT INTO students
(name, email, age, gender, city, department_id, marks, admission_year)
VALUES
('Gaurav Kumar', 'gaurav.kumar@gmail.com', 22, 'Male', 'Aligarh', 1, 82.50, 2022),
('Rahul Sharma', 'rahul.sharma@gmail.com', 21, 'Male', 'Delhi', 1, 76.40, 2023),
('Priya Singh', 'priya.singh@gmail.com', 22, 'Female', 'Lucknow', 2, 91.20, 2022),
('Ananya Gupta', 'ananya.gupta@gmail.com', 21, 'Female', 'Noida', 2, 88.75, 2023),
('Aman Verma', 'aman.verma@gmail.com', 23, 'Male', 'Agra', 3, 69.80, 2021),
('Neha Yadav', 'neha.yadav@gmail.com', 22, 'Female', 'Kanpur', 1, 94.10, 2022),
('Rohit Kumar', 'rohit.kumar@gmail.com', 21, 'Male', 'Meerut', 4, 73.50, 2023),
('Sneha Agarwal', 'sneha.agarwal@gmail.com', 22, 'Female', 'Delhi', 5, 85.60, 2022),
('Arjun Singh', 'arjun.singh@gmail.com', 23, 'Male', 'Jaipur', 6, 78.90, 2021),
('Simran Kaur', 'simran.kaur@gmail.com', 21, 'Female', 'Chandigarh', 2, 92.30, 2023),
('Vikas Mishra', 'vikas.mishra@gmail.com', 22, 'Male', 'Varanasi', 1, 67.40, 2022),
('Pooja Sharma', 'pooja.sharma@gmail.com', 21, 'Female', 'Noida', 6, 81.70, 2023),
('Karan Gupta', 'karan.gupta@gmail.com', 23, 'Male', 'Ghaziabad', 3, 72.80, 2021),
('Megha Jain', 'megha.jain@gmail.com', 22, 'Female', 'Agra', 2, 89.50, 2022),
('Nikhil Verma', 'nikhil.verma@gmail.com', 21, 'Male', 'Aligarh', 1, 74.60, 2023)
ON CONFLICT (email)
DO NOTHING;



-- ============================================================
-- 7. VIEW STUDENTS
-- ============================================================

SELECT * FROM students;



-- ============================================================
-- 8. CREATE COURSES TABLE
-- ============================================================
-- course_id:
--     Automatically generated unique ID.
--
-- course_name:
--     Course name must be unique.
--
-- credits:
--     Number of credits assigned to the course.
--
-- department_id:
--     Foreign Key referencing departments table.
-- ============================================================

CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) UNIQUE NOT NULL,
    credits INT,
    department_id INT NOT NULL REFERENCES departments(department_id)
);



-- ============================================================
-- 9. INSERT COURSE DATA
-- ============================================================
-- ON CONFLICT (course_name) prevents duplicate courses.
-- ============================================================

INSERT INTO courses
(course_name, credits, department_id)
VALUES
('Python Programming', 4, 1),
('Data Structures', 4, 1),
('Machine Learning', 4, 2),
('Deep Learning', 4, 2),
('Database Management System', 3, 6),
('Computer Networks', 3, 1),
('Operating Systems', 4, 1),
('Artificial Intelligence', 4, 2),
('Digital Electronics', 3, 3),
('Thermodynamics', 4, 4),
('Structural Engineering', 4, 5),
('Web Development', 3, 6)
ON CONFLICT (course_name)
DO NOTHING;



-- ============================================================
-- 10. VIEW COURSES
-- ============================================================

SELECT * FROM courses;



-- ============================================================
-- 11. CREATE ENROLLMENTS TABLE
-- ============================================================
-- This table represents the relationship between students
-- and courses.
--
-- student_id:
--     Foreign Key referencing students.
--
-- course_id:
--     Foreign Key referencing courses.
--
-- UNIQUE(student_id, course_id):
--     A student cannot enroll in the same course twice.
--
-- This is a COMPOSITE UNIQUE constraint because uniqueness
-- is checked on the combination of two columns.
-- ============================================================

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    course_id INT NOT NULL REFERENCES courses(course_id),
    enrollment_date DATE NOT NULL,
    grade VARCHAR(2),

    UNIQUE (student_id, course_id)
);



-- ============================================================
-- 12. INSERT ENROLLMENT DATA
-- ============================================================
-- ON CONFLICT prevents the same student from being enrolled
-- in the same course more than once.
-- ============================================================

INSERT INTO enrollments
(student_id, course_id, enrollment_date, grade)
VALUES
(1, 1, '2024-07-10', 'A'),
(1, 2, '2024-07-10', 'A'),
(1, 5, '2024-07-11', 'B'),
(2, 1, '2024-07-12', 'B'),
(2, 6, '2024-07-12', 'B'),
(3, 3, '2024-07-10', 'A'),
(3, 4, '2024-07-10', 'A'),
(3, 8, '2024-07-11', 'A'),
(4, 3, '2024-07-12', 'A'),
(4, 8, '2024-07-12', 'B'),
(5, 9, '2024-07-13', 'C'),
(6, 1, '2024-07-10', 'A'),
(6, 7, '2024-07-10', 'A'),
(7, 10, '2024-07-11', 'B'),
(8, 11, '2024-07-12', 'A'),
(9, 5, '2024-07-13', 'B'),
(9, 12, '2024-07-13', 'A'),
(10, 3, '2024-07-10', 'A'),
(10, 4, '2024-07-10', 'A'),
(11, 2, '2024-07-11', 'C'),
(12, 5, '2024-07-12', 'B'),
(12, 12, '2024-07-12', 'A'),
(13, 9, '2024-07-13', 'B'),
(14, 3, '2024-07-10', 'A'),
(14, 8, '2024-07-10', 'A'),
(15, 1, '2024-07-11', 'B'),
(15, 7, '2024-07-11', 'B')
ON CONFLICT (student_id, course_id)
DO NOTHING;



-- ============================================================
-- 13. VIEW ENROLLMENTS
-- ============================================================

SELECT * FROM enrollments;



-- ============================================================
--                  DATABASE SUMMARY
-- ============================================================
-- Departments → 6 records
-- Students    → 15 records
-- Courses     → 12 records
-- Enrollments → 27 records
--
-- Relationships:
--
-- departments
--      │
--      ├──────────────┐
--      ↓              ↓
--   students       courses
--      │              │
--      └──────┬───────┘
--             ↓
--        enrollments
--
-- ============================================================
--               END OF DATABASE SETUP
-- ============================================================

-- ---------------------------------------------------------------------------------------------------------------------------
 -- ============================================================
--              POSTGRESQL QUERY PRACTICE
-- ============================================================
-- IMPORTANT:
-- Only syntax/templates are provided in this section.
-- Write the actual queries yourself for practice.
-- ============================================================


-- ============================================================
-- 1. SELECT
-- ============================================================
-- Retrieve all columns from a table:
--
-- SELECT *
-- FROM table_name;
--
-- Retrieve specific columns:
--
-- SELECT column1, column2
-- FROM table_name;
-- All columns:
SELECT * FROM students;

-- Retrieve Specifiv columns:
SELECT student_id, name, email FROM students; 


-- ============================================================
-- 2. DISTINCT
-- ============================================================
-- Retrieve only unique values from a column:
--
-- SELECT DISTINCT column_name
-- FROM table_name;

SELECT DISTINCT name FROM students;

-- ============================================================
-- 3. WHERE
-- ============================================================
-- Filter rows based on a condition:
--
-- SELECT *
-- FROM table_name
-- WHERE condition;

SELECT * FROM students
WHERE marks>80;

-- ============================================================
-- 4. COMPARISON OPERATORS
-- ============================================================
-- Common comparison operators:
--
-- =       Equal to
-- <>      Not equal to
-- !=      Not equal to
-- >       Greater than
-- <       Less than
-- >=      Greater than or equal to
-- <=      Less than or equal to
--
-- Basic syntax:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name operator value;

SELECT * FROM students
WHERE city = 'Aligarh';


-- ============================================================
-- 5. AND
-- ============================================================
-- Use AND when all conditions must be true:
--
-- SELECT *
-- FROM table_name
-- WHERE condition1
-- AND condition2;
SELECT * FROM students
WHERE city = 'Aligarh' AND marks >=75;


-- ============================================================
-- 6. OR
-- ============================================================
-- Use OR when at least one condition must be true:
--
-- SELECT *
-- FROM table_name
-- WHERE condition1
-- OR condition2;

SELECT * FROM students
WHERE city = 'Aligarh' OR marks >= 75;

-- ============================================================
-- 7. NOT
-- ============================================================
-- Negate a condition:
--
-- SELECT *
-- FROM table_name
-- WHERE NOT condition;

SELECT * FROM students
WHERE NOT gender = 'Male';

-- ============================================================
-- 8. BETWEEN
-- ============================================================
-- Select values within a range:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name BETWEEN value1 AND value2;
SELECT * FROM students
WHERE marks BETWEEN 75 AND 100;


-- ============================================================
-- 9. IN
-- ============================================================
-- Match a column against multiple possible values:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name IN (value1, value2, value3);

SELECT * FROM students
WHERE admission_year IN (2023,2024,2025,2026);

-- ============================================================
-- 10. NOT IN
-- ============================================================
-- Exclude multiple values:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name NOT IN (value1, value2, value3);
SELECT * FROM students
WHERE admission_year NOT IN (2025,2026,2023);


-- ============================================================
-- 11. LIKE
-- ============================================================
-- Perform pattern matching.
--
-- %  = Zero or more characters
-- _  = Exactly one character
--
-- SELECT *
-- FROM table_name
-- WHERE column_name LIKE 'pattern';
SELECT * FROM students
WHERE gender LIKE 'Male';


-- ============================================================
-- 12. ILIKE
-- ============================================================
-- PostgreSQL-specific case-insensitive pattern matching:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name ILIKE 'pattern';



-- ============================================================
-- 13. IS NULL
-- ============================================================
-- Find rows where a column contains NULL:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name IS NULL;

SELECT * FROM students
WHERE email IS NULL;

-- ============================================================
-- 14. IS NOT NULL
-- ============================================================
-- Find rows where a column does not contain NULL:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name IS NOT NULL;

SELECT * FROM students
WHERE email IS NOT NULL;

-- ============================================================
-- 15. ORDER BY
-- ============================================================
-- Sort query results.
--
-- ASC  = Ascending order
-- DESC = Descending order
--
-- SELECT *
-- FROM table_name
-- ORDER BY column_name ASC;
SELECT * FROM students
ORDER BY student_id ASC;
--
-- SELECT *
-- FROM table_name
-- ORDER BY column_name DESC;
SELECT * FROM students
ORDER BY student_id DESC;



-- ============================================================
-- 16. ORDER BY MULTIPLE COLUMNS
-- ============================================================
-- Sort using more than one column:
--
-- SELECT *
-- FROM table_name
-- ORDER BY column1 ASC, column2 DESC;
SELECT * FROM students
ORDER BY student_id ASC, department_id ASC;


-- ============================================================
-- 17. LIMIT
-- ============================================================
-- Limit the number of rows returned:
--
-- SELECT *
-- FROM table_name
-- LIMIT number;
SELECT * FROM students
LIMIT 10;


-- ============================================================
-- 18. OFFSET
-- ============================================================
-- Skip a specific number of rows:
--
-- SELECT *
-- FROM table_name
-- LIMIT number
-- OFFSET number;
SELECT * FROM students
LIMIT 5
OFFSET 3;

-- ============================================================
-- 19. ALIAS (AS)
-- ============================================================
-- Give a temporary name to a column:
--
-- SELECT column_name AS new_name
-- FROM table_name;
--
-- Table alias:
--
-- SELECT t.column_name
-- FROM table_name AS t;

SELECT department_id AS dept_id
FROM students;

-- ============================================================
-- 20. COUNT()
-- ============================================================
-- Count rows or values:
--
-- SELECT COUNT(*)
-- FROM table_name;

SELECT COUNT(*)
FROM students;

--
-- SELECT COUNT(column_name)
-- FROM table_name;

SELECT COUNT(department_id)
FROM students;

-- ============================================================
-- 21. SUM()
-- ============================================================
-- Calculate the total of a numeric column:
--
-- SELECT SUM(column_name)
-- FROM table_name;

SELECT SUM(marks) FROM students;

-- ============================================================
-- 22. AVG()
-- ============================================================
-- Calculate the average of a numeric column:
--
-- SELECT AVG(column_name)
-- FROM table_name;

SELECT AVG(marks) FROM students;

-- ============================================================
-- 23. MIN()
-- ============================================================
-- Find the minimum value:
--
-- SELECT MIN(column_name)
-- FROM table_name;

SELECT MIN(marks) FROM students;

-- ============================================================
-- 24. MAX()
-- ============================================================
-- Find the maximum value:
--
-- SELECT MAX(column_name)
-- FROM table_name;

SELECT MAX(marks) FROM students;

-- ============================================================
-- 25. GROUP BY
-- ============================================================
-- Group rows with the same values:
--
-- SELECT column_name, aggregate_function(column_name)
-- FROM table_name
-- GROUP BY column_name;



-- ============================================================
-- 26. HAVING
-- ============================================================
-- Filter groups created using GROUP BY:
--
-- SELECT column_name, aggregate_function(column_name)
-- FROM table_name
-- GROUP BY column_name
-- HAVING condition;



-- ============================================================
-- 27. WHERE + GROUP BY + HAVING
-- ============================================================
-- Practice combining row filtering and group filtering:
--
-- SELECT column_name, aggregate_function(column_name)
-- FROM table_name
-- WHERE condition
-- GROUP BY column_name
-- HAVING condition;



-- ============================================================
-- 28. INNER JOIN
-- ============================================================
-- Return only matching records from two tables:
--
-- SELECT columns
-- FROM table1
-- INNER JOIN table2
-- ON table1.column = table2.column;



-- ============================================================
-- 29. LEFT JOIN
-- ============================================================
-- Return all records from the left table and matching records
-- from the right table:
--
-- SELECT columns
-- FROM table1
-- LEFT JOIN table2
-- ON table1.column = table2.column;



-- ============================================================
-- 30. RIGHT JOIN
-- ============================================================
-- Return all records from the right table and matching records
-- from the left table:
--
-- SELECT columns
-- FROM table1
-- RIGHT JOIN table2
-- ON table1.column = table2.column;



-- ============================================================
-- 31. FULL OUTER JOIN
-- ============================================================
-- Return matching and non-matching records from both tables:
--
-- SELECT columns
-- FROM table1
-- FULL OUTER JOIN table2
-- ON table1.column = table2.column;



-- ============================================================
-- 32. CROSS JOIN
-- ============================================================
-- Return every possible combination of rows:
--
-- SELECT columns
-- FROM table1
-- CROSS JOIN table2;



-- ============================================================
-- 33. SELF JOIN
-- ============================================================
-- Join a table with itself using table aliases:
--
-- SELECT ...
-- FROM table_name AS t1
-- JOIN table_name AS t2
-- ON t1.column = t2.column;



-- ============================================================
-- 34. MULTIPLE TABLE JOIN
-- ============================================================
-- Join three or more tables:
--
-- SELECT ...
-- FROM table1
-- JOIN table2
-- ON ...
-- JOIN table3
-- ON ...;



-- ============================================================
-- 35. STRING FUNCTIONS
-- ============================================================
-- Common string functions:
--
-- LENGTH()
-- LOWER()
-- UPPER()
-- TRIM()
-- CONCAT()
-- REPLACE()
-- SUBSTRING()
--
-- Basic syntax:
--
-- SELECT function_name(column_name)
-- FROM table_name;



-- ============================================================
-- 36. NUMERIC FUNCTIONS
-- ============================================================
-- Common numeric functions:
--
-- ROUND()
-- CEIL()
-- FLOOR()
-- ABS()
--
-- Basic syntax:
--
-- SELECT function_name(column_name)
-- FROM table_name;



-- ============================================================
-- 37. DATE FUNCTIONS
-- ============================================================
-- Common date/time functions:
--
-- CURRENT_DATE
-- CURRENT_TIMESTAMP
-- EXTRACT()
-- DATE_PART()
--
-- Basic syntax:
--
-- SELECT function_name(...)
-- FROM table_name;



-- ============================================================
-- 38. CASE EXPRESSION
-- ============================================================
-- Return different values based on conditions:
--
-- SELECT
--     column_name,
--     CASE
--         WHEN condition THEN result
--         WHEN condition THEN result
--         ELSE result
--     END AS new_column
-- FROM table_name;



-- ============================================================
-- 39. COALESCE
-- ============================================================
-- Replace NULL with another value:
--
-- SELECT COALESCE(column_name, replacement_value)
-- FROM table_name;



-- ============================================================
-- 40. INSERT
-- ============================================================
-- Insert a new record:
--
-- INSERT INTO table_name
-- (column1, column2, column3)
-- VALUES
-- (value1, value2, value3);



-- ============================================================
-- 41. INSERT MULTIPLE ROWS
-- ============================================================
-- Insert multiple records at once:
--
-- INSERT INTO table_name
-- (column1, column2)
-- VALUES
-- (value1, value2),
-- (value3, value4),
-- (value5, value6);



-- ============================================================
-- 42. ON CONFLICT DO NOTHING
-- ============================================================
-- Ignore an INSERT when a unique/primary key conflict occurs:
--
-- INSERT INTO table_name (...)
-- VALUES (...)
-- ON CONFLICT (column_name)
-- DO NOTHING;



-- ============================================================
-- 43. ON CONFLICT DO UPDATE
-- ============================================================
-- Update an existing record when a conflict occurs:
--
-- INSERT INTO table_name (...)
-- VALUES (...)
-- ON CONFLICT (column_name)
-- DO UPDATE
-- SET column_name = EXCLUDED.column_name;



-- ============================================================
-- 44. UPDATE
-- ============================================================
-- Modify existing records:
--
-- UPDATE table_name
-- SET column_name = new_value
-- WHERE condition;



-- ============================================================
-- 45. UPDATE MULTIPLE COLUMNS
-- ============================================================
-- Update more than one column:
--
-- UPDATE table_name
-- SET
--     column1 = value1,
--     column2 = value2
-- WHERE condition;



-- ============================================================
-- 46. DELETE
-- ============================================================
-- Delete specific records:
--
-- DELETE FROM table_name
-- WHERE condition;



-- ============================================================
-- 47. ALTER TABLE - ADD COLUMN
-- ============================================================
-- Add a new column to an existing table:
--
-- ALTER TABLE table_name
-- ADD COLUMN column_name data_type;



-- ============================================================
-- 48. ALTER TABLE - DROP COLUMN
-- ============================================================
-- Remove a column:
--
-- ALTER TABLE table_name
-- DROP COLUMN column_name;



-- ============================================================
-- 49. ALTER TABLE - RENAME COLUMN
-- ============================================================
-- Rename an existing column:
--
-- ALTER TABLE table_name
-- RENAME COLUMN old_name TO new_name;



-- ============================================================
-- 50. ALTER TABLE - RENAME TABLE
-- ============================================================
-- Rename an existing table:
--
-- ALTER TABLE old_table_name
-- RENAME TO new_table_name;



-- ============================================================
-- 51. ADD CONSTRAINT
-- ============================================================
-- Add a constraint to an existing table:
--
-- ALTER TABLE table_name
-- ADD CONSTRAINT constraint_name
-- constraint_definition;



-- ============================================================
-- 52. DROP CONSTRAINT
-- ============================================================
-- Remove an existing constraint:
--
-- ALTER TABLE table_name
-- DROP CONSTRAINT constraint_name;



-- ============================================================
-- 53. SUBQUERY
-- ============================================================
-- Use one query inside another query:
--
-- SELECT *
-- FROM table_name
-- WHERE column_name operator
-- (
--     SELECT column_name
--     FROM table_name
--     WHERE condition
-- );



-- ============================================================
-- 54. SUBQUERY WITH IN
-- ============================================================
-- Use a subquery with the IN operator:
--
-- SELECT *
-- FROM table1
-- WHERE column_name IN
-- (
--     SELECT column_name
--     FROM table2
--     WHERE condition
-- );



-- ============================================================
-- 55. EXISTS
-- ============================================================
-- Check whether a subquery returns at least one row:
--
-- SELECT *
-- FROM table1 AS t1
-- WHERE EXISTS
-- (
--     SELECT 1
--     FROM table2 AS t2
--     WHERE condition
-- );



-- ============================================================
-- 56. CREATE VIEW
-- ============================================================
-- Create a virtual table based on a query:
--
-- CREATE VIEW view_name AS
-- SELECT ...
-- FROM ...
-- WHERE ...;



-- ============================================================
-- 57. USE VIEW
-- ============================================================
-- Query a view like a table:
--
-- SELECT *
-- FROM view_name;



-- ============================================================
-- 58. DROP VIEW
-- ============================================================
-- Delete a view:
--
-- DROP VIEW view_name;



-- ============================================================
-- 59. CREATE INDEX
-- ============================================================
-- Create an index on a column:
--
-- CREATE INDEX index_name
-- ON table_name (column_name);



-- ============================================================
-- 60. CREATE UNIQUE INDEX
-- ============================================================
-- Create an index that also enforces uniqueness:
--
-- CREATE UNIQUE INDEX index_name
-- ON table_name (column_name);



-- ============================================================
-- 61. DROP INDEX
-- ============================================================
-- Remove an index:
--
-- DROP INDEX index_name;



-- ============================================================
-- 62. CTE - COMMON TABLE EXPRESSION
-- ============================================================
-- Create a temporary named result set for a query:
--
-- WITH cte_name AS
-- (
--     SELECT ...
--     FROM ...
--     WHERE ...
-- )
-- SELECT *
-- FROM cte_name;



-- ============================================================
-- 63. MULTIPLE CTEs
-- ============================================================
-- Define multiple CTEs in one query:
--
-- WITH cte1 AS
-- (
--     SELECT ...
-- ),
-- cte2 AS
-- (
--     SELECT ...
-- )
-- SELECT ...
-- FROM cte1
-- JOIN cte2
-- ON ...;



-- ============================================================
-- 64. ROW_NUMBER()
-- ============================================================
-- Assign a sequential number to rows:
--
-- SELECT
--     column_name,
--     ROW_NUMBER() OVER (
--         ORDER BY column_name
--     ) AS row_number
-- FROM table_name;



-- ============================================================
-- 65. RANK()
-- ============================================================
-- Assign rankings while leaving gaps after ties:
--
-- SELECT
--     column_name,
--     RANK() OVER (
--         ORDER BY column_name DESC
--     ) AS rank
-- FROM table_name;



-- ============================================================
-- 66. DENSE_RANK()
-- ============================================================
-- Assign rankings without gaps after ties:
--
-- SELECT
--     column_name,
--     DENSE_RANK() OVER (
--         ORDER BY column_name DESC
--     ) AS dense_rank
-- FROM table_name;



-- ============================================================
-- 67. PARTITION BY
-- ============================================================
-- Perform a window calculation separately for each group:
--
-- FUNCTION_NAME() OVER (
--     PARTITION BY column_name
--     ORDER BY column_name
-- );



-- ============================================================
-- 68. LAG()
-- ============================================================
-- Access a previous row's value:
--
-- LAG(column_name) OVER (
--     ORDER BY column_name
-- );



-- ============================================================
-- 69. LEAD()
-- ============================================================
-- Access a following row's value:
--
-- LEAD(column_name) OVER (
--     ORDER BY column_name
-- );



-- ============================================================
-- 70. TRANSACTIONS
-- ============================================================
-- Start a transaction:
--
-- BEGIN;
--
-- SQL STATEMENT;
-- SQL STATEMENT;
--
-- COMMIT;
--
-- Use ROLLBACK to undo changes:
--
-- BEGIN;
--
-- SQL STATEMENT;
--
-- ROLLBACK;



-- ============================================================
-- 71. SAVEPOINT
-- ============================================================
-- Create a checkpoint inside a transaction:
--
-- BEGIN;
--
-- SQL STATEMENT;
--
-- SAVEPOINT savepoint_name;
--
-- SQL STATEMENT;
--
-- ROLLBACK TO savepoint_name;
--
-- COMMIT;



-- ============================================================
-- 72. DEFAULT
-- ============================================================
-- Assign a default value to a column:
--
-- column_name data_type DEFAULT default_value;



-- ============================================================
-- 73. PRIMARY KEY
-- ============================================================
-- Uniquely identifies every row in a table:
--
-- column_name data_type PRIMARY KEY;



-- ============================================================
-- 74. FOREIGN KEY
-- ============================================================
-- Create a relationship between two tables:
--
-- column_name data_type
-- REFERENCES other_table(other_column);



-- ============================================================
-- 75. UNIQUE
-- ============================================================
-- Prevent duplicate values:
--
-- column_name data_type UNIQUE;



-- ============================================================
-- 76. NOT NULL
-- ============================================================
-- Prevent NULL values:
--
-- column_name data_type NOT NULL;



-- ============================================================
-- 77. CHECK
-- ============================================================
-- Restrict values based on a condition:
--
-- column_name data_type
-- CHECK (condition);



-- ============================================================
-- 78. INFORMATION_SCHEMA
-- ============================================================
-- PostgreSQL provides information about database objects
-- through information_schema.
--
-- Useful objects to explore:
--
-- information_schema.tables
-- information_schema.columns
--
-- Practice retrieving:
-- - Table names
-- - Column names
-- - Data types
-- - Constraints



-- ============================================================
-- 79. EXPLAIN
-- ============================================================
-- Display the query execution plan:
--
-- EXPLAIN
-- SELECT ...
-- FROM ...
-- WHERE ...;



-- ============================================================
-- 80. EXPLAIN ANALYZE
-- ============================================================
-- Execute the query and display the actual execution plan:
--
-- EXPLAIN ANALYZE
-- SELECT ...
-- FROM ...
-- WHERE ...;



-- ============================================================
--                 RECOMMENDED PRACTICE ORDER
-- ============================================================
--
-- LEVEL 1 - BASIC
-- SELECT
-- DISTINCT
-- WHERE
-- AND / OR / NOT
-- BETWEEN
-- IN / NOT IN
-- LIKE / ILIKE
-- IS NULL / IS NOT NULL
--
-- LEVEL 2 - SORTING & FILTERING
-- ORDER BY
-- LIMIT
-- OFFSET
-- AS
--
-- LEVEL 3 - AGGREGATION
-- COUNT
-- SUM
-- AVG
-- MIN
-- MAX
-- GROUP BY
-- HAVING
--
-- LEVEL 4 - JOINS
-- INNER JOIN
-- LEFT JOIN
-- RIGHT JOIN
-- FULL OUTER JOIN
-- CROSS JOIN
-- SELF JOIN
-- MULTIPLE TABLE JOIN
--
-- LEVEL 5 - FUNCTIONS
-- String Functions
-- Numeric Functions
-- Date Functions
-- CASE
-- COALESCE
--
-- LEVEL 6 - DATA MODIFICATION
-- INSERT
-- UPDATE
-- DELETE
-- ON CONFLICT
--
-- LEVEL 7 - TABLE MODIFICATION
-- ALTER TABLE
-- ADD COLUMN
-- DROP COLUMN
-- RENAME COLUMN
-- RENAME TABLE
-- ADD/DROP CONSTRAINT
--
-- LEVEL 8 - ADVANCED QUERIES
-- Subqueries
-- EXISTS
-- CTE
--
-- LEVEL 9 - DATABASE OBJECTS
-- Views
-- Indexes
--
-- LEVEL 10 - ADVANCED SQL
-- Window Functions
-- ROW_NUMBER
-- RANK
-- DENSE_RANK
-- LAG
-- LEAD
--
-- LEVEL 11 - DATABASE MANAGEMENT
-- Transactions
-- COMMIT
-- ROLLBACK
-- SAVEPOINT
-- EXPLAIN
-- EXPLAIN ANALYZE
--
-- ============================================================
--                    END OF PRACTICE
-- ============================================================

