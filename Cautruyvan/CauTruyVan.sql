-- 1.
USE QuanLyDiemSV;
SELECT MaSV, HoSV, TenSV, HocBong
FROM DMSV
ORDER BY MaSV;

-- 2.
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, Phai, NgaySinh
FROM DMSV
ORDER BY Phai;

-- 3.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh, HocBong
FROM DMSV
ORDER BY NgaySinh ASC, HocBong DESC;

-- 4.
SELECT MaMH, TenMH, SoTiet
FROM DMMH
WHERE TenMH LIKE 'T%';

-- 5.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh, Phai
FROM DMSV
WHERE TenSV LIKE '%I';

-- 6.
SELECT MaKhoa, TenKhoa
FROM DMKhoa
WHERE SUBSTRING(TenKhoa, 2, 1) = 'N';

-- 7.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen
FROM DMSV
WHERE HoSV LIKE '%Thị%';

-- 8.
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, HocBong
FROM DMSV
WHERE HocBong > 100000
ORDER BY MaKhoa DESC;

-- 9.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, NoiSinh, HocBong
FROM DMSV
WHERE HocBong >= 150000 AND NoiSinh = 'Hà Nội';

-- 10.
SELECT MaSV, MaKhoa, Phai
FROM DMSV
WHERE MaKhoa IN ('AV', 'VL');

-- 11.
SELECT MaSV, NgaySinh, NoiSinh, HocBong
FROM DMSV
WHERE NgaySinh BETWEEN '1991-01-01' AND '1992-06-05';

-- 12. 
SELECT MaSV, NgaySinh, Phai, MaKhoa
FROM DMSV
WHERE HocBong BETWEEN 80000 AND 150000;

-- 13.
SELECT MaMH, TenMH, SoTiet
FROM DMMH
WHERE SoTiet > 30 AND SoTiet < 45;

-- 14.
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, Phai
FROM DMSV
WHERE Phai = 'Nam' AND MaKhoa IN ('AV', 'TH');

-- 15.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen
FROM DMSV
WHERE Phai = 'Nữ' AND TenSV LIKE '%N%';

-- 16.
SELECT HoSV, TenSV, NoiSinh, NgaySinh
FROM DMSV
WHERE NoiSinh = 'Hà Nội' AND MONTH(NgaySinh) = 2;

-- 17.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, HocBong
FROM DMSV
WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) > 20;

-- 18.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, MaKhoa
FROM DMSV
WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) BETWEEN 20 AND 25;

-- 19.
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, Phai, NgaySinh
FROM DMSV
WHERE YEAR(NgaySinh) = 1990 AND MONTH(NgaySinh) BETWEEN 1 AND 3;

-- 20.
SELECT MaSV, Phai, MaKhoa, 
       CASE 
           WHEN HocBong > 500000 THEN 'Học bổng cao'
           ELSE 'Mức trung bình'
       END AS MucHocBong
FROM DMSV;

-- 21.
SELECT COUNT(*) AS TongSoSinhVien
FROM DMSV;

-- 22.
SELECT COUNT(*) AS TongSoSinhVien, 
       SUM(CASE WHEN Phai = 'Nữ' THEN 1 ELSE 0 END) AS TongSoSinhVienNu
FROM DMSV;

-- 23.
SELECT MaKhoa, COUNT(*) AS SoLuongSinhVien
FROM DMSV
GROUP BY MaKhoa;

-- 24.
SELECT MaMH, COUNT(DISTINCT MaSV) AS SoLuongSinhVien
FROM KetQua
GROUP BY MaMH;

-- 25.
SELECT COUNT(DISTINCT MaMH) AS TongSoMonHoc
FROM KetQua;

-- 26.
SELECT MaKhoa, SUM(HocBong) AS TongHocBong
FROM DMSV
GROUP BY MaKhoa;

-- 27.
SELECT MaKhoa, MAX(HocBong) AS HocBongCaoNhat
FROM DMSV
GROUP BY MaKhoa;

-- 28.
SELECT MaKhoa,
       SUM(CASE WHEN Phai = 'Nam' THEN 1 ELSE 0 END) AS SoSinhVienNam,
       SUM(CASE WHEN Phai = 'Nữ' THEN 1 ELSE 0 END) AS SoSinhVienNu
FROM DMSV
GROUP BY MaKhoa;

-- 29.
SELECT TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS DoTuoi, COUNT(*) AS SoLuong
FROM DMSV
GROUP BY DoTuoi;

-- 30.
SELECT YEAR(NgaySinh) AS NamSinh, COUNT(*) AS SoLuong
FROM DMSV
GROUP BY YEAR(NgaySinh)
HAVING COUNT(*) = 2;

-- 31.
SELECT NoiSinh, COUNT(*) AS SoLuong
FROM DMSV
GROUP BY NoiSinh
HAVING COUNT(*) > 2;

-- 32.
SELECT MaMH, COUNT(DISTINCT MaSV) AS SoLuongSinhVien
FROM KetQua
GROUP BY MaMH
HAVING COUNT(DISTINCT MaSV) > 3;
