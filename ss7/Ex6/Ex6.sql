USE ss7;

SET sql_safe_updates=0;
DELETE FROM Timesheets;
DELETE FROM WorkReports;
DELETE FROM Projects;
DELETE FROM Employees;
DELETE FROM Departments;
-- Insert sample data into Departments table
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);

SELECT e.name, d.department_name 
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
ORDER BY e.name;

SELECT e.name, e.salary 
FROM employees e 
WHERE e.salary > 5000 
ORDER BY e.salary DESC;

SELECT e.name, SUM(t.hours_worked)
FROM employees e JOIN timesheets t
ON e.employee_id = t.employee_id
GROUP BY e.name;

SELECT d.department_name, AVG(e.salary) 
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
GROUP BY d.department_name;

SELECT p.project_name, SUM(t.hours_worked) 
FROM projects p JOIN timesheets t 
ON p.project_id = t.project_id
WHERE MONTH(work_date) = 2 AND YEAR(work_date) = 2025
GROUP BY p.project_name;

SELECT e.name, p.project_name, SUM(t.hours_worked)
FROM projects p JOIN timesheets t 
ON p.project_id = t.project_id
JOIN employees e 
ON e.employee_id = t.employee_id
GROUP BY e.name, p.project_name;

SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 1;

SELECT w.report_date, e.name, w.report_content
FROM WorkReports w JOIN employees e
ON w.employee_id = e.employee_id
ORDER BY w.report_date DESC
LIMIT 2 OFFSET 1;

SELECT w.report_date, e.name, COUNT(w.report_id) AS report_count
FROM WorkReports w JOIN employees e
ON w.employee_id = e.employee_id
WHERE w.report_content IS NOT NULL
AND w.report_date BETWEEN '2025-01-01' AND '2025-02-01'
GROUP BY w.report_date, e.name;

SELECT e.name, p.project_name, SUM(t.hours_worked) AS total_hours, 
ROUND(SUM(t.hours_worked) * ANY_VALUE(e.salary), 0) AS total_salary
FROM projects p JOIN timesheets t 
ON p.project_id = t.project_id
JOIN employees e 
ON e.employee_id = t.employee_id
GROUP BY e.name, p.project_name
HAVING SUM(t.hours_worked) > 5
ORDER BY total_salary;
