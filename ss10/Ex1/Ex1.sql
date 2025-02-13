USE world;

DELIMITER //

CREATE PROCEDURE get_cities_by_country(
    IN p_country_code CHAR(3)
)
BEGIN
    SELECT ID, Name, Population
    FROM city
    WHERE CountryCode = p_country_code;
END //

DELIMITER ;
CALL get_cities_by_country('ARG');

DROP PROCEDURE IF EXISTS get_cities_by_country; 
