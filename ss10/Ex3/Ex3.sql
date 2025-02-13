USE world;

DELIMITER //
CREATE PROCEDURE country_language(
	IN Language CHAR(30)
)
BEGIN
	SELECT CountryCode, Language, Percentage
    FROM countrylanguage
    WHERE Percentage >= '50';
    
END;
CALL country_language('Dutch')
DROP PROCEDURE IF EXISTS country_language; 