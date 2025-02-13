USE world;
DELIMITER //

CREATE PROCEDURE GetCountriesWithLargeCities(
)
BEGIN
    SELECT 
		Name AS CountryName, 
        Population 
    FROM country
    WHERE Continent = 'Asia' AND Population > 10000000

    ORDER BY Population DESC;
END // 
 DELIMITER ;
CALL GetCountriesWithLargeCities;
DROP PROCEDURE IF EXISTS GetlargeCitiesByCountry