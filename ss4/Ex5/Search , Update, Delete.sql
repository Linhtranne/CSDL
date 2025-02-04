USE employee_management;
SELECT employee_id, employee_name, date_of_birth, phone_number 
FROM Employee;
UPDATE Employee 
SET base_salary = base_salary * 1.1 
WHERE sex = 0;
DELETE FROM Employee 
WHERE YEAR(date_of_birth) = 2003;