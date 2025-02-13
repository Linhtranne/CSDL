USE world;

CREATE VIEW OfficialLanguageView AS
SELECT 
    c.Code AS CountryCode, 
    c.Name AS CountryName, 
    cl.Language
FROM country c
JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T';

DELIMITER //
CREATE PROCEDURE GetSpecialCountriesAndCities(
	language_name CHAR(30)
)
BEGIN
SELECT ct.name, c.name, c.Population, ct.Population
FROM city c
JOIN country ct on c.CountryCode= ct.code
JOIN countrylanguage cl on ct.code = cl.CountryCode
WHERE ct.Population > 5000000 AND cl.Language like language_name AND c.name like 'new%'
ORDER BY ct.Population DESC;
END //
DELIMITER ;
CALL GetSpecialCountriesAndCities('English');
DROP PROCEDURE IF EXISTS GetSpecialCountriesAndCities;