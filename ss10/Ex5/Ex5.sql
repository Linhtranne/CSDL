USE world;
DELIMITER //

CREATE PROCEDURE GetLargeCitiesByCountry(
    IN p_country_code CHAR(3)
)
BEGIN
    SELECT 
        ID, 
        Name AS CityName, 
        Population 
    FROM city
    WHERE CountryCode = p_country_code 
          AND Population > 1000000
    ORDER BY Population DESC;
END // 
 DELIMITER ;
CALL GetLargeCitiesByCountry('USA');
DROP PROCEDURE IF EXISTS GetLargeCitiesByCountry