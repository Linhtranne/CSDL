USE world;

DELIMITER //

CREATE PROCEDURE UpdateCityPopulation(
    INOUT p_city_id INT, 
    IN p_new_population INT
)
BEGIN

    UPDATE city
    SET Population = p_new_population
    WHERE ID = p_city_id;

    SELECT ID, Name, Population
    FROM city
    WHERE ID = p_city_id;
END //
DELIMITER ;
SET @city_id = 3;
CALL UpdateCityPopulation(@city_id, 12345566);

DROP PROCEDURE IF EXISTS UpdateCityPopulation; 

