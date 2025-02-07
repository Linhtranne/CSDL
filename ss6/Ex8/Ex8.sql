use ss6;

SELECT e.student_id,
s.name AS student_name,
s.email,
c.course_name,
e.enrollment_date
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id IN (SELECT student_id FROM enrollments GROUP BY student_id HAVING COUNT(course_id) > 1)
ORDER BY e.student_id, e.enrollment_date;

SELECT s.name AS student_name,
s.email,
e.enrollment_date,
c.course_name,
c.fee
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.course_id IN (SELECT e2.course_id FROM enrollments e2 JOIN students s2 ON e2.student_id = s2.student_id WHERE s2.name = 'Nguyen Van An')
AND s.name <> 'Nguyen Van An'
ORDER BY c.course_name, e.enrollment_date;

SELECT 
c.course_name, 
c.duration, 
c.fee, 
COUNT(e.student_id) AS total_students
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.duration, c.fee
HAVING COUNT(e.student_id) > 2
ORDER BY total_students DESC;

SELECT 
s.student_id,
s.name AS student_name, 
s.email, 
SUM(c.fee) AS total_fee_paid, 
COUNT(e.course_id) AS courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY s.student_id, s.name, s.email
HAVING COUNT(e.course_id) >= 2
AND MIN(c.duration) > 30
ORDER BY total_fee_paid DESC;



