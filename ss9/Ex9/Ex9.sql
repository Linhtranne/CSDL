USE ss9;
CREATE INDEX idx_customerNumber ON payments(customerNumber);

CREATE VIEW view_customer_payments AS
SELECT 
customerNumber, 
SUM(amount) AS total_payments, 
COUNT(checkNumber) AS payment_count
FROM payments
GROUP BY customerNumber;

SELECT * from view_customer_payments ;

SELECT 
c.customerNumber, 
c.customerName, 
v.total_payments, 
v.payment_count
FROM view_customer_payments v
JOIN customers c ON v.customerNumber = c.customerNumber
WHERE v.total_payments > 150000 
AND v.payment_count > 3
ORDER BY v.total_payments DESC
LIMIT 5;