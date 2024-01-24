CREATE TABLE Anime (
    anime_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(50),
    release_date DATE,
    rating FLOAT
);

CREATE TABLE Episodes (
    episode_id INT PRIMARY KEY,
    anime_id INT,
    episode_number INT,
    title VARCHAR(255) NOT NULL,
    release_date DATE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id)
);

CREATE TABLE Characters (
    character_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    anime_id INT,
    role VARCHAR(50),
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id)
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    anime_id INT,
    user_id INT,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Favorites (
    favorite_id INT PRIMARY KEY,
    user_id INT,
    anime_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id)
);

CREATE TABLE Studios (
    studio_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE StudioCollaboration (
    collaboration_id INT PRIMARY KEY,
    anime_id INT,
    studio_id INT,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id),
    FOREIGN KEY (studio_id) REFERENCES Studios(studio_id)
);

CREATE TABLE Tags (
    tag_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE AnimeTags (
    anime_tag_id INT PRIMARY KEY,
    anime_id INT,
    tag_id INT,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);
-- Inserting an anime
INSERT INTO Anime (anime_id, title, genre, release_date, rating)
VALUES (1, 'Attack on Titan', 'Action, Fantasy', '2013-04-06', 9.0);

-- Inserting episodes for an anime
INSERT INTO Episodes (episode_id, anime_id, episode_number, title, release_date)
VALUES (1, 1, 1, 'To You, in 2000 Years: The Fall of Shiganshina, Part 1', '2013-04-06');

-- Inserting characters for an anime
INSERT INTO Characters (character_id, name, anime_id, role)
VALUES (1, 'Eren Yeager', 1, 'Main Protagonist');

-- Inserting users
INSERT INTO Users (user_id, username, email, password)
VALUES (1, 'AnimeFan123', 'animefan@email.com', 'securepassword');

-- Inserting a review for an anime
INSERT INTO Reviews (review_id, anime_id, user_id, rating, comment, created_at)
VALUES (1, 1, 1, 5, 'Amazing anime with intense action!', '2023-01-24 12:30:00');

-- Inserting favorites for a user
INSERT INTO Favorites (favorite_id, user_id, anime_id, created_at)
VALUES (1, 1, 1, '2023-01-24 13:45:00');

-- Inserting studios
INSERT INTO Studios (studio_id, name)
VALUES (1, 'Wit Studio');

-- Inserting studio collaborations for an anime
INSERT INTO StudioCollaboration (collaboration_id, anime_id, studio_id)
VALUES (1, 1, 1);

-- Inserting tags
INSERT INTO Tags (tag_id, name)
VALUES (1, 'Shounen');

-- Inserting tags for an anime
INSERT INTO AnimeTags (anime_tag_id, anime_id, tag_id)
VALUES (1, 1, 1);
-- Retrieving all anime
SELECT * FROM Anime;

-- Retrieving episodes for a specific anime
SELECT * FROM Episodes WHERE anime_id = 1;

-- Retrieving characters for a specific anime
SELECT * FROM Characters WHERE anime_id = 1;

-- Retrieving reviews for a specific anime
SELECT * FROM Reviews WHERE anime_id = 1;

-- Retrieving favorites for a specific user
SELECT * FROM Favorites WHERE user_id = 1;

-- Retrieving studio collaborations for a specific anime
SELECT s.name AS studio_name
FROM StudioCollaboration sc
JOIN Studios s ON sc.studio_id = s.studio_id
WHERE sc.anime_id = 1;

-- Retrieving tags for a specific anime
SELECT t.name AS tag_name
FROM AnimeTags at
JOIN Tags t ON at.tag_id = t.tag_id
WHERE at.anime_id = 1;
-----------------------------------
SELECT a.title, a.rating, COUNT(e.episode_id) AS episode_count
FROM Anime a
LEFT JOIN Episodes e ON a.anime_id = e.anime_id
GROUP BY a.anime_id
ORDER BY a.rating DESC
LIMIT 5;
-----------------------------------
SELECT u.username, r.rating, r.comment
FROM Users u
JOIN Reviews r ON u.user_id = r.user_id
WHERE r.anime_id = 1;
-----------------------------------
SELECT a.title
FROM Anime a
LEFT JOIN Reviews r ON a.anime_id = r.anime_id
WHERE r.review_id IS NULL;
----------------------------------
SELECT a.genre, AVG(e.episode_number) AS avg_episode_number
FROM Anime a
LEFT JOIN Episodes e ON a.anime_id = e.anime_id
GROUP BY a.genre;
---------------------------------
SELECT u.username, f.anime_id, COUNT(f.favorite_id) AS favorite_count
FROM Users u
JOIN Favorites f ON u.user_id = f.user_id
GROUP BY u.user_id, f.anime_id
HAVING COUNT(f.favorite_id) > 1;
--------------------------------
SELECT a.title, COUNT(r.review_id) AS review_count
FROM Anime a
LEFT JOIN Reviews r ON a.anime_id = r.anime_id
GROUP BY a.anime_id
ORDER BY review_count DESC
LIMIT 1;
-------------------------------
SELECT u.username
FROM Users u
LEFT JOIN Reviews r ON u.user_id = r.user_id
WHERE r.review_id IS NULL;
-------------------------------
SELECT s.name AS studio_name, SUM(m.price) AS total_revenue
FROM Studios s
JOIN StudioCollaboration sc ON s.studio_id = sc.studio_id
JOIN Anime a ON sc.anime_id = a.anime_id
JOIN Episodes e ON a.anime_id = e.anime_id
JOIN MenuItems m ON e.episode_id = m.episode_id
GROUP BY s.studio_id;
-----------------------------
SELECT t.name AS tag_name, GROUP_CONCAT(a.title) AS anime_titles
FROM Tags t
JOIN AnimeTags at ON t.tag_id = at.tag_id
JOIN Anime a ON at.anime_id = a.anime_id
GROUP BY t.tag_id;
----------------------------
SELECT a.title, MAX(e.release_date) AS latest_episode_date
FROM Anime a
JOIN Episodes e ON a.anime_id = e.anime_id
GROUP BY a.anime_id;
----------------------------
SELECT a.title, AVG(r.rating) AS avg_user_rating
FROM Anime a
LEFT JOIN Reviews r ON a.anime_id = r.anime_id
GROUP BY a.anime_id;
---------------------------
SELECT u.username
FROM Users u
JOIN Reviews r ON u.user_id = r.user_id
JOIN Anime a ON r.anime_id = a.anime_id
GROUP BY u.user_id
HAVING COUNT(DISTINCT a.genre) = (SELECT COUNT(DISTINCT genre) FROM Anime);
----------------------------
SELECT a.title, COUNT(sc.collaboration_id) AS collaboration_count
FROM Anime a
JOIN StudioCollaboration sc ON a.anime_id = sc.anime_id
GROUP BY a.anime_id
HAVING COUNT(sc.collaboration_id) > 1;
---------------------------
SELECT a.title, s.name AS studio_name, e.release_date
FROM Anime a
JOIN StudioCollaboration sc ON a.anime_id = sc.anime_id
JOIN Studios s ON sc.studio_id = s.studio_id
JOIN Episodes e ON a.anime_id = e.anime_id
ORDER BY a.title, e.release_date;
--------------------------
SELECT u.username, COUNT(DISTINCT a.anime_id) AS favorited_anime_count
FROM Users u
JOIN Favorites f ON u.user_id = f.user_id
JOIN Anime a ON f.anime_id = a.anime_id
WHERE YEAR(a.release_date) = 2023
GROUP BY u.user_id
HAVING COUNT(DISTINCT a.anime_id) = (SELECT COUNT(anime_id) FROM Anime WHERE YEAR(release_date) = 2023);
-------------------------
SELECT a.title, COUNT(DISTINCT r.user_id) AS user_count
FROM Anime a
LEFT JOIN Reviews r ON a.anime_id = r.anime_id
GROUP BY a.anime_id
HAVING COUNT(DISTINCT r.user_id) >= 3;
-------------------------
SELECT s.name AS studio_name, AVG(r.rating) AS avg_rating
FROM Studios s
JOIN StudioCollaboration sc ON s.studio_id = sc.studio_id
JOIN Anime a ON sc.anime_id = a.anime_id
LEFT JOIN Reviews r ON a.anime_id = r.anime_id
GROUP BY s.studio_id;
-------------------------
SELECT a.title
FROM Anime a
JOIN Characters c ON a.anime_id = c.anime_id
WHERE c.role IN ('Main Protagonist', 'Main Antagonist')
GROUP BY a.anime_id
HAVING COUNT(DISTINCT c.role) = 2;
------------------------
SELECT a.title, AVG(rating) AS avg_rating
FROM Anime a
LEFT JOIN Episodes e ON a.anime_id = e.anime_id
LEFT JOIN Reviews r ON e.episode_id = r.anime_id
GROUP BY a.anime_id
ORDER BY avg_rating DESC, a.title
LIMIT 1

UNION

SELECT a.title, AVG(rating) AS avg_rating
FROM Anime a
LEFT JOIN Episodes e ON a.anime_id = e.anime_id
LEFT JOIN Reviews r ON e.episode_id = r.anime_id
GROUP BY a.anime_id
ORDER BY avg_rating ASC, a.title
LIMIT 1;
-----------------------
SELECT u.username
FROM Users u
WHERE NOT EXISTS (
    SELECT e.episode_id
    FROM Episodes e
    WHERE NOT EXISTS (
        SELECT r.review_id
        FROM Reviews r
        WHERE r.user_id = u.user_id AND r.anime_id = e.anime_id AND r.episode_id = e.episode_id
    )
);
-----------------------
SELECT a.title, e.episode_number, COUNT(f.favorite_id) AS favorite_count
FROM Anime a
JOIN Episodes e ON a.anime_id = e.anime_id
LEFT JOIN Favorites f ON a.anime_id = f.anime_id
GROUP BY a.anime_id, e.episode_id
ORDER BY favorite_count DESC
LIMIT 5;
--------------------------
SELECT u.username
FROM Users u
WHERE NOT EXISTS (
    SELECT a.anime_id
    FROM Anime a
    WHERE YEAR(a.release_date) = 2023 AND QUARTER(a.release_date) = 4
        AND NOT EXISTS (
            SELECT f.favorite_id
            FROM Favorites f
            WHERE f.user_id = u.user_id AND f.anime_id = a.anime_id
        )
);
-------------------------
SELECT a.title, AVG(r.rating) AS avg_episode_rating, (SELECT AVG(rating) FROM Reviews) AS overall_avg_rating
FROM Anime a
LEFT JOIN Episodes e ON a.anime_id = e.anime_id
LEFT JOIN Reviews r ON e.episode_id = r.anime_id
GROUP BY a.anime_id
HAVING AVG(r.rating) > (SELECT AVG(rating) FROM Reviews);
-------------------------
SELECT a.title, COUNT(DISTINCT r.episode_id) AS reviewed_episodes,
       COUNT(DISTINCT e.episode_id) AS total_episodes,
       (COUNT(DISTINCT r.episode_id) / COUNT(DISTINCT e.episode_id)) * 100 AS review_percentage
FROM Anime a
LEFT JOIN Episodes e ON a.anime_id = e.anime_id
LEFT JOIN Reviews r ON e.episode_id = r.anime_id
GROUP BY a.anime_id;
-------------------------
SELECT DISTINCT a.title
FROM Anime a
JOIN Episodes e ON a.anime_id = e.anime_id
JOIN Reviews r ON e.episode_id = r.anime_id
WHERE r.rating > 9.0;


