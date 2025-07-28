CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(10)
);

ALTER TABLE branch 
MODIFY COLUMN contact_no VARCHAR(20);

-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10) -- fk
            
);

-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);

-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(10),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);
ALTER TABLE books
MODIFY COLUMN category VARCHAR(30) ;

-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30), -- fk
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50), -- fk
            issued_emp_id VARCHAR(10) -- fk
           
);

-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50)
            
);

-- FOREIGN KEY 
ALTER TABLE issued_status
ADD CONSTRAINT fk_member 
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_book
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

-- PROJECT TASK 

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 
-- 'J.B. Lippincott & Co.')"

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher) 
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2: Update an Existing Member's Address

UPDATE members 
SET member_address= '125 Oak St'
WHERE member_id='C103';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id='IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee
 -- Objective: Select all books issued by the employee with emp_id = 'E101'.
 
 SELECT issued_book_name FROM issued_status
 WHERE issued_emp_id='E101' ;

-- Task 5: List Members Who Have Issued More Than One Book 

SELECT issued_emp_id, COUNT(issued_id) AS total_books_issued FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results,
-- each book and total book_issued_cnt**

CREATE TABLE book_cnt
AS
SELECT b.isbn, b.book_title, 
COUNT(ist.issued_id) AS no_issued 
FROM books b
JOIN issued_status ist ON b.isbn=ist.issued_book_isbn
GROUP BY b.isbn, b.book_title;

-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category='Classic' ;

-- Task 8: Find Total Rental Income by Category:

SELECT b.category, SUM(b.rental_price),
COUNT(*) AS no_issued 
FROM books b
JOIN issued_status ist ON b.isbn=ist.issued_book_isbn
GROUP BY 1
ORDER BY SUM(b.rental_price) DESC; 

-- TASK 9:List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT e1.emp_name, b.* , e2.emp_name AS manager
FROM employees e1
JOIN branch b ON e1.branch_id=b.branch_id
JOIN employees e2 ON e2.emp_id=b.manager_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books 
AS 
SELECT * FROM books 
WHERE rental_price>7.00;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT DISTINCT ist.issued_book_name
FROM issued_status ist 
LEFT JOIN return_status rs
ON ist.issued_id=rs.issued_id 
WHERE rs.return_id IS NULL;















