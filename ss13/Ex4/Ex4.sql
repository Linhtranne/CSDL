USE ss13;
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_name) VALUES ('Nguyễn Văn An'), ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats) VALUES 
('Lập trình C', 25), 
('Cơ sở dữ liệu', 22);
DELIMITER //

CREATE PROCEDURE EnrollStudent(
    IN p_student_name VARCHAR(50),
    IN p_course_name VARCHAR(100)
)
BEGIN
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_available_seats INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transaction failed.' AS message;
    END;

    START TRANSACTION;

    SELECT student_id INTO v_student_id
    FROM students
    WHERE student_name = p_student_name
    LIMIT 1;

    IF v_student_id IS NULL THEN
        ROLLBACK;
        SELECT CONCAT('Error: Student ', p_student_name, ' does not exist.') AS message;

    END IF;
    SELECT course_id, available_seats INTO v_course_id, v_available_seats
    FROM courses
    WHERE course_name = p_course_name
    LIMIT 1
    FOR UPDATE;

    IF v_course_id IS NULL THEN
        ROLLBACK;
        SELECT CONCAT('Error: Course ', p_course_name, ' does not exist.') AS message;
    END IF;

    IF v_available_seats <= 0 THEN
        ROLLBACK;
        SELECT CONCAT('Error: No available seats in ', p_course_name) AS message;
    ELSE
        INSERT INTO enrollments (student_id, course_id)
        VALUES (v_student_id, v_course_id);

        UPDATE courses
        SET available_seats = available_seats - 1
        WHERE course_id = v_course_id;

        COMMIT;
        SELECT CONCAT('Success: ', p_student_name, ' has been enrolled in ', p_course_name) AS message;
    END IF;
END //
DELIMITER ;

