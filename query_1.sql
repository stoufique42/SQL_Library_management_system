select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2: Update an Existing Member's Address
update members
set member_address = '125 main st'
where member_id = 'c101';
select * from members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
select * from issued_status
where issued_id = 'IS121';

delete from issued_status
where issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status
where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select 
	issued_emp_id, count(*)
	from issued_status
group by 1
having count(*) > 1;

-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_cnts
as
select 
	b.isbn,
	b.book_title,
	count(ist.issued_id) as no_issued
from books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1, 2;

select * from book_cnts;

-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:
select
	b.category,
	sum(b.rental_price),
	count(*)
from issued_status ist
join 
books b
on b.isbn = ist.issued_book_isbn
group by 1;

-- List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

insert into members(member_id, member_name, member_address, reg_date)
values
('C118', 'sam', '145 Main St', '2024-06-01'),
('C119', 'john', '135 Main St', '2024-05-01');

-- Task 10 List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as
select * from books
where rental_price > 7.00;

-- Task 12: Retrieve the List of Books Not Yet Returned
select * from issued_status as ist
left join 
return_status as rs
on rs.issued_id = ist.issued_id
where rs.return_id is null;