CREATE TABLE tbl_users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(50) NOT NULL UNIQUE,
  user_fullname VARCHAR(100) NOT NULL,
  user_address TEXT,
  user_phone VARCHAR(11) NOT NULL UNIQUE
);

-- Tạo bảng tbl_employees
CREATE TABLE tbl_employees (
  emp_id CHAR(5) PRIMARY KEY,
  user_id INT NOT NULL,
  emp_position VARCHAR(50),
  emp_hire_date DATE,
  salary DECIMAL(15, 2) NOT NULL CHECK (salary > 0),
  emp_status ENUM('đang làm', 'đang nghỉ') DEFAULT 'đang làm',
  FOREIGN KEY (user_id) REFERENCES tbl_users(user_id)
);

-- Tạo bảng tbl_products
CREATE TABLE tbl_products (
  pro_id CHAR(5) PRIMARY KEY,
  pro_name VARCHAR(100) NOT NULL UNIQUE,
  pro_price DECIMAL(10, 2) NOT NULL CHECK (pro_price > 0),
  pro_quantity INT,
  pro_status ENUM('còn hàng', 'hết hàng') DEFAULT 'còn hàng'
);

-- Tạo bảng tbl_orders
CREATE TABLE tbl_orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  order_date DATE DEFAULT CURRENT_DATE,
  order_total_amount DECIMAL(15, 2),
  order_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled') DEFAULT 'Pending',
  FOREIGN KEY (user_id) REFERENCES tbl_users(user_id)
);

-- Tạo bảng tbl_order_detail
CREATE TABLE tbl_order_detail (
  order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  pro_id CHAR(5) NOT NULL,
  order_detail_quantity INT NOT NULL CHECK (order_detail_quantity > 0),
  order_detail_price DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES tbl_orders(order_id),
  FOREIGN KEY (pro_id) REFERENCES tbl_products(pro_id)
);

-- PHẦN 2: CHÈN DỮ LIỆU

-- Thêm dữ liệu vào tbl_users
INSERT INTO tbl_users (user_name, user_fullname, user_address, user_phone)
VALUES ('john_doe', 'John Doe', '123 Main St', '0987654321'),
       ('jane_smith', 'Jane Smith', '456 Market Ave', '0123456789'),
       ('emma_johnson', 'Emma Johnson', '789 Elm Rd', '0981234567');

-- Thêm dữ liệu vào tbl_employees
INSERT INTO tbl_employees (emp_id, user_id, emp_position, emp_hire_date, salary)
VALUES ('E001', 1, 'Manager', '2022-01-15', 5000),
       ('E002', 2, 'Sales', '2023-02-10', 3500);

-- Thêm dữ liệu vào tbl_products
INSERT INTO tbl_products (pro_id, pro_name, pro_price, pro_quantity)
VALUES ('P001', 'Product A', 100, 50),
       ('P002', 'Product B', 150, 30),
       ('P003', 'Product C', 200, 20);

-- Thêm dữ liệu vào tbl_orders
INSERT INTO tbl_orders (user_id, order_total_amount, order_status)
VALUES (1, 300, 'Completed'),
       (2, 150, 'Processing');

-- Thêm dữ liệu vào tbl_order_detail
INSERT INTO tbl_order_detail (order_id, pro_id, order_detail_quantity, order_detail_price)
VALUES (1, 'P001', 2, 100),
       (1, 'P002', 1, 150),
       (2, 'P003', 1, 200);

-- PHẦN 3: TRUY VẤN DỮ LIỆU

-- Câu 4a: Danh sách tất cả đơn hàng
SELECT order_id, order_date, order_total_amount, order_status 
FROM tbl_orders;

-- Câu 4b: Danh sách tên khách hàng đã đặt hàng
SELECT DISTINCT user_fullname 
FROM tbl_users 
JOIN tbl_orders ON tbl_users.user_id = tbl_orders.user_id;

-- Câu 5a: Danh sách tất cả sản phẩm đã từng được đặt hàng
SELECT p.pro_name, SUM(od.order_detail_quantity) AS total_sold
FROM tbl_products p
JOIN tbl_order_detail od ON p.pro_id = od.pro_id
GROUP BY p.pro_name;

-- Câu 5b: Tổng doanh thu từ từng sản phẩm
SELECT p.pro_name, SUM(od.order_detail_price * od.order_detail_quantity) AS total_revenue
FROM tbl_products p
JOIN tbl_order_detail od ON p.pro_id = od.pro_id
GROUP BY p.pro_name
ORDER BY total_revenue DESC;

-- Câu 6a: Số lượng đơn hàng của từng khách hàng
SELECT u.user_fullname, COUNT(o.order_id) AS order_count
FROM tbl_users u
JOIN tbl_orders o ON u.user_id = o.user_id
GROUP BY u.user_fullname;

-- Câu 6b: Khách hàng đã đặt từ 2 đơn hàng trở lên
SELECT u.user_fullname, COUNT(o.order_id) AS order_count
FROM tbl_users u
JOIN tbl_orders o ON u.user_id = o.user_id
GROUP BY u.user_fullname
HAVING COUNT(o.order_id) >= 2;

-- Câu 7: Top 5 khách hàng có tổng giá trị đơn hàng cao nhất
SELECT u.user_fullname, SUM(o.order_total_amount) AS total_spent
FROM tbl_users u
JOIN tbl_orders o ON u.user_id = o.user_id
GROUP BY u.user_fullname
ORDER BY total_spent DESC
LIMIT 5;

-- Câu 8: Nhân viên và số đơn hàng đã xử lý
SELECT e.emp_position, u.user_fullname, COUNT(o.order_id) AS total_orders
FROM tbl_employees e
JOIN tbl_users u ON e.user_id = u.user_id
LEFT JOIN tbl_orders o ON o.user_id = e.user_id
GROUP BY e.emp_position, u.user_fullname;