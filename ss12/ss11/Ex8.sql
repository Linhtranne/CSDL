USE sakila;

CREATE VIEW view_long_action_movies AS
SELECT 
    film.film_id,
    film.title,
    film.description,
    film.length,
    category.name AS category_name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Action' AND film.length > 100;

CREATE VIEW view_texas_customers AS
SELECT DISTINCT
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    address.district AS state
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN rental ON customer.customer_id = rental.customer_id
WHERE address.district = 'Texas';

CREATE VIEW view_high_value_staff AS
SELECT 
    staff.staff_id,
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS total_payment
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id, staff.first_name, staff.last_name
HAVING total_payment > 100;

CREATE FULLTEXT INDEX idx_film_title_description 
ON film (title, description);

CREATE INDEX idx_rental_inventory_id 
ON rental (inventory_id) USING HASH;

SELECT * 
FROM view_long_action_movies 
WHERE MATCH(title, description) AGAINST('War' IN NATURAL LANGUAGE MODE);
DELIMITER //

DROP PROCEDURE IF EXISTS get_rental_by_inventory;
CREATE PROCEDURE get_rental_by_inventory(IN p_inventory_id INT)
BEGIN
    SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id
    FROM rental
    WHERE inventory_id = p_inventory_id;
END //

DELIMITER ;

CALL get_rental_by_inventory(5);


DROP INDEX idx_film_title_description ON film;
DROP INDEX idx_rental_inventory_id ON rental;

DROP VIEW IF EXISTS view_texas_customers;
DROP VIEW IF EXISTS view_high_value_staff;
DROP VIEW IF EXISTS view_long_action_movies;

DROP PROCEDURE IF EXISTS get_rental_by_inventory;
