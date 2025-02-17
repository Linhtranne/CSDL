USE ss12;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    order_date DATE NOT NULL
);

INSERT INTO orders (customer_name, product, quantity, price, order_date) VALUES
('Alice', 'Laptop', 2, 1500.00, '2023-01-10'),
('Bob', 'Smartphone', 5, 800.00, '2023-02-15'),
('Carol', 'Laptop', 1, 1500.00, '2023-03-05'),
('Alice', 'Keyboard', 3, 100.00, '2023-01-20'),
('Dave', 'Monitor', NULL, 300.00, '2023-04-10');

DELIMITER //

CREATE TRIGGER before_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.quantity < 1 OR NEW.quantity IS NULL THEN
        SET NEW.quantity = 1;
    END IF;
    IF NEW.order_date IS NULL THEN
		SET NEW.order_date = CURDATE();
	END IF;
END;
// DELIMITER ;
INSERT INTO orders (customer_name, product, quantity, price, order_date) VALUES
('Anna', 'Tablet', NULL, 400.00, NULL),
('John', 'Mouse', -3, 50.00, '2023-05-01');
SELECT * FROM orders;
DROP TRIGGER IF EXISTS before_insert_orders;
DROP TABLE IF EXISTS orders;
