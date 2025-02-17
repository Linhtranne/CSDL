USE ss13;
CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

DELIMITER //

CREATE PROCEDURE PaySalary(IN p_emp_id INT)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_bank_status INT DEFAULT 1;
    START TRANSACTION;
    SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
    SELECT balance INTO v_balance FROM company_funds WHERE fund_id = 1 FOR UPDATE;
    IF v_balance < v_salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error';
        ROLLBACK;
    ELSE
        UPDATE company_funds SET balance = balance - v_salary WHERE fund_id = 1;
        INSERT INTO payroll (emp_id, salary, pay_date) 
        VALUES (p_emp_id, v_salary, CURDATE());
        IF v_bank_status = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error!';
            ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END //

DELIMITER ;

