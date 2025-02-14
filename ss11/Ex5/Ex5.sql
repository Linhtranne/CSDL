
USE chinook;

CREATE VIEW View_Album_Artist AS
SELECT 
    Album.AlbumId AS AlbumId,
    Album.Title AS Album_Title,
    Artist.Name AS Artist_Name
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId;
CREATE VIEW View_Customer_Spending AS
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Email,
    COALESCE(SUM(i.Total), 0) AS Total_Spending
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Email;
CREATE INDEX idx_Employee_LastName ON Employee (LastName);

SELECT * FROM Employee WHERE LastName = 'King';
EXPLAIN SELECT * FROM Employee WHERE LastName = 'King';
DELIMITER //

DROP PROCEDURE IF EXISTS GetTracksByGenre //
CREATE PROCEDURE GetTracksByGenre(genre_id INT)
BEGIN
    SELECT t.TrackId, t.Name AS Track_Name, a.Title AS Album_Title, ar.Name AS Artist_Name
    FROM Track t
    LEFT JOIN Album a ON t.AlbumId = a.AlbumId
    LEFT JOIN Artist ar ON a.ArtistId = ar.ArtistId
    WHERE t.GenreId = genre_id;
END //

DELIMITER ;
CALL GetTracksByGenre(1);
DELIMITER //

DROP PROCEDURE IF EXISTS GetTrackCountByAlbum //
CREATE PROCEDURE GetTrackCountByAlbum(p_AlbumId INT)
BEGIN
    SELECT COUNT(t.TrackId) AS Total_Tracks
    FROM Track t
    WHERE t.AlbumId = p_AlbumId;
END //

DELIMITER ;

CALL GetTrackCountByAlbum(1);
DROP VIEW IF EXISTS View_Album_Artist;
DROP VIEW IF EXISTS View_Customer_Spending;
DROP INDEX idx_Employee_LastName ON Employee;
DROP PROCEDURE IF EXISTS GetTracksByGenre;
DROP PROCEDURE IF EXISTS GetTrackCountByAlbum;


