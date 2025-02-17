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

CREATE TABLE salary_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10, 2) NOT NULL,
    new_salary DECIMAL(10, 2) NOT NULL,
    change_date DATETIME NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE salary_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    warning_date DATETIME NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

DELIMITER //

CREATE TRIGGER after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN

    INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
    VALUES (NEW.emp_id, OLD.salary, NEW.salary, NOW());

    IF NEW.salary < OLD.salary * 0.7 THEN
        INSERT INTO salary_warnings (emp_id, warning_message, warning_date)
        VALUES (NEW.emp_id, 'Salary decreased by more than 30%', NOW());
    END IF;

    IF NEW.salary > OLD.salary * 1.5 THEN
        UPDATE employees
        SET salary = OLD.salary * 1.5
        WHERE emp_id = NEW.emp_id;

        INSERT INTO salary_warnings (emp_id, warning_message, warning_date)
        VALUES (NEW.emp_id, 'Salary increased above allowed threshold', NOW());
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER check_project_constraints
AFTER INSERT ON project
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM project WHERE emp_id = NEW.emp_id AND status = 'in progress') = 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nhân viên đang tham gia 3 dự án đang hoạt động';
    END IF;

    IF NEW.status = 'in progress' AND NEW.start_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày bắt đầu dự án lớn hơn ngày hiện tại';
    END IF;
END //

DELIMITER ;

CREATE VIEW PerformanceOverview AS
SELECT 
    p.project_id,
    p.name AS project_name,
    COUNT(e.emp_id) AS employee_count,
    DATEDIFF(p.end_date, p.start_date) AS total_days,
    p.status
FROM project p
LEFT JOIN employees e ON p.emp_id = e.emp_id
GROUP BY p.project_id, p.name, p.start_date, p.end_date, p.status;

UPDATE employees 
SET salary = salary * 0.5 
WHERE emp_id = 1; 

UPDATE employees
SET salary = salary * 2
WHERE emp_id = 2; 

INSERT INTO departments (name, manager, budget) 
VALUES 
    ('Human Resources', 'Alice Johnson', 50000.00),
    ('Engineering', 'Bob Smith', 150000.00),
    ('Marketing', 'Charlie Brown', 75000.00),
    ('Finance', 'David Wilson', 100000.00);

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES 
    ('Alice', 1, 400, '2023-07-01'), 
    ('Bob', 3, 1000, '2023-07-01'), 
    ('Charlie', 2, 1500, '2023-07-01'),
    ('David', 1, 2000, '2023-07-01');

INSERT INTO project (name, emp_id, start_date, status) 
VALUES 
    ('New Project 1', 1, CURDATE(), 'in progress'),
    ('New Project 2', 1, CURDATE(), 'in progress'),
    ('New Project 3', 1, CURDATE(), 'in progress'),
    ('New Project 4', 1, CURDATE(), 'in progress'); 

INSERT INTO project (name, emp_id, start_date, status) 
VALUES ('Future Project', 2, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'in progress');

SELECT * FROM PerformanceOverview;
