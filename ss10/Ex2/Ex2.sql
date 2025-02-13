USE world;
DELIMITER //
CREATE PROCEDURE CalculatePopulation(
    IN p_countryCode CHAR(3),
    OUT total_population BIGINT
)
BEGIN
    SELECT SUM(Population)
    INTO total_population
    FROM city
    WHERE CountryCode = p_countryCode;
END //
DELIMITER ;
CALL CalculatePopulation('ARG', @total_population);
SELECT @total_population;

DROP PROCEDURE IF EXISTS CalculatePopulation; 