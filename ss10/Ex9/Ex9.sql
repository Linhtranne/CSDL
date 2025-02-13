USE world;
-- 2
CREATE VIEW CountryLanguageView AS
SELECT country.Code AS CountryCode ,
 country.Name AS CountryName,
 countrylanguage.Language AS Language,
 countrylanguage.IsOfficial AS IsOfficial
FROM country
 JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
 WHERE  countrylanguage.IsOfficial = 'T';

 SELECT * from CountryLanguageView ;

 DELIMITER //

CREATE PROCEDURE GetLargeCitiesWithEnglish ()
BEGIN
  SELECT 
    ct.name AS CityName,
    c.Name AS CountryName, 
    SUM(ct.Population) AS TotalPopulation 
  FROM country c
  JOIN city ct ON c.Code = ct.CountryCode
  JOIN countrylanguage cl ON c.Code = cl.CountryCode
  WHERE cl.IsOfficial = 'T'
    AND cl.Language = 'English'
  GROUP BY CityName,CountryName
  HAVING TotalPopulation > 1000000
  ORDER BY TotalPopulation DESC
  LiMIT 20;
END //

DELIMITER ;

CALL GetLargeCitiesWithEnglish();

DROP PROCEDURE IF EXISTS GetLargeCitiesWithEnglish;