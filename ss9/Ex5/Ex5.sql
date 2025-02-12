USE ss9;

SELECT customerNumber,
customerName,
city,
creditLimit
FROM customers
WHERE creditLimit <= "100000" AND creditLimit >= "50000";

SELECT 
    c.customerNumber, 
    c.customerName, 
    c.city, 
    c.creditLimit, 
    o.country
FROM customers c
LEFT JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN offices o ON e.officeCode = o.officeCode
WHERE c.creditLimit BETWEEN 50000 AND 100000
ORDER BY c.creditLimit DESC
LIMIT 5;

EXPLAIN ANALYZE 
SELECT 
    c.customerNumber, 
    c.customerName, 
    c.city, 
    c.creditLimit, 
    o.country
FROM customers c
LEFT JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN offices o ON e.officeCode = o.officeCode
WHERE c.creditLimit BETWEEN 50000 AND 100000
ORDER BY c.creditLimit DESC
LIMIT 5;