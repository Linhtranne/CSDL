USE salika;
CREATE VIEW view_film_category AS
SELECT 
    f.film_id, 
    f.title, 
    c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

CREATE VIEW view_high_value_customers AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_payment > 100;

CREATE INDEX idx_rental_rental_date ON rental(rental_date);
SELECT * FROM rental WHERE rental_date = '2005-06-14';
EXPLAIN SELECT * FROM rental WHERE rental_date = '2005-06-14';
DELIMITER //

DROP PROCEDURE IF EXISTS CountCustomerRentals //
CREATE PROCEDURE CountCustomerRentals(
    customer_id INT,
    OUT rental_count INT
)
BEGIN
    SELECT COUNT(*) INTO rental_count
    FROM rental
    WHERE rental.customer_id = customer_id;
END //

DELIMITER ;
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomerEmail //
CREATE PROCEDURE GetCustomerEmail(
    IN customer_id INT,
    OUT customer_email VARCHAR(50)
)
BEGIN
    SELECT email INTO customer_email
    FROM customer
    WHERE customer_id = customer_id;
END //
DELIMITER ;

DROP INDEX idx_rental_rental_date ON rental;

DROP VIEW IF EXISTS view_film_category;
DROP VIEW IF EXISTS view_high_value_customers;

DROP PROCEDURE IF EXISTS CountCustomerRentals;
DROP PROCEDURE IF EXISTS GetCustomerEmail;