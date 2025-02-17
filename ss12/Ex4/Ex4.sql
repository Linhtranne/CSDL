USE ss12;

CREATE TABLE order_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

DELIMITER //

DROP TRIGGER IF EXISTS after_insert_total_order //

CREATE TRIGGER after_insert_total_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN 
    DECLARE total_price DECIMAL(10,2);
    
    SET total_price = NEW.quantity * NEW.price;

    IF total_price > 5000 THEN
        INSERT INTO order_warnings (order_id, warning_message)
        VALUES (NEW.order_id, 'Total value exceeds limit');
    END IF;
END //

DELIMITER ;

INSERT INTO orders (customer_name, product, quantity, price, order_date)
VALUES 
('Mark', 'Monitor', 2, 3000.00, '2023-08-01'),
('Paul', 'Mouse', 1, 50.00, '2023-08-02');

SELECT * FROM order_warnings;
