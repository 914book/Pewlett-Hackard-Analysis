# Pewlett-Hackard-Analysis
## Technical Analysis Deliverable 1
### Number of Retiring Employees by Title : 33,118
### Three tables : titles, employees and salaries
####  *showing number of titles retiring - ret_titles
####  *number of employees with each title - unique_titles
####  *a list of current employees born between Jan 1, 1952 and Dec. 31, 1955
#### New Table : Deliverable 1 exported as csvs
#### Removed duplicates : New Table : Deliverable 1 no dups exported as csvs.

## Technical Analysis Deliverable 2
### Mentorship Eligibile : 1940
#### Two tables : Employees, titles
#### New Table : Deliverable 2 exported as mentorship.csv
#### Removed duplicates : New Table : Deliverable 2 no dups exported as csvs.
## SQL
--  deliverable 1: Number of Retiring Employees by Title
-- Number of Retiring Employees by Title
SELECT current_emp.emp_no,
	current_emp.first_name,
	current_emp.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
INTO ret_titles
FROM current_emp 
	INNER JOIN titles 
		ON (current_emp.emp_no = titles.emp_no)
ORDER BY current_emp.emp_no;

SELECT * FROM ret_titles

-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	to_date,
	title
INTO unique_titles
FROM
	(SELECT emp_no,
	first_name,
	last_name,
	to_date,
	title, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	ORDER BY to_date DESC) rn
	FROM ret_titles
	) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM unique_titles

-- Counting the number of each employee per title
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles
-- Creating a list of employees eligible for potential mentorship program
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship
FROM employees as e
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship


--Remove duplicates from deliverables 2
-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date,
 title
INTO deliverable2_no_dups
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM deliverable2
 ) tmp WHERE rn = 1
ORDER BY emp_no;

ERD MAP

Diagram Documentation

Departments
Field
Description
Type
Default
Other
dept_no

varchar

PK
dept_name

varchar


Employees
Field
Description
Type
Default
Other
emp_no

int

PK
birth_date

date


first_name

varchar


last_name

varchar


gender

varchar


hire_date

date


Managers
Field
Description
Type
Default
Other
dept_no

varchar

PK, FK
emp_no

int

PK, FK
from_date

date


to_date

date


Dept_emp
Field
Description
Type
Default
Other
emp_no

int

PK, FK
dept_no

varchar

PK, FK
from_date

date


to_date

date


Salaries
Field
Description
Type
Default
Other
emp_no

int

PK, FK
salary

int


from_date

date


to_date

date


Titles
Field
Description
Type
Default
Other
emp_no

int

PK, FK
title

varchar

PK
from_date

date

PK
to_date
