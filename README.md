# 📚 Library Management System — SQL Project

This project demonstrates the implementation of a **Library Management System** using SQL. It involves designing a relational database, managing records, executing complex queries, and using stored procedures to simulate real-world library operations.

---

## 🎯 Objectives of This Project

1. **Database Design and Setup**  
   Create and populate tables for:
   - Branches
   - Employees
   - Members
   - Books
   - Issued Status
   - Return Status

2. **CRUD Operations**  
   Perform **Create**, **Read**, **Update**, and **Delete** operations to manage book records, member details, and transaction history.

3. **CTAS (Create Table As Select)**  
   Use CTAS to create summary tables like:
   - Books issued count
   - Expensive books
   - Active members (issued books in the last 6 months)

4. **Advanced SQL Queries**  
   Develop queries to:
   - Identify overdue books
   - Calculate fines
   - Track branch performance
   - Retrieve employee and manager details
   - Find most active employees

5. **Stored Procedures** 🧠  
   Use stored procedures to automate library tasks:
   - `issue_book`: Checks book availability and issues it if available
   - `add_return_records`: Records book return and updates book status
   - These procedures simulate real transaction workflows and improve database modularity.

---

## 🗂️ Project Structure
- `01_Library_Management_System.sql` — Contains all `CREATE TABLE`, `ALTER`, and `FOREIGN KEY` constraints  
- `02_Library_Management_System.sql` — Includes all stored procedures, advanced queries, and reports  
- `insert_queries.sql` — Initial `INSERT INTO` statements for branches, books, members, etc.  
- `insert_queries2.sql` — Additional `INSERT` statements for extended data testing and exploration  
- `Library_Mngt_Project_EER.mwb` — MySQL Workbench EER diagram for the project database schema  


  
