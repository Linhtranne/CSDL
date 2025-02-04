SELECT 
    customer_id,
    customer_name,
    birthday,
    CASE WHEN sex = 1 THEN 'Nam' ELSE 'Nữ' END AS gender,
    phone_number
FROM Customer
WHERE birthday > '2000-01-01';