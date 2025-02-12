USE ss9;

CREATE VIEW view_orders_summary AS  
SELECT c.customerNumber,
c.customerName,
COUNT(o.orderNumber) AS total_orders  
FROM customers c  
JOIN orders o ON c.customerNumber = o.customerNumber  
GROUP BY c.customerNumber, c.customerName;  

SELECT * FROM view_orders_summary
HAVING total_orders > 3;  
