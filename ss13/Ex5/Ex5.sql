USE ss13;
CREATE TABLE transaction_log(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message TEXT NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE transaction_log
ADD COLUMN last_pay_date DATE;
DELIMITER //
CREATE PROCEDURE PaySalary(
    IN p_emp_id INT
)
BEGIN
    DECLARE v_emp_salary DECIMAL(10,2);
    DECLARE v_comp_balance DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO transaction_log (log_message)
        VALUES (CONCAT('Salary payment failed for employee ID ', p_emp_id));
    END;

    START TRANSACTION;

    SELECT salary INTO v_emp_salary
    FROM employees
    WHERE emp_id = p_emp_id
    FOR UPDATE;

    IF v_emp_salary IS NULL THEN
        ROLLBACK;
        INSERT INTO transaction_log (log_message)
        VALUES (CONCAT('Employee ID ', p_emp_id, ' does not exist.'));
    END IF;

    SELECT balance INTO v_comp_balance
    FROM company_funds
    ORDER BY fund_id
    LIMIT 1
    FOR UPDATE;

    IF v_comp_balance < v_emp_salary THEN
        ROLLBACK;
        INSERT INTO transaction_log (log_message)
        VALUES (CONCAT('Insufficient funds for employee ID ', p_emp_id));
    ELSE

        UPDATE company_funds
        SET balance = balance - v_emp_salary
        WHERE fund_id = (SELECT fund_id FROM company_funds ORDER BY fund_id LIMIT 1);

        INSERT INTO payroll (emp_id, salary, pay_date)
        VALUES (p_emp_id, v_emp_salary, CURDATE());

        COMMIT;
        INSERT INTO transaction_log (log_message)
        VALUES (CONCAT('Trả lương thành công ', p_emp_id));
    END IF;
END //

DELIMITER ;

CALL PaySalary(1);
SELECT * from transaction_log

