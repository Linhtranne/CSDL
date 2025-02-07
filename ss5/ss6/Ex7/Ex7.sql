use ss6;
-- Tạo bảng students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Tạo bảng courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    fee DECIMAL(10, 2) NOT NULL
);

-- Tạo bảng enrollments
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
-- Thêm bản ghi vào bảng students
INSERT INTO students (name, email, phone)
VALUES
('Nguyen Van An', 'nguyenvanan@example.com', '0901234567'),
('Tran Thi Bich', 'tranthibich@example.com', '0912345678'),
('Le Van Cuong', 'levancuong@example.com', '0923456789'),
('Pham Minh Hoang', 'phamminhhoang@example.com', '0934567890'),
('Do Thi Ha', 'dothiha@example.com', '0945678901'),
('Hoang Quang Huy', 'hoangquanghuy@example.com', '0956789012');

-- Thêm bản ghi vào bảng cources
INSERT INTO courses (course_name, duration, fee)
VALUES
('Python Basics', 30, 300000),
('Web Development', 50, 1000000),
('Data Science', 40, 1500000);

-- Thêm bản ghi vào bảng enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2025-01-10'), 
(2, 2, '2025-01-11'), 
(3, 3, '2025-01-12'), 
(4, 1, '2025-01-13'), 
(5, 2, '2025-01-14'), 
(6, 2, '2025-01-10'), 
(2, 3, '2025-01-17'), 
(3, 1, '2025-01-11'), 
(4, 3, '2025-01-19'); 

SELECT 
s.student_id, 
s.name AS student_name, 
s.email, 
COUNT(e.course_id) AS total_courses, 
SUM(c.fee) AS total_fee
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY s.student_id, s.name, s.email
HAVING COUNT(e.course_id) > 1
ORDER BY total_fee DESC
LIMIT 5;

SELECT 
s.student_id, 
s.name AS student_name, 
c.course_name, 
c.fee, 
CASE 
	WHEN c.fee < 500000 THEN 'Low'
	WHEN c.fee BETWEEN 500000 AND 1000000 THEN 'Medium'
	ELSE 'High'
END AS fee_category,
e.enrollment_date
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY 
CASE 
	WHEN c.fee < 500000 THEN 1
	WHEN c.fee BETWEEN 500000 AND 1000000 THEN 2
	ELSE 3
END, 
s.name ASC;

SELECT 
c.course_name, 
c.fee, 
COUNT(e.student_id) AS total_students, 
SUM(c.fee) AS total_revenue
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name, c.fee
HAVING COUNT(e.student_id) > 1
ORDER BY total_students DESC,
total_revenue DESC
LIMIT 10;

