DROP DATABASE IF EXISTS sales_management;
CREATE DATABASE sales_management;
USE sales_management;

CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255)
);

CREATE TABLE Products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
	category VARCHAR(50) NOT NULL,
    quantity INT CHECK (quantity >= 0)NOT NULL
);

CREATE TABLE Employees(
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
	employee_name VARCHAR(100) NOT NULL ,
    birthday DATE,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    revenue DECIMAL(10,2) DEFAULT 0
);
CREATE TABLE Orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
	FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE OrderDetails(
	order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity >= 0)NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

ALTER TABLE Customers ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;
ALTER TABLE Employees DROP COLUMN birthday;

INSERT INTO Customers (customer_name, phone, address, email) VALUES
	('Nguyen Van A', '0987654321', 'Hà Nội', 'nguyenvana@gmail.com'),
	('Tran Thi B', '0912345678', 'TP. HCM', 'tranthib@gmail.com'),
	('Le Van C', '0909876543', 'Đà Nẵng', 'levanc@gmail.com'),
	('Pham Minh D', '0888123456', 'Cần Thơ', 'phamminhd@gmail.com'),
	('Hoang Anh E', '0867234567', 'Hải Phòng', 'hoanganhe@gmail.com');

INSERT INTO Products (product_name, price, category, quantity) VALUES
	('Áo thun nam', 200000, 'Thời trang', 50),
	('Quần jean nữ', 350000, 'Thời trang', 40),
	('Giày sneaker', 700000, 'Giày dép', 30),
	('Balo laptop', 500000, 'Phụ kiện', 20),
	('Đồng hồ thông minh', 1200000, 'Phụ kiện', 25);

INSERT INTO Employees (employee_name, position, salary, revenue) VALUES
	('Nguyen Van X', 'Nhân viên bán hàng', 7000000, 0),
	('Tran Thi Y', 'Nhân viên kho', 6500000, 0),
	('Le Minh Z', 'Nhân viên giao hàng', 6000000, 0),
	('Pham Van M', 'Nhân viên kế toán', 8000000, 0),
	('Hoang Thi N', 'Quản lý cửa hàng', 15000000, 0);

INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
	(1, 1, '2025-02-19 10:00:00', 200000),
	(2, 2, '2025-02-19 11:30:00', 350000),
	(3, 3, '2025-02-19 14:00:00', 700000),
	(4, 4, '2025-02-19 15:45:00', 500000),
	(5, 5, '2025-02-19 16:30:00', 1200000);

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
	(1, 1, 1, 200000),
	(2, 2, 1, 350000),
	(3, 3, 1, 700000),
	(4, 4, 1, 500000),
	(5, 5, 1, 1200000);
    
SELECT customer_id, customer_name, email, phone FROM Customers;

UPDATE Products 
SET product_name = 'Laptop Dell XPS', price = 99.99
WHERE product_id = 1;

SELECT o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id;

SELECT 
    c.customer_id, 
    c.customer_name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT 
    e.employee_id, 
    e.employee_name, 
    SUM(o.total_amount) AS total_revenue
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
WHERE YEAR(o.order_date) = YEAR(2024)
GROUP BY Employees.employee_id, Employees.employee_name;

SELECT 
    Products.product_id, 
    Products.product_name, 
    SUM(OrderDetails.quantity) AS total_quantity
FROM Products
JOIN OrderDetails ON Products.product_id = OrderDetails.product_id
JOIN Orders ON OrderDetails.order_id = Orders.order_id
WHERE MONTH(Orders.order_date) = MONTH(CURRENT_DATE)
AND YEAR(Orders.order_date) = YEAR(2024)
GROUP BY Products.product_id, Products.product_name
HAVING total_quantity > 100
ORDER BY total_quantity DESC;

SELECT 
    c.customer_id, 
    c.customer_name
FROM Customers c
LEFT JOIN Orders o  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT 
    product_id, 
    product_name, 
    price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

WITH CustomerSpending AS (
    SELECT 
        c.customer_id, 
        c.customer_name, 
        SUM(o.total_amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT * FROM CustomerSpending
WHERE total_spent = (SELECT MAX(total_spent) FROM CustomerSpending);

CREATE VIEW view_order_list AS
SELECT 
    o.order_id, 
    c.customer_name, 
    e.employees_name, 
    o.total_amount, 
    o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employees_id = e.employees_id
ORDER BY o.order_date DESC;

CREATE VIEW view_order_detail_product AS
SELECT 
    od.order_detail_id, 
    p.product_name, 
    od.quantity, 
    od.unit_price
FROM OrderDetals od
JOIN Products p ON od.product_id = p.product_id
ORDER BY od.quantity DESC;

DELIMITER //

CREATE PROCEDURE proc_insert_employee(
    IN p_employees_name VARCHAR(100),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Employees (employees_name, position, salary) 
    VALUES (p_employees_name, p_position, p_salary);
    SELECT LAST_INSERT_ID() AS new_employee_id;
END //

DELIMITER ;
CALL proc_insert_employee('Nguyen Van X', 'Nhân viên bán hàng', 7000000);

DELIMITER //

CREATE PROCEDURE proc_get_orderdetails(
    IN p_order_id INT
)
BEGIN
    SELECT 
        od.order_detail_id, 
        p.product_name, 
        od.quantity, 
        od.unit_price
    FROM OrderDetals od
    JOIN Products p ON od.product_id = p.product_id
    WHERE od.order_id = p_order_id;
END //

DELIMITER ;
CALL proc_get_orderdetails(1);

DELIMITER //

CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT,
    OUT total_products INT
)
BEGIN
    SELECT COUNT(DISTINCT product_id) INTO total_products
    FROM OrderDetals
    WHERE order_id = p_order_id;
END //

DELIMITER ;
CALL proc_cal_total_amount_by_order(2);
DELIMITER //

CREATE TRIGGER trigger_after_insert_order_details
AFTER INSERT ON OrderDetals
FOR EACH ROW
BEGIN
    DECLARE available_quantity INT;
    SELECT quantity INTO available_quantity 
    FROM Products 
    WHERE product_id = NEW.product_id;
    IF NEW.quantity > available_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        UPDATE Products 
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END //

DELIMITER ;
INSERT INTO OrderDetals (order_id, product_id, quantity, unit_price)
VALUES (1, 2, 1000, 50.00);

DELIMITER //

CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE order_exists INT;
    DECLARE total DECIMAL(10,2);
    START TRANSACTION;
    SELECT COUNT(*) INTO order_exists 
    FROM Orders 
    WHERE order_id = p_order_id;

    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tồn tại';
    ELSE
        INSERT INTO OrderDetals (order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);
        SELECT SUM(quantity * unit_price) INTO total
        FROM OrderDetals
        WHERE order_id = p_order_id;
        UPDATE Orders 
        SET total_amount = total
        WHERE order_id = p_order_id;
        COMMIT;
    END IF;
    
END //

DELIMITER ;
CALL proc_insert_order_details(999, 2, 3, 100.00);


