USE ss9;
CREATE VIEW view_manager_summary AS
SELECT manager_id, COUNT(manager_id) as total_employees
FROM employees
GROUP BY manager_id;
SELECT * FROM view_manager_summary;

ALTER VIEW view_manager_summary AS
SELECT name, COUNT(manager_id) as total_employees
FROM employees
GROUP BY name;
SELECT * FROM view_manager_summary
  
SELECT e.name, v.total_employees  
FROM view_manager_summary v  
JOIN employees e ON e.manager_id = v.manager_id;  

