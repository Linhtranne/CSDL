USE world;

DELIMITER //
CREATE PROCEDURE GetEnglishSpeakingCountriesWithCities(
	IN Language CHAR(30)
)
BEGIN
SELECT 
    c.Name AS CountryName, 
    SUM(ct.Population) AS TotalPopulation 
FROM country c
JOIN city ct ON c.Code = ct.CountryCode
JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = language 
    AND cl.IsOfficial = 'T' 
GROUP BY c.Name
  HAVING TotalPopulation > 5000000
ORDER BY TotalPopulation DESC
LIMIT 5;
END //
DELIMITER ;
CALL GetEnglishSpeakingCountriesWithCities('English');
DROP PROCEDURE IF EXISTS GetEnglishSpeakingCountriesWithCities