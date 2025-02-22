CREATE TABLE EMPLOYEES (
	EMPLOYEE_ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) NOT NULL UNIQUE,
	DEPARTMENT VARCHAR(100) NOT NULL,
    SALARY DECIMAL(10,2) CHECK(SALARY > 0) NOT NULL
);

INSERT INTO EMPLOYEES (NAME, EMAIL, DEPARTMENT, SALARY) 
VALUES
	('NGUYEN VAN A', 'NGUYENVANA@EXAMPLE.COM', 'Sales', 50000), 
	('LE THI B', 'LETHIB@EXAMPLE.COM', 'IT', 60000.00), 
	('TRAN VAN C', 'TRANVANC@EXAMPLE.COM', 'HR', 45000), 
	('PHAM THI D', 'PHAMTHID@EXAMPLE.COM', 'Marketing', 55000);

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT = 'Sales';
