USE sakila;

CREATE UNIQUE INDEX idx_unique_email ON customer (email);

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (1, 'A', 'Nguyen', 'dnguyenvana@example.com', 6, 1, NOW());
DELIMITER //

DROP PROCEDURE IF EXISTS CheckCustomerEmail;
CREATE PROCEDURE CheckCustomerEmail(
    IN email_input VARCHAR(50),
    OUT exists_flag TINYINT
)
BEGIN
    SELECT COUNT(*) INTO exists_flag
    FROM customer
    WHERE email = email_input;
    
    SET exists_flag = IF(exists_flag > 0, 1, 0);
END //

DELIMITER ;

CALL CheckCustomerEmail('dungdeptroai@example.com', @exists_flag);
SELECT @exists_flag;

CREATE INDEX idx_rental_customer_id 
ON rental(customer_id);

CREATE VIEW view_active_customer_rentals AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    r.rental_date,
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Returned'
        ELSE 'Not Returned'
    END AS status
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1
AND r.rental_date >= '2023-01-01'
AND (r.return_date IS NULL OR r.return_date >= CURDATE() - INTERVAL 30 DAY);
CREATE INDEX idx_payment_customer_id 
ON payment(customer_id);
CREATE VIEW view_customer_payments AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name, 
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_date >= '2023-01-01'
GROUP BY c.customer_id, full_name
HAVING total_payment > 100;
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomerPaymentsByAmount;
CREATE PROCEDURE GetCustomerPaymentsByAmount(
    IN min_amount DECIMAL(10,2), 
    IN date_from DATE
)
BEGIN
    SELECT 
        c.customer_id, 
        CONCAT(c.first_name, ' ', c.last_name) AS full_name, 
        SUM(p.amount) AS total_payment
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    WHERE p.payment_date >= date_from
    GROUP BY c.customer_id, full_name
    HAVING total_payment >= min_amount;
END //

DELIMITER ;

DROP VIEW IF EXISTS view_active_customer_rentals;
DROP VIEW IF EXISTS view_customer_payments;

DROP PROCEDURE IF EXISTS CheckCustomerEmail;
DROP PROCEDURE IF EXISTS GetCustomerPaymentsByAmount;

DROP INDEX IF EXISTS idx_unique_email ON customer;
DROP INDEX IF EXISTS idx_rental_customer_id ON rental;
DROP INDEX IF EXISTS idx_payment_customer_id ON payment;
