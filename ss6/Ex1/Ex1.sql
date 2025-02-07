CREATE DATABASE ss6;
USE ss6;

-- Tạo bảng Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,              
    CustomerName VARCHAR(100) NOT NULL,                 
    ProductName VARCHAR(100) NOT NULL,                  
    Quantity INT NOT NULL CHECK (Quantity > 0),         
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),    
    OrderDate DATE NOT NULL                             
);

-- Thêm giá trị vào bảng Orders
INSERT INTO Orders (CustomerName, ProductName, Quantity, Price, OrderDate)
VALUES
    ('Nguyen Van A', 'Laptop', 1, 15000000, '2025-01-01'),
    ('Tran Thi B', 'Smartphone', 2, 8000000, '2025-01-01'),
    ('Nguyen Van A', 'Headphones', 3, 2000000, '2025-01-03'),
    ('Le Van C', 'Laptop', 1, 15000000, '2025-01-01'),
    ('Nguyen Van A', 'Smartphone', 1, 8000000, '2025-01-05'),
    ('Tran Thi B', 'Headphones', 1, 2000000, '2025-01-05'),
    ('Le Van C', 'Smartphone', 3, 8000000, '2025-01-07'),
    ('Tran Thi B', 'Laptop', 1, 15000000, '2025-01-03');

SELECT CustomerName,
SUM(Quantity) as "TotalQuantity"
FROM Orders
GROUP BY CustomerName;

SELECT ProductName,
SUM(Price) AS "TotalPrice"
FROM Orders
GROUP BY ProductName;

SELECT OrderDate, 
COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY OrderDate
ORDER BY OrderDate;

SELECT CustomerName, MIN(Price) AS MinPrice
FROM Orders
GROUP BY CustomerName
ORDER BY CustomerName;




