
INSERT INTO NHANVIEN( MANV, HOTEN, NGAYVAOLAM, LUONG)
VALUES 
(1, 'Nguyen Van A', '2023-01-15', 6000),
(2, 'Tran Thi B', '2023-05-10', 5500),
(3, 'Le Van C', '2023-09-20', 5000);

UPDATE NHANVIEN 
SET LUONG =7000
WHERE MANV = 1;

DELETE FROM NHANVIEN
WHERE MANV = 3;
