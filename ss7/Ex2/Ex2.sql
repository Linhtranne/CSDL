USE ss7;
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL
);

CREATE TABLE Timesheets (
    timesheet_id INT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    hours_worked DECIMAL(5, 2),
    entry_date DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

CREATE TABLE WorkReports (
    report_id INT PRIMARY KEY,
    employee_id INT,
    report_date DATE NOT NULL,
    report_content TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

INSERT INTO Departments (department_id, department_name) VALUES 
(1, 'Human Resources'),
(2, 'Development');

-- Thêm dữ liệu vào bảng Employees
INSERT INTO Employees (employee_id, name, department_id, salary) VALUES 
(101, 'Nguyen Van A', 1, 50000.00),
(102, 'Tran Thi B', 2, 70000.00);

INSERT INTO Projects (project_id, project_name, start_date) VALUES 
(201, 'Project Alpha', '2025-01-01'),
(202, 'Project Beta', '2025-02-01');

INSERT INTO Timesheets (timesheet_id, employee_id, project_id, hours_worked, entry_date) VALUES 
(301, 101, 201, 8.5, '2025-01-15'),
(302, 102, 202, 7.0, '2025-01-16');

INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES 
(401, 101, '2025-01-20', 'Completed initial project setup.'),
(402, 102, '2025-01-21', 'Resolved major system bug.');

UPDATE Projects
SET project_name = "Project Garma"
WHERE project_id = 202;

DELETE FROM WorkReports WHERE employee_id = 102;
DELETE FROM Timesheets WHERE employee_id = 102;
DELETE FROM Employees WHERE employee_id = 102;
