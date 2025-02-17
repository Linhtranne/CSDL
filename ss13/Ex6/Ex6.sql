USE session13;

CREATE TABLE enrollments_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    action VARCHAR(50),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

DELIMITER //

CREATE PROCEDURE register_course(
    p_student_name VARCHAR(50),
    p_course_name VARCHAR(100)
)
BEGIN
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_available_seats INT;

    START TRANSACTION;

    SELECT student_id INTO v_student_id FROM students 
    WHERE student_name = p_student_name;

    SELECT course_id, available_seats INTO v_course_id, v_available_seats FROM courses
    WHERE course_name = p_course_name;

    IF v_student_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student null!';
    END IF;

    IF v_course_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Subject null!';
    END IF;

    IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = v_student_id AND course_id = v_course_id) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error!';
    END IF;

    IF v_available_seats > 0 THEN
        INSERT INTO enrollments (student_id, course_id)
        VALUES (v_student_id, v_course_id);

        UPDATE courses
        SET available_seats = available_seats - 1
        WHERE course_id = v_course_id;

        INSERT INTO enrollments_history (student_id, course_id, action, timestamp)
        VALUES (v_student_id, v_course_id, 'REGISTERED', NOW());

        COMMIT;
    ELSE
        INSERT INTO enrollments_history (student_id, course_id, action, timestamp)
        VALUES (v_student_id, v_course_id, 'FAILED', NOW());

        ROLLBACK;
    END IF;
END //

DELIMITER ;

CALL register_course('Nguyễn Văn An', 'Cơ sở dữ liệu');

SELECT * FROM enrollments;
SELECT * FROM courses;
SELECT * FROM enrollments_history;
