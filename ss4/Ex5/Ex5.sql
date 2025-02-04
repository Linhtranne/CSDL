USE employee_management;
CREATE TABLE Employee (
    employee_id CHAR(4) PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    sex BIT NOT NULL CHECK (sex IN (0, 1)),
    base_salary INT NOT NULL CHECK (base_salary > 4000000), 
    phone_number CHAR(11) NOT NULL UNIQUE
);

INSERT INTO Employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number) 
VALUES 
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987868473'),
('E002', 'Đỗ Đức Long', '2004-12-01', 1, 3500000, '0923787673'),
('E003', 'Mai Thiên Linh', '2004-01-12', 0, 3500000, '0976734562'),
('E004', 'Nguyễn Ngọc Ánh', '2003-11-03', 0, 5000000, '0987327172'),
('E005', 'Phạm Minh Sơn', '2003-12-11', 1, 4000000, '0987263688'),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928876376');
