-- Library Mangement Project (2)

/* 
Task 13: Identify Members with Overdue Books
 Write a query to identify members who have overdue books (assume a 30-day return period).
 Display the member's_id, member's name, book title, issue date, and days overdue. 
 */ 

SELECT 
    ist.issued_member_id, 
    m.member_name, 
    b.book_title, 
    ist.issued_date,
	DATEDIFF(CURRENT_DATE(), ist.issued_date) AS overdue
FROM issued_status ist
    JOIN members m ON ist.issued_member_id=m.member_id 
    JOIN books b ON ist.issued_book_isbn=b.isbn
    LEFT JOIN return_status rt ON ist.issued_id=rt.issued_id
WHERE rt.return_date IS NULL
AND DATEDIFF(CURRENT_DATE(), ist.issued_date)>30
ORDER BY 1 ;

/*
Task 14: Update Book Status on Return: Write a query to update the status of books in the 
 books table to "Yes" when they are returned (based on entries in the return_status table). 
 */

SELECT * FROM books 
where isbn= '978-0-451-52994-2';

UPDATE books 
SET status='no'
where isbn= '978-0-451-52994-2';

INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
VALUES 
('RS125', 'IS130', current_date, 'Good');

SELECT * FROM return_status;
UPDATE books 
SET status='yes'
where isbn= '978-0-451-52994-2';
SELECT * FROM books 
WHERE isbn='978-0-451-52994-2';

-- STORE PROCEDURES

DELIMITER $$

CREATE PROCEDURE add_return_records (
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(15)
)
BEGIN
    DECLARE v_isbn VARCHAR(25);

    -- Insert the return record
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- Get the ISBN for the issued book
    SELECT issued_book_isbn
      INTO v_isbn
      FROM issued_status
     WHERE issued_id = p_issued_id;

    -- Update book status to 'yes'
    UPDATE books
       SET status = 'yes'
     WHERE isbn = v_isbn;

END$$

DELIMITER ;

-- calling function
CALL add_return_records('RS140','IS125','Good');

CALL add_return_records('RS141','IS153','Good');


/* Task 15: CTAS: Create a Table of Active Members: Use the CREATE TABLE AS (CTAS) statement to create a new table
 active_members containing members who have issued at least one book in the last 6 months. */
 
CREATE TABLE active_members
 AS
 SELECT issued_member_id 
 FROM issued_status
 WHERE issued_date > current_date - INTERVAL 6 month;
 
/* Task 16: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, 
number of books processed, and their branch.*/

SELECT e.emp_name,
       e.branch_id,
       COUNT(ist.issued_emp_id) AS books_processed
FROM employees e 
JOIN issued_status ist ON e.emp_id=ist.issued_emp_id
GROUP BY e.emp_name, e.branch_id 
ORDER BY books_processed DESC
LIMIT 3;

/* Task 17: Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter.
 The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be
 issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), 
 the procedure should return an error message indicating that the book is currently not available. */

DELIMITER $$

CREATE PROCEDURE issue_book (
  IN p_issued_id VARCHAR(10),
  IN p_member_id VARCHAR(10),
  IN p_issued_book_isbn VARCHAR(25),
  IN p_issued_emp_id VARCHAR(10)
)
BEGIN 
  
  DECLARE v_status VARCHAR(15);
   
   -- CHECKING IF THE BOOK IS AVAILABLE 
   SELECT status 
     INTO v_status
   FROM books 
   WHERE isbn=p_issued_book_isbn;
   
IF v_status='yes' THEN 
   INSERT INTO issued_status (issued_id, issued_member_id,issued_date,issued_book_isbn,issued_emp_id)
   VALUES (p_issued_id, p_member_id , current_date, p_issued_book_isbn ,p_issued_emp_id) ;
   
   -- Update book status to 'no'
    UPDATE books
       SET status = 'no'
     WHERE isbn = p_issued_book_isbn;

  SELECT CONCAT('Book records added successfully for book isbn : ', p_issued_book_isbn) AS message;

ELSE
	
  SELECT CONCAT('Sorry to inform you the book you have requested is unavailable book_isbn: ', p_issued_book_isbn) 
  AS message;
    
END IF ;
END$$

DELIMITER ;

-- testing procedure
-- 978-0-553-29698-2 -yes
-- 978-0-375-41398-8 -no

CALL issue_book('IS160','C108','978-0-553-29698-2','E104');

CALL issue_book('IS161','C109','978-0-375-41398-8','E105');

SELECT * FROM books WHERE isbn='978-0-375-41398-8';

/* Task 18:Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals. */

SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

/* query to identify overdue books and calculate fines.
Description: Write a query that lists each member and the books they have issued but not returned within 30 days. 
The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. */

SELECT 
    ist.issued_member_id, 
    m.member_name, 
    b.book_title, 
    ist.issued_date,
    DATEDIFF(CURRENT_DATE(), ist.issued_date) AS days_overdue,
    (DATEDIFF(CURRENT_DATE(), ist.issued_date) - 30) * 0.50 AS total_fine
FROM issued_status ist
    JOIN members m ON ist.issued_member_id = m.member_id 
    JOIN books b ON ist.issued_book_isbn = b.isbn
    LEFT JOIN return_status rt ON ist.issued_id = rt.issued_id
WHERE rt.return_date IS NULL
  AND DATEDIFF(CURRENT_DATE(), ist.issued_date) > 30
ORDER BY ist.issued_member_id;


