CREATE DATABASE ss13;
USE ss13;

CREATE TABLE accounts(
	account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_name VARCHAR(50) NOT NULL,
    balance DECIMAL(10,2) NOT NULL
);
INSERT INTO accounts (account_name, balance) VALUES 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

DELIMITER //
CREATE PROCEDURE TransferMoney (
	IN from_account INT,
    IN to_account INT,
    IN amount DECIMAL(10,2)
)
BEGIN
	DECLARE current_balance DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Transaction failed' AS message;
	END;
    START TRANSACTION;
    SELECT balance INTO current_balance
    FROM accounts
    WHERE account_id = from_account
    FOR UPDATE;
    IF current_balance >= amount THEN
        UPDATE accounts
        SET balance = balance - amount
        WHERE account_id = from_account;

        UPDATE accounts
        SET balance = balance + amount
        WHERE account_id = to_account;

        COMMIT;
        SELECT 'Transaction successful' AS message;
    ELSE
        ROLLBACK;
        SELECT 'Insufficient balance' AS message;
    END IF;
END //
DELIMITER ;
CALL TransferMoney(1, 2, 100.00);
SELECT * FROM accounts