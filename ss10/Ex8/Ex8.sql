USE world;

DELIMITER //
CREATE PROCEDURE GetCountriesByCityNames()
BEGIN
SELECT 
    c.Name AS CountryName, 
    cl.Language AS OfficialLanguage,
    SUM(ct.Population) AS TotalPopulation 
FROM country c
JOIN city ct ON c.Code = ct.CountryCode
JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'
    AND ct.Name LIKE 'A%'
GROUP BY c.Name, cl.Language
	HAVING TotalPopulation > 2000000
ORDER BY CountryName ASC;
END //
DELIMITER ;
CALL GetCountriesByCityNames
