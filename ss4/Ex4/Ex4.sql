USE film_management;
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    status BIT NOT NULL DEFAULT 1
);

CREATE TABLE Films (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    film_name VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    duration TIME,
    director VARCHAR(50),
    release_date DATE NOT NULL
);

CREATE TABLE Category_Film (
    category_id INT NOT NULL,
    film_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (film_id) REFERENCES Films(film_id) 
);
ALTER TABLE Films 
ADD COLUMN status TINYINT DEFAULT 1;
ALTER TABLE Category 
DROP COLUMN status;
ALTER TABLE Category_Film 
DROP FOREIGN KEY FK_Category_Film_Category;
ALTER TABLE Category_Film 
DROP FOREIGN KEY FK_Category_Film_Film;




