use ss6;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY, -- ID duy nhất của người dùng
    username VARCHAR(50) NOT NULL,         -- Tên tài khoản người dùng
    email VARCHAR(100) UNIQUE NOT NULL,    -- Email của người dùng
    created_at DATETIME NOT NULL           -- Thời gian tạo tài khoản
);
-- Tạo bảng Posts
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY, 
    user_id INT NOT NULL,                   
    content TEXT NOT NULL,                  
    created_at DATETIME NOT NULL,           
    likes_count INT DEFAULT 0,              
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
-- Thêm dữ liệu vào bảng Users
INSERT INTO Users (username, email, created_at)
VALUES
    ('john_doe', 'john.doe@example.com', '2025-01-01 10:00:00'),
    ('jane_smith', 'jane.smith@example.com', '2025-01-02 11:00:00'),
    ('alice_wonder', 'alice.wonder@example.com', '2025-01-03 12:00:00'),
    ('bob_marley', 'bob.marley@example.com', '2025-01-04 13:00:00'),
    ('charlie_brown', 'charlie.brown@example.com', '2025-01-05 14:00:00');
-- Thêm dữ liệu vào bảng Posts
INSERT INTO Posts (user_id, content, created_at, likes_count)
VALUES
    (1, 'Hello world!', '2025-01-10 10:00:00', 10),
    (2, 'Love this platform!', '2025-01-11 11:00:00', 20),
    (1, 'Had a great day today.', '2025-01-12 12:00:00', 15),
    (3, 'Exploring new ideas!', '2025-01-13 13:00:00', 25),
    (4, 'Check out my new blog.', '2025-01-14 14:00:00', 30);

SELECT 
u.user_id, 
u.username, 
COUNT(p.post_id) AS total_posts, 
SUM(p.likes_count) AS total_likes
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
HAVING total_likes > 20
ORDER BY total_likes DESC;

SELECT 
u.user_id, 
u.username,
p.content,
p.post_id, 
likes_count
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, likes_count,p.content,p.post_id
HAVING likes_count >= 20
ORDER BY likes_count DESC;

SELECT 
u.user_id, 
u.username,
COUNT(p.post_id) AS total_posts, 
SUM(p.likes_count) AS total_likes
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
HAVING total_posts >=2
ORDER BY total_likes DESC;

SELECT 
u.user_id, 
u.username, 
post_id,
p.content,
SUM(p.likes_count) AS total_likes
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username,post_id,p.content
HAVING total_likes <15 
ORDER BY total_likes DESC;




