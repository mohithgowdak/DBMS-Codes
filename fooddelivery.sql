CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    cuisine_type VARCHAR(50),
    rating FLOAT
);

CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    restaurant_id INT,
    user_name VARCHAR(50) NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);
-- Inserting a restaurant
INSERT INTO Restaurants (restaurant_id, name, location, cuisine_type, rating)
VALUES (1, 'Foodie Haven', '123 Main Street', 'Italian', 4.5);

-- Inserting menu items for a restaurant
INSERT INTO MenuItems (item_id, restaurant_id, name, price, description)
VALUES (1, 1, 'Spaghetti Bolognese', 12.99, 'Classic Italian dish with meat sauce');

-- Inserting a review for a restaurant
INSERT INTO Reviews (review_id, restaurant_id, user_name, rating, comment)
VALUES (1, 1, 'JohnDoe123', 5, 'Great food and excellent service!');
-- Retrieving all restaurants
SELECT * FROM Restaurants;

-- Retrieving menu items for a specific restaurant
SELECT * FROM MenuItems WHERE restaurant_id = 1;

-- Retrieving reviews for a specific restaurant
SELECT * FROM Reviews WHERE restaurant_id = 1;
-- Updating the rating of a restaurant
UPDATE Restaurants SET rating = 4.8 WHERE restaurant_id = 1;

-- Updating the price of a menu item
UPDATE MenuItems SET price = 14.99 WHERE item_id = 1;
-- Deleting a restaurant and its related data
DELETE FROM Restaurants WHERE restaurant_id = 1;

-- Deleting a menu item
DELETE FROM MenuItems WHERE item_id = 1;

-- Deleting a review
DELETE FROM Reviews WHERE review_id = 1;
------------------------------------------
SELECT cuisine_type, AVG(rating) AS avg_rating
FROM Restaurants
GROUP BY cuisine_type;
-------------------------------------------
SELECT r.name AS restaurant_name, COUNT(m.item_id) AS item_count
FROM Restaurants r
LEFT JOIN MenuItems m ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.name;
--------------------------------------------
SELECT r1.*
FROM Restaurants r1
JOIN (
    SELECT cuisine_type, MAX(rating) AS max_rating
    FROM Restaurants
    GROUP BY cuisine_type
) r2 ON r1.cuisine_type = r2.cuisine_type AND r1.rating = r2.max_rating;
---------------------------------------------
SELECT *
FROM Restaurants
WHERE (SELECT AVG(rating) FROM Reviews WHERE restaurant_id = Restaurants.restaurant_id) > 4.0;
---------------------------------------------
SELECT r.name AS restaurant_name, COUNT(rev.review_id) AS review_count
FROM Restaurants r
LEFT JOIN Reviews rev ON r.restaurant_id = rev.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY review_count DESC;
---------------------------------------------
SELECT r.name AS restaurant_name, m.name AS most_expensive_item, m.price
FROM Restaurants r
LEFT JOIN MenuItems m ON r.restaurant_id = m.restaurant_id
WHERE m.price = (SELECT MAX(price) FROM MenuItems WHERE restaurant_id = r.restaurant_id);
---------------------------------------------
SELECT r.*
FROM Restaurants r
LEFT JOIN Reviews rev ON r.restaurant_id = rev.restaurant_id
WHERE rev.review_id IS NULL;
---------------------------------------------
SELECT r.name AS restaurant_name, SUM(m.price) AS total_revenue
FROM Restaurants r
JOIN MenuItems m ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.name;
---------------------------------------------
SELECT m.name AS menu_item_name, COUNT(rev.review_id) AS review_count
FROM MenuItems m
LEFT JOIN Reviews rev ON m.item_id = rev.restaurant_id
GROUP BY m.item_id, m.name
ORDER BY review_count DESC
LIMIT 5;
----------------------------------------------
SELECT *
FROM Restaurants
WHERE rating > (SELECT AVG(rating) FROM Restaurants);
----------------------------------------------
SELECT r.name AS restaurant_name, rev.user_name, rev.rating, rev.comment, rev.created_at
FROM Restaurants r
LEFT JOIN Reviews rev ON r.restaurant_id = rev.restaurant_id
WHERE rev.review_id = (
    SELECT review_id
    FROM Reviews
    WHERE restaurant_id = r.restaurant_id
    ORDER BY created_at DESC
    LIMIT 1
);
---------------------------------------------
SELECT cuisine_type, AVG(rating) AS avg_rating
FROM Restaurants
GROUP BY cuisine_type
ORDER BY avg_rating DESC
LIMIT 3;
---------------------------------------------
SELECT r.name AS restaurant_name, COUNT(m.item_id) AS item_count, AVG(m.price) AS avg_price
FROM Restaurants r
LEFT JOIN MenuItems m ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.name;
---------------------------------------------
SELECT *
FROM Restaurants
WHERE cuisine_type = 'Japanese' AND rating > 4.0;
----------------------------------------------
SELECT r.name AS restaurant_name, COUNT(rev.review_id) AS review_count, AVG(rev.rating) AS avg_rating
FROM Restaurants r
LEFT JOIN Reviews rev ON r.restaurant_id = rev.restaurant_id
GROUP BY r.restaurant_id, r.name;
-----------------------------------------------
