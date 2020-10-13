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
