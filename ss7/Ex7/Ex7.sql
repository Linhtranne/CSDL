CREATE TABLE Student (
    RN INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL UNIQUE,
    Age TINYINT NOT NULL
);

-- Tạo bảng Test (Bài kiểm tra)
CREATE TABLE Test (
    TestID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL UNIQUE
);

-- Tạo bảng StudentTest (Bảng điểm sinh viên)
CREATE TABLE StudentTest (
    RN INT NOT NULL,
    TestID INT NOT NULL,
    Date DATE,
    Mark FLOAT,
    PRIMARY KEY(RN, TestID),
    FOREIGN KEY(RN) REFERENCES Student(RN),
    FOREIGN KEY(TestID) REFERENCES Test(TestID)
);

-- Thêm ràng buộc UNIQUE vào bảng Student và Test
ALTER TABLE Student ADD CONSTRAINT UniqueNames UNIQUE (Name);
ALTER TABLE Test ADD CONSTRAINT UniqueTestNames UNIQUE (Name);

-- Thêm ràng buộc UNIQUE cho cặp (RN, TestID) trong bảng StudentTest
ALTER TABLE StudentTest ADD CONSTRAINT RNTestIDUnique UNIQUE KEY (RN, TestID);

-- Thêm cột Status vào bảng Student
ALTER TABLE Student ADD COLUMN Status VARCHAR(10); 

-- Thêm ràng buộc xóa dữ liệu liên quan khi sinh viên hoặc bài kiểm tra bị xóa
ALTER TABLE StudentTest DROP FOREIGN KEY StudentTest_ibfk_1;
ALTER TABLE StudentTest ADD CONSTRAINT StudentTest_ibfk_1 FOREIGN KEY (RN) REFERENCES Student(RN) ON DELETE CASCADE;
ALTER TABLE StudentTest DROP FOREIGN KEY StudentTest_ibfk_2;
ALTER TABLE StudentTest ADD CONSTRAINT StudentTest_ibfk_2 FOREIGN KEY (TestID) REFERENCES Test(TestID) ON DELETE CASCADE;

-- Chèn dữ liệu vào bảng Student
INSERT INTO Student (RN, Name, Age) VALUES 
(1, 'Nguyen Hong Ha', 20),
(2, 'Trung Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

-- Chèn dữ liệu vào bảng Test
INSERT INTO Test (TestID, Name) VALUES 
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

-- Chèn dữ liệu vào bảng StudentTest
INSERT INTO StudentTest (RN, TestID, Date, Mark) 
VALUES 
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 2, '2006-07-18', 1);

SELECT s.name, st.testid AS mathi, s.age, st.date, st.mark 
FROM student s 
JOIN studenttest st ON s.rn = st.rn 
ORDER BY st.mark DESC;

SELECT s.name, s.rn, s.age 
FROM student s 
LEFT JOIN studenttest st ON s.rn = st.rn 
WHERE st.rn IS NULL;

SELECT s.name, s.rn, s.age, st.testid AS mathi, st.mark 
FROM student s 
JOIN studenttest st ON s.rn = st.rn 
WHERE st.mark < 5;

SELECT s.name, ROUND(AVG(st.mark), 2) AS averagemark
FROM student s 
JOIN studenttest st ON s.rn = st.rn 
GROUP BY s.name
ORDER BY averagemark DESC;

SELECT s.name, ROUND(AVG(st.mark), 2) AS averagemark
FROM student s 
JOIN studenttest st ON s.rn = st.rn 
GROUP BY s.name 
ORDER BY averagemark DESC 
LIMIT 1;

SELECT st.testid, MAX(st.mark) AS maxmark
FROM studenttest st 
GROUP BY st.testid 
ORDER BY maxmark DESC;

UPDATE student 
SET age = age + 1;

ALTER TABLE student ADD COLUMN status VARCHAR(10); -- THÊM CỘT NẾU CHƯA CÓ
UPDATE student 
SET status = CASE 
    WHEN age < 30 THEN 'young' 
    ELSE 'old' 
END;

SELECT * FROM studenttest ORDER BY date ASC;

SELECT s.name, s.rn, s.age, st.mark 
FROM student s 
JOIN studenttest st ON s.rn = st.rn 
WHERE s.name LIKE 'T%' AND st.mark > 4.5;

SELECT s.name, s.age, st.mark 
FROM student s 
JOIN studenttest st ON s.rn = st.rn 
ORDER BY s.name, s.age, st.mark ASC;

DELETE FROM test 
WHERE NOT EXISTS (SELECT 1 FROM studenttest st WHERE st.testid = test.testid);

DELETE FROM studenttest WHERE mark < 5;
