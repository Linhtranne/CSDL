USE ss14;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
) engine = 'InnoDB';

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    total_hours DECIMAL(5,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

CREATE TABLE salaries (
    employee_id INT PRIMARY KEY,
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
) ;

CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
DELIMITER //
CREATE TRIGGER check_phone_length_before_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.phone) != 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error phone';
    END IF;
END //
DELIMITER ;

CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER create_welcome_notification
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO notifications (employee_id, message)
    VALUES (NEW.employee_id, 'Chào mừng');
END //
DELIMITER ;

set autocommit = 0;
DELIMITER //
CREATE PROCEDURE AddNewEmployeeWithPhone(
    IN emp_name VARCHAR(255),
    IN emp_email VARCHAR(255),
    IN emp_phone VARCHAR(20),
    IN emp_hire_date DATE,
    IN emp_department_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    START TRANSACTION;
    IF (SELECT COUNT(*) FROM employees WHERE email = emp_email) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error Email';
    END IF;
    IF LENGTH(emp_phone) != 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error Phone';
    END IF;
    INSERT INTO employees (name, email, phone, hire_date, department_id)
		VALUES (emp_name, emp_email, emp_phone, emp_hire_date, emp_department_id);
    INSERT INTO notifications (employee_id, message)
		VALUES (LAST_INSERT_ID(), 'Welcome');
    COMMIT;
END //
DELIMITER ;

CALL AddNewEmployeeWithPhone('Nguyen Van A', 'nguyenvana@example.com', '0912345678', '2025-02-19', 1);
SELECT * FROM employees;
SELECT * FROM notifications;