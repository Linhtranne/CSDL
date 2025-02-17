USE ss12;
CREATE TABLE deleted_orders(
	deleted_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    deleted_at DATETIME NOT NULL
);
DELIMITER //
CREATE TRIGGER after_delete_orders
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO deleted_orders (order_id, customer_id, customer_name, product, order_date, deleted_at)
    VALUES (OLD.order_id, OLD.customer_id, OLD.customer_name, OLD.product, OLD.order_date, NOW());
END;
//
DELIMITER ;

