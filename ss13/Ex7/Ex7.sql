USE ss13;
CREATE TABLE Bank(
	bank_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_name VARCHAR(255) NOT NULL,
    status ENUM('ACTIVE','ERROR') NOT NULL DEFAULT 'ACTIVE'
);

INSERT INTO banks (bank_id, bank_name, status) VALUES 

(1,'VietinBank', 'ACTIVE'),  
(2,'Sacombank', 'ERROR'),    
(3, 'Agribank', 'ACTIVE');
ALTER TABLE company_funds
ADD COLUMN bank_id INT NOT NULL,
ADD CONSTRAINT fk_company_funds_bank FOREIGN KEY (bank_id) REFERENCES banks(bank_id);

UPDATE company_funds SET bank_id = 1 WHERE balance = 50000.00;
INSERT INTO company_funds (balance, bank_id) VALUES (45000.00,2);

DELIMITER //

CREATE TRIGGER check_bank_status
BEFORE INSERT ON payroll
FOR EACH ROW
BEGIN
    DECLARE bank_status ENUM('ACTIVE', 'ERROR');

    SELECT STATUS INTO bank_status
    FROM company_funds
    WHERE bank_id = (
		SELECT bank_id FROM company_funds 
        WHERE fund_id = NEW.fund_id 
        LIMIT 1
	);

    IF bank_status = 'error' THEN	
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'error!';
    END IF;
END //

DELIMITER ;
DELIMITER //
CREATE PROCEDURE transferSalary(
IN p_emp_id INT
)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_bank_status ENUM('ACTIVE', 'ERROR');
    DECLARE v_fund_id INT;
    
    START TRANSACTION;

    SELECT salary INTO v_salary 
    FROM employees 
    WHERE emp_id = p_emp_id 
    LIMIT 1;
    
    IF v_salary IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error';
    END IF;

    SELECT fund_id, balance, b.bank_id INTO v_fund_id, v_balance, v_bank_status
    FROM company_funds c
    JOIN banks b ON c.bank_id = b.bank_id
    LIMIT 1;

    IF v_bank_status = 'error' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error';
    END IF;

    IF v_balance < v_salary THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error';
    END IF;

    UPDATE company_funds 
    SET balance = balance - v_salary 
    WHERE fund_id = v_fund_id;

    INSERT INTO payroll (emp_id, salary, pay_date) 
    VALUES (p_emp_id, v_salary, CURDATE());
    
    UPDATE employees 
    SET last_pay_date = NOW() 
    WHERE emp_id = p_emp_id;

    INSERT INTO transaction_log (emp_id, log_message) 
    VALUES (p_emp_id, 'Lương đã được chuyển thành công');

    COMMIT;
END //

DELIMITER ;

CALL transferSalary(2);
