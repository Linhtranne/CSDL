USE customer_mangement;

CREATE TABLE CUSTOMER (
    CUSTOMER_ID INT AUTO_INCREMENT PRIMARY KEY,
    CUSTOMER_NAME VARCHAR(50) NOT NULL,         
    BIRTHDAY DATE NOT NULL,                    
    SEX BIT NOT NULL,
    JOB VARCHAR(50),
    PHONE_NUMBER CHAR(11) NOT NULL UNIQUE,
    EMAIL VARCHAR(100) NOT NULL UNIQUE,
    ADDRESS VARCHAR(255) NOT NULL 
);

INSERT INTO Customer (customer_name, birthday, sex, job, phone_number, email, address) VALUES
('Nguyễn Văn A', '2001-05-15', 1, 'Kỹ sư', '0111111111', 'nva@gmail.com', 'A'),
('Trần Thị B', '1999-08-20', 0, 'Giáo viên', '022222222', 'ttb@gmail.com', 'B'),
('Lê Minh C', '2002-11-05', 1, 'Sinh viên', '0333333333', 'lmc@gmail.com', 'C'),
('Hoàng Thị D', '1998-03-10', 0, NULL, '04444444444', 'htd@gmail.com', 'D'),
('Phạm Văn E', '1995-12-25', 1, 'Bác sĩ', '055555555', 'pve@gmail.com', 'E'),
('Đỗ Thị F', '2000-07-30', 0, 'Kế toán', '0666666666', 'dtf@gmail.com', 'F'),
('Nguyễn Quang N', '2004-01-11', 1, 'Học sinh', '077777777', 'nqn@gmail.com', 'G'),
('Lý Thị H', '2003-06-15', 0, NULL, '08888888888', 'lth@gmail.com', 'H'),
('Ngô Văn K', '1997-09-25', 1, 'Lập trình viên', '00000000000', 'nvk@gmail.com', 'I'),
('Phạm Văn L', '1996-04-18', 1, 'Luật sư', '0999999999', 'pml@gmail.com', 'K');