CREATE TABLE suppliers (
    suppliers_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255) DEFAULT NULL
);

CREATE TABLE supplier_addresses (
    addresses_id INT AUTO_INCREMENT PRIMARY KEY,
    suppliers_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    FOREIGN KEY (suppliers_id) REFERENCES suppliers(suppliers_id) 
);

CREATE TABLE materials (
    materials_id INT AUTO_INCREMENT PRIMARY KEY,
    materials_name VARCHAR(255) NOT NULL,
    materials_description TEXT DEFAULT NULL
);

CREATE TABLE purchases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    materials_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    delivery_address_id INT NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ,
    FOREIGN KEY (materials_id) REFERENCES materials(materials_id),
    FOREIGN KEY (delivery_address_id) REFERENCES supplier_addresses(id)
);