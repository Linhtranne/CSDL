USE ss7;
SELECT b.title, b.author, c.category_name
FROM books b JOIN categories c
ON b.category_id = c.category_id
ORDER BY b.title;

SELECT r.name, COUNT(b.book_id)
FROM readers r JOIN borrowing b
ON r.reader_id = b.reader_id
GROUP BY r.name;

SELECT AVG(fine_amount), re.name
FROM fines f JOIN returning r
ON f.return_id = r.return_id
JOIN borrowing b 
ON b.borrow_id = r.borrow_id
JOIN readers re ON re.reader_id = b.reader_id
GROUP BY re.name;

SELECT title, available_quantity FROM books 
WHERE available_quantity = (SELECT MAX(available_quantity) FROM books);

SELECT r.name, f.fine_amount, re.return_date
FROM readers r JOIN borrowing b 
ON r.reader_id = b.reader_id
JOIN returning re ON re.borrow_id = b.borrow_id
JOIN fines f ON f.return_id = re.return_id
WHERE f.fine_amount > 0;

SELECT b.title, COUNT(bor.borrow_id)
FROM books b JOIN borrowing bor
ON b.book_id = bor.book_id
GROUP BY b.title
ORDER BY COUNT(bor.borrow_id) DESC
LIMIT 1;

SELECT b.title, r.name, bor.borrow_date
FROM readers r JOIN borrowing bor
ON r.reader_id = bor.reader_id
JOIN books b ON b.book_id = bor.book_id
WHERE bor.borrow_id NOT IN (
    SELECT borrow_id FROM returning re
)
ORDER BY bor.borrow_date;

SELECT r.name, b.title
FROM readers r JOIN borrowing bor
ON bor.reader_id = r.reader_id
JOIN returning re ON re.borrow_id = bor.borrow_id
JOIN books b ON b.book_id = bor.book_id
WHERE bor.due_date = re.return_date;

SELECT b.title, b.publication_year, COUNT(borrowing.borrow_id)
FROM books b JOIN borrowing
ON borrowing.book_id = b.book_id
GROUP BY borrowing.book_id, b.title, b.publication_year
ORDER BY COUNT(borrowing.borrow_id) DESC
LIMIT 1;
