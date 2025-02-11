USE ss7;
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25) not null,
    cAge INT not null
);

CREATE TABLE Products (
    pID INT PRIMARY KEY,
    pName VARCHAR(25) not null,
    pPrice int not null
);

CREATE TABLE Orders (
    oID INT PRIMARY KEY,
    cID INT not null,
    oDate DATETIME not null,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE Order_Detail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES Orders(oID),
    FOREIGN KEY (pID) REFERENCES Products(pID)
);

INSERT INTO Customer (cID, Name, cAge) VALUES
(1, 'Minh Quan', 10), 
(2, 'Ngoc Oanh', 20), 
(3, 'Hong Ha', 50);

INSERT INTO Orders (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Products (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO Order_Detail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

SELECT oid, cid, odate, ototalprice  
FROM orders  
ORDER BY odate DESC;  

-- 3  
SELECT pname, pprice  
FROM products  
WHERE pprice = (SELECT MAX(pprice) FROM products);  

-- 4  
SELECT c.name AS customername, p.pname AS productname  
FROM customer c  
JOIN orders o ON c.cid = o.cid  
JOIN order_detail od ON o.oid = od.oid  
JOIN products p ON od.pid = p.pid  
ORDER BY c.cid, p.pname;  

-- 5  
SELECT c.name AS customername  
FROM customer c  
LEFT JOIN orders o ON c.cid = o.cid  
WHERE o.oid IS NULL;  

-- 6  
SELECT o.oid, o.odate, od.odqty, p.pname, p.pprice  
FROM orders o  
JOIN order_detail od ON o.oid = od.oid  
JOIN products p ON od.pid = p.pid  
ORDER BY o.oid, o.odate;  

-- 7  
SELECT o.oid, o.odate, SUM(od.odqty * p.pprice) AS total  
FROM orders o  
JOIN order_detail od ON o.oid = od.oid  
JOIN products p ON od.pid = p.pid  
GROUP BY o.oid, o.odate  
ORDER BY total DESC;  

-- 8  

ALTER TABLE orders DROP FOREIGN KEY orders_ibfk_1;  
ALTER TABLE order_detail DROP FOREIGN KEY order_detail_ibfk_1;  
ALTER TABLE order_detail DROP FOREIGN KEY order_detail_ibfk_2;  
 
ALTER TABLE customer DROP PRIMARY KEY;  
ALTER TABLE products DROP PRIMARY KEY;  
ALTER TABLE orders DROP PRIMARY KEY;  
ALTER TABLE order_detail DROP PRIMARY KEY;  
