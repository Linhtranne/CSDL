CREATE DATABASE ss7;
USE ss7;

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(255) NOT NULL,
    Descriptions TEXT
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Readers (
    ReaderID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Email VARCHAR(255) UNIQUE
);

CREATE TABLE Borrowing (
    BorrowID INT PRIMARY KEY AUTO_INCREMENT,
    ReaderID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Returning (
    ReturnID INT PRIMARY KEY AUTO_INCREMENT,
    BorrowID INT,
    ReturnDate DATE,
    FineAmount DECIMAL(10,2),
    FOREIGN KEY (BorrowID) REFERENCES Borrowing(BorrowID)
);

CREATE TABLE Fines (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    ReaderID INT,
    Amount DECIMAL(10,2),
    Reason TEXT,
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID)
);

INSERT INTO Categories (CategoryName, Descriptions) VALUES 
('Khoa học', 'Sách về khoa học tự nhiên'),
('Văn học', 'Sách văn học nổi tiếng');
    
INSERT INTO Books (Title, Author, CategoryID) VALUES 
('Vũ trụ trong vỏ hạt dẻ', 'Stephen Hawking', 1),
('Đắc Nhân Tâm', 'Dale Carnegie', 2);

INSERT INTO Readers (FullName, Address, Email) VALUES 
('Nguyễn Văn A', 'Hà Nội', 'nguyenvana@gmail.com'),
('Trần Thị B', 'Hồ Chí Minh', 'tranthib@gmail.com');

INSERT INTO Borrowing (ReaderID, BookID, BorrowDate, DueDate) VALUES 
(1, 1, '2024-02-01', '2024-02-15'),
(2, 2, '2024-02-05', '2024-02-20');

INSERT INTO Returning (BorrowID, ReturnDate, FineAmount) VALUES 
(1, '2024-02-14', 0),
(2, '2024-02-22', 5.00);

INSERT INTO Fines (ReaderID, Amount, Reason) VALUES 
(2, 5.00, 'Trả sách trễ'),
(1, 0, 'Không có phí');

UPDATE Readers
SET Address = "Đà Nẵng"
WHERE ReaderID = 1;

DELETE FROM Borrowing WHERE BookID = 2;
DELETE FROM Books WHERE BookID = 2;

          