USE ss12;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2) NOT NULL
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE project (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    emp_id INT,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

DELIMITER //

DROP TRIGGER IF EXISTS before_insert_employee //
CREATE TRIGGER before_insert_employee
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LỖI: LƯƠNG THẤP HƠN 500';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM departments WHERE dept_id = NEW.dept_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LỖI: PHÒNG BAN KHÔNG TỒN TẠI';
    END IF;

    IF (SELECT COUNT(*) FROM project p 
        JOIN employees e ON p.emp_id = e.emp_id
        WHERE e.dept_id = NEW.dept_id AND p.status <> 'Completed') = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LỖI: TẤT CẢ DỰ ÁN ĐÃ HOÀN THÀNH';
    END IF;
END //

DELIMITER ;

CREATE TABLE project_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES project(project_id)
);

CREATE TABLE dept_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

DELIMITER //

DROP TRIGGER IF EXISTS after_update_project_status //
CREATE TRIGGER after_update_project_status
AFTER UPDATE ON project
FOR EACH ROW
BEGIN
    DECLARE total_salary DECIMAL(15,2);
    DECLARE department_budget DECIMAL(15,2);

    IF NEW.status = 'Delayed' THEN
        INSERT INTO project_warnings (project_id, warning_message)
        VALUES (NEW.project_id, 'DỰ ÁN BỊ TRÌ HOÃN');
    END IF;

    IF NEW.status = 'Completed' THEN
        UPDATE project SET end_date = CURDATE()
        WHERE project_id = NEW.project_id;
        
        SELECT SUM(salary) INTO total_salary
        FROM employees
        WHERE dept_id = (SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id);
        
        SELECT budget INTO department_budget
        FROM departments
        WHERE dept_id = (SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id);

        IF total_salary > department_budget THEN
            INSERT INTO dept_warnings (dept_id, warning_message)
            VALUES ((SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id), 
                    'TỔNG LƯƠNG NHÂN VIÊN VƯỢT QUÁ NGÂN SÁCH CỦA PHÒNG BAN');
        END IF;
    END IF;
END //

DELIMITER ;

CREATE VIEW FullOverview AS
SELECT 
    e.emp_id,
    e.name AS employee_name,
    d.name AS department_name,
    CONCAT('$', FORMAT(e.salary, 2)) AS formatted_salary,
    p.name AS project_name,
    p.status AS project_status
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN project p ON e.emp_id = p.emp_id;

SELECT * FROM FullOverview;

INSERT INTO departments (name, manager, budget) 
VALUES 
    ('Human Resources', 'Alice Johnson', 50000.00),
    ('Engineering', 'Bob Smith', 150000.00),
    ('Marketing', 'Charlie Brown', 75000.00),
    ('Finance', 'David Wilson', 100000.00);

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Alice', 1, 400, '2023-07-01');

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Bob', 3, 1000, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Charlie', 2, 1500, '2023-07-01');

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('David', 1, 2000, '2023-07-01');

INSERT INTO project (name, emp_id, start_date, end_date, status) 
VALUES 
    ('Website Development', 4, '2023-01-15', '2023-06-30', 'Completed'),
    ('Mobile App', 2, '2023-03-01', NULL, 'In Progress'),
    ('Marketing Campaign', 3, '2023-05-10', NULL, 'Delayed'),
    ('Financial Analysis', 5, '2023-07-01', NULL, 'In Progress');

UPDATE project SET status = 'Delayed' WHERE project_id = 1;
UPDATE project SET status = 'Completed', end_date = NULL WHERE project_id = 2;
UPDATE project SET status = 'Completed' WHERE project_id = 3;
UPDATE project SET status = 'In Progress' WHERE project_id = 4;

SELECT * FROM FullOverview;
