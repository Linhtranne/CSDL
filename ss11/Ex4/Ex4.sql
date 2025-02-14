USE ss11;

DELIMITER //

DROP PROCEDURE IF EXISTS UpdateSalaryByID //
CREATE PROCEDURE UpdateSalaryByID(
    IN Employee_ID INT,
    INOUT Current_Salary DECIMAL
)
BEGIN
    IF Current_Salary < 20000000 THEN
        SET Current_Salary = Current_Salary * 1.1;
    ELSE
        SET Current_Salary = Current_Salary * 1.05;
    END IF;
    
    UPDATE Employees
    SET Salary = Current_Salary
    WHERE EmployeeID = Employee_ID;
END //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS GetLoanAmountByCustomerID //
CREATE PROCEDURE GetLoanAmountByCustomerID(
    IN Customer_ID INT,
    OUT Total_Loan_Amount DECIMAL
)
BEGIN
    SELECT COALESCE(SUM(LoanAmount), 0) 
    INTO Total_Loan_Amount
    FROM Loans
    WHERE CustomerID = Customer_ID;
END //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS DeleteAccountIfLowBalance //
CREATE PROCEDURE DeleteAccountIfLowBalance(
    IN Account_ID INT
)
BEGIN
    DECLARE Account_Balance DECIMAL(15,2);

    SELECT Balance INTO Account_Balance 
    FROM Accounts 
    WHERE AccountID = Account_ID;

    IF Account_Balance IS NOT NULL THEN
        IF Account_Balance < 1000000 THEN
            DELETE FROM Accounts WHERE AccountID = Account_ID;
            SELECT 'Xóa thành công.' AS Message;
        ELSE
            SELECT 'Không thể xóa.' AS Message;
        END IF;
    ELSE
        SELECT 'Tài khoản không tồn tại.' AS Message;
    END IF;
END //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS TransferMoney
CREATE PROCEDURE TransferMoney(
    IN Sender_ID INT,
    IN Receiver_ID INT,
    INOUT Amount DECIMAL(15,2)
)
BEGIN
    DECLARE Sender_Balance DECIMAL(15,2);

    SELECT Balance INTO Sender_Balance 
    FROM Accounts 
    WHERE AccountID = Sender_ID;

    IF Sender_Balance IS NOT NULL THEN
        IF Sender_Balance >= Amount THEN
            UPDATE Accounts 
            SET Balance = Balance - Amount 
            WHERE AccountID = Sender_ID;

            UPDATE Accounts 
            SET Balance = Balance + Amount 
            WHERE AccountID = Receiver_ID;

            SELECT 'Giao dịch thành công.' AS Message;
        ELSE
            SET Amount = 0;
            SELECT 'Giao dịch thất bại' AS Message;
        END IF;
    ELSE
        SELECT 'Tài khoản không tồn tại.' AS Message;
    END IF;
END //
DELIMITER ;

SET @Salary = 18000000;  
CALL UpdateSalaryByID(4, @Salary);  
SELECT @Salary;

CALL GetLoanAmountByCustomerID(1, @Total_Loan_Amount);
SELECT @Total_Loan_Amount;

CALL DeleteAccountIfLowBalance(2);

SET @Amount = 2000000;
CALL TransferMoney(1, 3, @Amount);.
SELECT @Amount;

DROP PROCEDURE IF EXISTS UpdateSalaryByID;
DROP PROCEDURE IF EXISTS GetLoanAmountByCustomerID;
DROP PROCEDURE IF EXISTS DeleteAccountIfLowBalance;
DROP PROCEDURE IF EXISTS TransferMoney;
