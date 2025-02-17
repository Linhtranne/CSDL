USE ss12;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('male', 'female') NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medicine_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    notes VARCHAR(255) NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);
CREATE TABLE patient_error_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100),
    phone_number VARCHAR(15),
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //

DROP TRIGGER IF EXISTS before_insert_patient //
CREATE TRIGGER before_insert_patient
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    DECLARE patient_exists INT;

    SELECT COUNT(*) INTO patient_exists 
    FROM patients 
    WHERE name = NEW.name AND dob = NEW.dob;

    IF patient_exists > 0 THEN
        INSERT INTO patient_error_log (patient_name, phone_number, error_message)
        VALUES (NEW.name, NEW.phone, 'bệnh nhân đã tồn tại');
        
        -- CHẶN THÊM DỮ LIỆU BẰNG CÁCH NÉM LỖI
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'bệnh nhân đã tồn tại trong hệ thống!';
    END IF;
END //

DELIMITER ;

INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '1234567890');

INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '0987654321');
DELIMITER //

DROP TRIGGER IF EXISTS check_phone_number_format //
CREATE TRIGGER check_phone_number_format
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    IF NEW.phone NOT REGEXP '^[0-9]{10}$' THEN
        -- GHI LỖI VÀO BẢNG patient_error_log
        INSERT INTO patient_error_log (patient_name, phone_number, error_message)
        VALUES (NEW.name, NEW.phone, 'số điện thoại không hợp lệ!');

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'số điện thoại không hợp lệ!';
    END IF;
END //

DELIMITER ;

INSERT INTO patients (name, dob, gender, phone) VALUES
('Alice Smith', '1985-06-15', 'Female', '1234567895'),
('Bob Johnson', '1990-02-25', 'Male', '2345678901'),
('Carol Williams', '1975-03-10', 'Female', '3456789012'),
('Dave Brown', '1992-09-05', 'Male', '4567890abc'),
('Eve Davis', '1980-12-30', 'Female', '56789xyz'),
('Eve', '1980-12-13', 'Female', '56789');

SELECT * FROM patient_error_log;
DELIMITER //

DROP PROCEDURE IF EXISTS update_appointment_status //
CREATE PROCEDURE update_appointment_status(
    p_appointment_id INT,
    p_status ENUM('scheduled', 'completed', 'cancelled')
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM appointments WHERE appointment_id = p_appointment_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'cuộc hẹn không tồn tại!';
    ELSE
        UPDATE appointments
        SET status = p_status
        WHERE appointment_id = p_appointment_id;
    END IF;
END //
DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS update_status_after_prescription_insert //
CREATE TRIGGER update_status_after_prescription_insert
AFTER INSERT ON prescriptions
FOR EACH ROW
BEGIN
    CALL update_appointment_status(NEW.appointment_id, 'completed');
END //

DELIMITER ;

INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. John Smith', 'Cardiology', '1234567890', 5000.00);
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. Alice Brown', 'Neurology', '0987654321', 6000.00);
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-15 09:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 2, '2025-02-16 10:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-17 14:00:00', 'Scheduled');

SELECT * FROM appointments;
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, duration, notes) 
VALUES (1, 'Paracetamol', '500mg', '5 days', 'Take one tablet every 6 hours');

SELECT * FROM appointments;
