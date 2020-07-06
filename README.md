# Pewlett-Hackard-Analysis
## Technical Analysis Deliverable 1
### Number of Retiring Employees by Title : 90,398
### Three tables : titles, employees and salaries
####  *showing number of titles retiring - 
####  *number of employees with each title
####  *a list of current employees born between Jan 1, 1952 and Dec. 31, 1955
#### New Table : Deliverable 1 exported as csvs
#### Removed duplicates : New Table : Deliverable 1 no dups exported as csvs.

## Technical Analysis Deliverable 2
### Mentorship Eligibile : 1940
#### Two tables : Employees, titles
#### New Table : Deliverable 2 exported as csvs
#### Removed duplicates : New Table : Deliverable 2 no dups exported as csvs.
## SQL
--  deliverable 1: Number of Retiring Employees by Title
SELECT e.emp_no,
	e.first_name,
    e.last_name,
	s.salary,
	s.from_date,
	ti.title
INTO deliverable1
FROM employees as e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY ti.title

--deliverable1 no dups
SELECT emp_no,
 first_name,
 last_name,
 salary,
 title
--INTO deliverable1_no_dups
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 salary,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM deliverable1
 ) tmp WHERE rn = 1
ORDER BY emp_no;

--deliverable 2 : Mentorship Eligibility
SELECT e.emp_no,
       e.first_name,
	   e.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO deliverable2	   
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31');

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
