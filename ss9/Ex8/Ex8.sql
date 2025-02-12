USE ss9;
CREATE INDEX idx_productLine ON products(productLine);  

CREATE VIEW view_highest_priced_products AS  
SELECT productLine,
productName,
MAX(MSRP)  
FROM products  
GROUP BY productLine, productName;  

SELECT * FROM view_highest_priced_products;  

SELECT a.productLine,
a.productName,
a.MSRP,
b.textDescription  
FROM products a  
LEFT JOIN productlines b ON a.productLine = b.productLine  
ORDER BY a.MSRP DESC  
LIMIT 10;  
