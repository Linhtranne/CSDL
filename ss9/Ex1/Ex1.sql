CREATE DATABASE ss9;
USE ss9;
-- Tạo bảng employee
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2) NOT NULL,
    manager_id INT NULL
);
-- Thêm dữ liệu vào bảng
INSERT INTO employees (name, department, salary, manager_id) VALUES
('Alice', 'Sales', 6000, NULL),         
('Bob', 'Marketing', 7000, NULL),     
('Charlie', 'Sales', 5500, 1),         
('David', 'Marketing', 5800, 2),       
('Eva', 'HR', 5000, 3),                
('Frank', 'IT', 4500, 1),              
('Grace', 'Sales', 7000, 3),           
('Hannah', 'Marketing', 5200, 2),     
('Ian', 'IT', 6800, 3),               
('Jack', 'Finance', 3000, 1);

CREATE VIEW view_high_salary_employees AS
SELECT employee_id, name, salary
FROM employees
WHERE salary > 5000;

SELECT *
FROM view_high_salary_employees;

INSERT INTO employees (name, department, salary, manager_id) VALUES
('Jack', 'Finance', 5000, 1);
SELECT *
FROM view_high_salary_employees;
	
SET sql_safe_updates = 0;
DELETE FROM employees WHERE name = "Jack";
SELECT *
FROM view_high_salary_employees;