USE ss9;
SELECT orderNumber,
orderDate,
status
FROM orders
WHERE YEAR(orderDate) = "2003" AND status = "Shipped";

CREATE INDEX idx_order ON orders(orderDate);
CREATE INDEX Date_status ON orders( status);
EXPLAIN ANALYZE
SELECT orderNumber,
orderDate,
status
FROM orders
WHERE YEAR(orderDate) = "2003" AND status = "Shipped";

SELECT customerNumber,
customerName,
phone
FROM customers
WHERE phone = "2035552570";

CREATE UNIQUE INDEX idx_customerNumber ON customers(customerNumber);
CREATE UNIQUE INDEX idx_phone ON customers(phone);

EXPLAIN ANALYZE
SELECT customerNumber,
customerName,
phone
FROM customers
WHERE phone = "2035552570";

DROP INDEX idx_order ON orders;
DROP INDEX Date_status ON orders;
DROP INDEX idx_customerNumber ON customers;
DROP INDEX idx_phone ON customers;

