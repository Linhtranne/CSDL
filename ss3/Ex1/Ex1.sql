USE linhtranne;
CREATE TABLE STUDENT (
	STUDENT_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    STUDENT_NAME VARCHAR(255) NOT NULL,
    AGE INT NOT NULL CHECK(AGE > 18),
    GENDER VARCHAR(10) NOT NULL CHECK(GENDER IN ('Male', 'Female', 'Other')),
	REGISTRATION_DATE DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
);

INSERT INTO STUDENT (STUDENT_NAME, AGE, GENDER)
VALUES
	('NGUYEN VAN A', 20, 'Male'),
	('LE THI B', 20, 'Female'),
	('TRAN VAN C', 20, 'Male'),
	('PHAM THI D', 20, 'Female')

