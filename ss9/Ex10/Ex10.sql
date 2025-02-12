USE ss9;
CREATE INDEX idx_productLine ON products(productLine);

CREATE VIEW view_total_sales AS
SELECT 
p.productLine, 
SUM(od.quantityOrdered * od.priceEach) AS total_sales, 
SUM(od.quantityOrdered) AS total_quantity
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productLine;

SELECT * FROM view_total_sales;

SELECT 
p.productLine, 
p.textDescription, 
v.total_sales, 
v.total_quantity,
CASE 
WHEN LENGTH(p.textDescription) > 30 
THEN CONCAT(LEFT(p.textDescription, 30), '...') 
ELSE p.textDescription 
    END AS description_snippet,
CASE 
WHEN v.total_quantity > 1000 
THEN (v.total_sales / v.total_quantity) * 1.1  
WHEN v.total_quantity BETWEEN 500 AND 1000 
THEN v.total_sales / v.total_quantity 
ELSE (v.total_sales / v.total_quantity) * 0.9  
END AS sales_per_product

FROM view_total_sales v
JOIN productlines p ON v.productLine = p.productLine
WHERE v.total_sales > 2000000
ORDER BY v.total_sales DESC;  