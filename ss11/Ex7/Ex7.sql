CREATE VIEW View_Track_Details AS
SELECT 
    t.TrackId, 
    t.Name AS Track_Name, 
    a.Title AS Album_Title, 
    ar.Name AS Artist_Name, 
    t.UnitPrice
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
WHERE t.UnitPrice > 0.99;

-- Hiển thị view trên
SELECT * FROM View_Track_Details;
CREATE VIEW View_Customer_Invoice AS
SELECT 
    c.CustomerId, 
    CONCAT(c.LastName, ' ', c.FirstName) AS FullName,
    c.Email, 
    SUM(i.Total) AS Total_Spending,
    CONCAT(e.LastName, ' ', e.FirstName) AS Support_Rep
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY c.CustomerId, c.LastName, c.FirstName, c.Email, e.LastName, e.FirstName
HAVING Total_Spending > 50;

SELECT * FROM View_Customer_Invoice;
CREATE VIEW View_Top_Selling_Tracks AS
SELECT 
    t.TrackId, 
    t.Name AS Track_Name, 
    g.Name AS Genre_Name, 
    SUM(il.Quantity) AS Total_Sales
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY t.TrackId, t.Name, g.Name
HAVING Total_Sales > 10;
SELECT * FROM View_Top_Selling_Tracks;
CREATE INDEX idx_Track_Name ON Track(Name);

SELECT * FROM Track WHERE Name LIKE '%Love%';
EXPLAIN SELECT * FROM Track WHERE Name LIKE '%Love%';
CREATE INDEX idx_Invoice_Total ON Invoice(Total);
SELECT * FROM Invoice WHERE Total BETWEEN 20 AND 100;
EXPLAIN SELECT * FROM Invoice WHERE Total BETWEEN 20 AND 100;

DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomerSpending //
CREATE PROCEDURE GetCustomerSpending(IN CustomerId INT, OUT TotalSpent DECIMAL(10,2))
BEGIN
    SELECT COALESCE(Total_Spending, 0) INTO TotalSpent
    FROM View_Customer_Invoice
    WHERE CustomerId = CustomerId;
END //

DELIMITER ;

CALL GetCustomerSpending(8, @TotalSpent);
SELECT @TotalSpent;
DELIMITER //

DROP PROCEDURE IF EXISTS SearchTrackByKeyword //
CREATE PROCEDURE SearchTrackByKeyword(IN p_Keyword VARCHAR(100))
BEGIN
    SELECT * FROM Track WHERE Name LIKE CONCAT('%', p_Keyword, '%');
END //

DELIMITER ;
CALL SearchTrackByKeyword('hel');

DELIMITER //

DROP PROCEDURE IF EXISTS GetTopSellingTracks //
CREATE PROCEDURE GetTopSellingTracks(IN p_MinSales INT, IN p_MaxSales INT)
BEGIN
    SELECT * FROM View_Top_Selling_Tracks
    WHERE Total_Sales BETWEEN p_MinSales AND p_MaxSales;
END //

DELIMITER ;

CALL GetTopSellingTracks(1, 20);

DROP VIEW IF EXISTS View_Track_Details;
DROP VIEW IF EXISTS View_Customer_Invoice;
DROP VIEW IF EXISTS View_Top_Selling_Tracks;
DROP INDEX idx_Track_Name ON Track;
DROP INDEX idx_Invoice_Total ON Invoice;
DROP PROCEDURE IF EXISTS GetCustomerSpending;
DROP PROCEDURE IF EXISTS SearchTrackByKeyword;
DROP PROCEDURE IF EXISTS GetTopSellingTracks;