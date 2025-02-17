USE ss12;

DELIMITER //
DROP PROCEDURE IF EXISTS get_doctor_details //
CREATE PROCEDURE get_doctor_details(input_doctor_id INT)
BEGIN
    SELECT 
        d.name AS doctor_name, 
        d.specialization,
        COUNT(DISTINCT a.patient_id) AS total_patients,
        SUM(d.salary / 100) AS total_revenue,
        COUNT(p.prescription_id) AS total_medicines_prescribed
    FROM doctors d
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id AND a.status = 'completed'
    LEFT JOIN prescriptions p ON a.appointment_id = p.appointment_id
    WHERE d.doctor_id = input_doctor_id
    GROUP BY d.doctor_id;
END //

DELIMITER ;

CREATE TABLE cancellation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    log_message VARCHAR(255),
    log_date DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
);

CREATE TABLE appointment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    log_message VARCHAR(255) NOT NULL,
    log_date DATETIME NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
);

DELIMITER //

DROP TRIGGER IF EXISTS after_delete_appointment //
CREATE TRIGGER after_delete_appointment
AFTER DELETE ON appointments
FOR EACH ROW
BEGIN
    DELETE FROM prescriptions WHERE appointment_id = OLD.appointment_id;
    IF OLD.status = 'cancelled' THEN
        INSERT INTO cancellation_logs (appointment_id, log_message, log_date)
        VALUES (OLD.appointment_id, 'Cancelled appointment was deleted', NOW());
    END IF;
    IF OLD.status = 'completed' THEN
        INSERT INTO appointment_logs (appointment_id, log_message, log_date)
        VALUES (OLD.appointment_id, 'Completed appointment was deleted', NOW());
    END IF;
END //

DELIMITER ;

CREATE VIEW FullRevenueReport AS
SELECT 
    d.doctor_id,
    d.name AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(DISTINCT a.patient_id) AS total_patients,
    SUM(CASE WHEN a.status = 'completed' THEN d.salary ELSE 0 END) AS total_revenue,
    COUNT(p.prescription_id) AS total_medicines
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN prescriptions p ON a.appointment_id = p.appointment_id
GROUP BY d.doctor_id, d.name;
CALL get_doctor_details(1);
DELETE FROM appointments WHERE appointment_id = 3;
DELETE FROM appointments WHERE appointment_id = 2;

SELECT * FROM FullRevenueReport;
