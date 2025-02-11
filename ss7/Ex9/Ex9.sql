CREATE DATABASE TicketFilm;
USE TicketFilm;
CREATE TABLE tblPhim (
    PhimID INT PRIMARY KEY AUTO_INCREMENT,
    Ten_phim NVARCHAR(30),
    Loai_phim NVARCHAR(25),
    Thoi_gian INT
);

CREATE TABLE tblPhong (
    PhongID INT PRIMARY KEY AUTO_INCREMENT,
    Ten_phong NVARCHAR(20),
    Trang_thai TINYINT
);

CREATE TABLE tblGhe (
    GheID INT PRIMARY KEY AUTO_INCREMENT,
    PhongID INT,
    So_ghe VARCHAR(10),
    FOREIGN KEY (PhongID) REFERENCES tblPhong(PhongID) ON DELETE CASCADE
);

CREATE TABLE tblVe (
    PhimID INT,
    GheID INT,
    Ngay_chieu DATETIME,
    Trang_thai NVARCHAR(20),
    FOREIGN KEY (PhimID) REFERENCES tblPhim(PhimID) ON DELETE CASCADE,
    FOREIGN KEY (GheID) REFERENCES tblGhe(GheID) ON DELETE CASCADE
);
INSERT INTO tblPhim (Ten_phim, Loai_phim, Thoi_gian) VALUES
('Em bé Hà Nội', 'Tâm lý', 90),
('Nhiệm vụ bất khả thi', 'Hành động', 100),
('Dị nhân', 'Viễn tưởng', 90),
('Cuốn theo chiều gió', 'Tình cảm', 120);

INSERT INTO tblPhong (Ten_phong, Trang_thai) VALUES
('Phòng chiếu 1', 1),
('Phòng chiếu 2', 1),
('Phòng chiếu 3', 0);

INSERT INTO tblGhe (PhongID, So_ghe) VALUES
(1, 'A3'),
(1, 'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

INSERT INTO tblVe (PhimID, GheID, Ngay_chieu, Trang_thai) VALUES
(1, 1, '2008-10-20', 'Đã bán'),
(1, 3, '2008-11-20', 'Đã bán'),
(1, 4, '2008-12-23', 'Đã bán'),
(2, 1, '2009-02-14', 'Đã bán'),
(3, 1, '2009-02-14', 'Đã bán'),
(2, 5, '2009-03-08', 'Chưa bán'),
(2, 3, '2009-03-08', 'Chưa bán');

SELECT * FROM tblphim ORDER BY thoi_gian;  

-- 2  
SELECT ten_phim FROM tblphim ORDER BY thoi_gian DESC LIMIT 1;  

-- 3  
SELECT ten_phim FROM tblphim ORDER BY thoi_gian ASC LIMIT 1;  

-- 4  
SELECT so_ghe FROM tblghe WHERE so_ghe LIKE 'A%';  

-- 5  
ALTER TABLE tblphong MODIFY COLUMN trang_thai VARCHAR(25);  

-- 6  
DELIMITER //  
CREATE PROCEDURE updateandshowphong()  
BEGIN  
    UPDATE tblphong   
    SET trang_thai = CASE   
        WHEN trang_thai = '0' THEN 'đang sửa'  
        WHEN trang_thai = '1' THEN 'đang sử dụng'  
        ELSE 'unknown'  
    END;  
      
    SELECT * FROM tblphong;  
END //  
DELIMITER ;  
CALL updateandshowphong();  

-- 7  
SELECT ten_phim FROM tblphim WHERE LENGTH(ten_phim) > 15 AND LENGTH(ten_phim) < 25;  

-- 8  
SELECT CONCAT(ten_phong, ' - ', trang_thai) AS 'trạng thái phòng chiếu' FROM tblphong;  

-- 9  
CREATE VIEW tblrank AS  
SELECT ROW_NUMBER() OVER (ORDER BY ten_phim) AS stt, ten_phim, thoi_gian FROM tblphim;  

-- 10  
ALTER TABLE tblphim ADD COLUMN mo_ta NVARCHAR(255);  

-- 11  
UPDATE tblphim SET mo_ta = CONCAT('đây là film thể loại ', loai_phim);  
SELECT * FROM tblphim;  

-- 12  
UPDATE tblphim SET mo_ta = REPLACE(mo_ta, 'film', 'phim');  
SELECT * FROM tblphim;  

-- 13  
ALTER TABLE tblghe DROP FOREIGN KEY tblghe_ibfk_1;  
ALTER TABLE tblve DROP FOREIGN KEY tblve_ibfk_1;  
ALTER TABLE tblve DROP FOREIGN KEY tblve_ibfk_2;  

-- 14  
DELETE FROM tblghe;  

-- 15  
SELECT ngay_chieu, DATE_ADD(ngay_chieu, INTERVAL 5000 MINUTE) AS 'ngày chiếu +5000 phút' FROM tblve;  
