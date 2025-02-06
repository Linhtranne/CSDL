CREATE DATABASE ss5ex3; 
USE ss5ex3;

-- Tạo bảng customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY, -- Khóa chính
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY, -- Khóa chính
    customer_id INT, -- Khóa ngoại
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) -- Liên kết với bảng customers
);

-- Thêm bản ghi vào bảng customers
INSERT INTO customers (name, email, phone, address)
VALUES
('Nguyen Van An', 'nguyenvanan@example.com', '0901234567', '123 Le Loi, TP.HCM'),
('Tran Thi Bich', 'tranthibich@example.com', '0912345678', '456 Nguyen Hue, TP.HCM'),
('Le Van Cuong', 'levancuong@example.com', '0923456789', '789 Dien Bien Phu, Ha Noi');

-- Thêm bản ghi vào bảng orders
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES
(1, '2025-01-10', 500000, 'Pending'),
(1, '2025-01-12', 325000, 'Completed'),
(NULL, '2025-01-13', 450000, 'Cancelled'),
(3, '2025-01-14', 270000, 'Pending'),
(2, '2025-01-16', 850000, NULL);

SELECT c.name, 
c.phone,
o.order_id,
o.total_amount 
FROM customers c
JOIN orders o ON o.customer_id=c.customer_id
WHERE o.status='Pending' AND o.total_amount>300000;

SELECT c.name,
c.email,
o.order_id
FROM customers c
JOIN orders o ON o.customer_id=c.customer_id
WHERE o.status = 'Completed' OR o.status IS NULL;

SELECT c.name ,
c.address,
o.order_id,
o.status
FROM customers c
JOIN orders o ON o.customer_id=c.customer_id
WHERE o.status = 'Pending' OR o.status ='Canclled';

SELECT c.name,
c.phone,
o.order_id,
o.total_amount 
FROM customers c
JOIN orders o ON o.customer_id=c.customer_id
WHERE o.total_amount<600000 AND o.total_amount>300000;