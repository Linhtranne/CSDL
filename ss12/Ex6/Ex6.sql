USE ss12;

CREATE TABLE budget_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);
DELIMITER //

DROP TRIGGER IF EXISTS after_update_budget_warning //

CREATE TRIGGER after_update_budget_warning
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    IF NEW.total_salary > NEW.budget THEN
        IF NOT EXISTS (
            SELECT 1 FROM budget_warnings 
            WHERE project_id = NEW.project_id 
            AND warning_message = 'Budget exceeded due to high salary'
        ) THEN
            INSERT INTO budget_warnings (project_id, warning_message)
            VALUES (NEW.project_id, 'Budget exceeded due to high salary');
        END IF;
    END IF;
END //

DELIMITER ;

DROP VIEW IF EXISTS ProjectOverview;
CREATE VIEW ProjectOverview AS
SELECT 
    p.project_id,
    p.name AS project_name,
    p.budget,
    p.total_salary,
    COALESCE(bw.warning_message, 'No warnings') AS warning_message
FROM projects p
LEFT JOIN budget_warnings bw ON p.project_id = bw.project_id;

INSERT INTO workers (name, project_id, salary) VALUES 
('Michael', 1, 6000.00),  -- Dự án 1 có thể vượt ngân sách
('Sarah', 2, 10000.00),   -- Dự án 2 có thể vượt ngân sách
('David', 3, 1000.00);    -- Dự án 3 không vượt ngân sách

SELECT * FROM budget_warnings;

SELECT * FROM ProjectOverview;
