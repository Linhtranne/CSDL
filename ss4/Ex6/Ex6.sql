USE employee_management;
CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(50) NOT NULL
);
ALTER TABLE Employee
ADD COLUMN department_id INT NOT NULL,
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id) REFERENCES Department(department_id);

INSERT INTO Department (department_name, address) VALUES
('HR', 'Building A'),
('IT', 'Building B'),
('Finance', 'Building C'),
('Marketing', 'Building D'),
('Sales', 'Building E');

ALTER TABLE Employee DROP FOREIGN KEY fk_department;

ALTER TABLE Employee
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE CASCADE;

DELETE FROM Department WHERE department_id = 1;

UPDATE Department
SET department_name = 'Updated Department Name'
WHERE department_id = 1;

SELECT * FROM Employee;

SELECT * FROM Department;

