USE ss13;
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price, stock) VALUES
('Laptop Dell', 1500.00, 10),
('iPhone 13', 1200.00, 8),
('Samsung TV', 800.00, 5),
('AirPods Pro', 250.00, 20),
('MacBook Air', 1300.00, 7);
DELIMITER //

CREATE PROCEDURE PlaceOrder(IN p_product_id INT, IN p_quantity INT)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_total_price DECIMAL(10,2);
    START TRANSACTION;
    SELECT stock, price INTO v_stock, v_price FROM products WHERE product_id = p_product_id FOR UPDATE;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error!';
        ROLLBACK;
    ELSE
        SET v_total_price = v_price * p_quantity;
        INSERT INTO orders (product_id, quantity, total_price) 
        VALUES (p_product_id, p_quantity, v_total_price);
        UPDATE products 
        SET stock = stock - p_quantity 
        WHERE product_id = p_product_id;

        COMMIT;
    END IF;
END //

DELIMITER ;
CALL PlaceOrder(2, 3);
SELECT * FROM products;
SELECT * FROM orders;


