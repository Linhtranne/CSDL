USE ss11;

CREATE INDEX idx_PhoneNumber ON Customers(PhoneNumber);

EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

CREATE INDEX Branch_Salary ON Employees(BranchID, Salary);

EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

CREATE UNIQUE INDEX Unique_Account_Customer ON Accounts(AccountID, CustomerID);

SHOW INDEXES FROM Customers;
SHOW INDEXES FROM Employees;
SHOW INDEXES FROM Accounts;
DROP INDEX PhoneNumber ON Customers;
DROP INDEX Branch_Salary ON Employees;
DROP INDEX Unique_Account_Customer ON Accounts;
