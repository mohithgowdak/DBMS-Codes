CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(50),
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Providers (
    provider_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    bio TEXT
);

CREATE TABLE ServiceReviews (
    review_id INT PRIMARY KEY,
    service_id INT,
    user_name VARCHAR(50) NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE UserBookings (
    booking_id INT PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL,
    service_id INT,
    booking_date DATE,
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE ServiceCategories (
    service_id INT,
    category_id INT,
    PRIMARY KEY (service_id, category_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE UserFavorites (
    favorite_id INT PRIMARY KEY,
    user_id INT,
    service_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE ProviderServices (
    provider_id INT,
    service_id INT,
    PRIMARY KEY (provider_id, service_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE ServiceImages (
    image_id INT PRIMARY KEY,
    service_id INT,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE ServiceTags (
    tag_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE ServiceTaggings (
    service_id INT,
    tag_id INT,
    PRIMARY KEY (service_id, tag_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id),
    FOREIGN KEY (tag_id) REFERENCES ServiceTags(tag_id)
);
-- Inserting a category
INSERT INTO Categories (category_id, name)
VALUES (1, 'Business');

-- Inserting a tag
INSERT INTO ServiceTags (tag_id, name)
VALUES (1, 'Consulting');

-- Inserting a service with categories, tags, and images
INSERT INTO Services (service_id, title, category, description, price)
VALUES (1, 'Consulting Session', 'Business', 'Professional advice on business strategy', 50.00);

INSERT INTO ServiceCategories (service_id, category_id)
VALUES (1, 1);

INSERT INTO ServiceTaggings (service_id, tag_id)
VALUES (1, 1);

INSERT INTO ServiceImages (image_id, service_id, image_url)
VALUES (1, 1, 'https://example.com/image1.jpg');

-- Inserting a service provider
INSERT INTO Providers (provider_id, name, email, phone_number, bio)
VALUES (1, 'John Doe', 'john.doe@email.com', '+1234567890', 'Experienced business consultant');

-- Inserting a review for a service
INSERT INTO ServiceReviews (review_id, service_id, user_name, rating, comment, created_at)
VALUES (1, 1, 'HappyClient123', 5, 'Great consultation, highly recommended!', '2023-02-15 09:30:00');

-- Inserting a user
INSERT INTO Users (user_id, username, email, password)
VALUES (1, 'ClientA', 'clientA@email.com', 'securepassword');

-- Inserting a user booking and favorite
INSERT INTO UserBookings (booking_id, user_name, service_id, booking_date)
VALUES (1, 'ClientA', 1, '2023-03-01');

INSERT INTO UserFavorites (favorite_id, user_id, service_id, created_at)
VALUES (1, 1, 1, '2023-02-28');
-- Retrieving all services with categories and tags
SELECT s.*, c.name AS category_name, t.name AS tag_name
FROM Services s
LEFT JOIN ServiceCategories sc ON s.service_id = sc.service_id
LEFT JOIN Categories c ON sc.category_id = c.category_id
LEFT JOIN ServiceTaggings st ON s.service_id = st.service_id
LEFT JOIN ServiceTags t ON st.tag_id = t.tag_id;

-- Retrieving service providers and their services
SELECT p.*, s.title AS service_title
FROM Providers p
LEFT JOIN ProviderServices ps ON p.provider_id = ps.provider_id
LEFT JOIN Services s ON ps.service_id = s.service_id;

-- Retrieving all reviews for a specific service
SELECT sr.*, u.username AS user_name
FROM ServiceReviews sr
LEFT JOIN Users u ON sr.user_name = u.username
WHERE sr.service_id = 1;

-- Retrieving all bookings and favorites for a specific user
SELECT ub.*, uf.created_at AS favorite_created_at, s.title AS service_title
FROM UserBookings ub
LEFT JOIN UserFavorites uf ON ub.user_name = uf.user_id
LEFT JOIN Services s ON ub.service_id = s.service_id
WHERE ub.user_name = 'ClientA';
------------------------------
SELECT s.title, AVG(sr.rating) AS avg_rating
FROM Services s
LEFT JOIN ServiceReviews sr ON s.service_id = sr.service_id
GROUP BY s.service_id
ORDER BY avg_rating DESC, s.title
LIMIT 1

UNION

SELECT s.title, AVG(sr.rating) AS avg_rating
FROM Services s
LEFT JOIN ServiceReviews sr ON s.service_id = sr.service_id
GROUP BY s.service_id
ORDER BY avg_rating ASC, s.title
LIMIT 1;
----------------------------------
SELECT p.name, COUNT(ps.service_id) AS service_count
FROM Providers p
LEFT JOIN ProviderServices ps ON p.provider_id = ps.provider_id
GROUP BY p.provider_id
ORDER BY service_count DESC;
----------------------------------
SELECT s.title, sr.user_name, sr.rating, sr.comment, sr.created_at
FROM Services s
LEFT JOIN ServiceReviews sr ON s.service_id = sr.service_id
WHERE sr.created_at = (SELECT MAX(created_at) FROM ServiceReviews WHERE service_id = s.service_id);
----------------------------------
SELECT p.name AS provider_name, SUM(s.price) AS total_revenue
FROM Providers p
JOIN ProviderServices ps ON p.provider_id = ps.provider_id
JOIN Services s ON ps.service_id = s.service_id
GROUP BY p.provider_id;
------------------------------------
SELECT s.title, t.name AS tag_name
FROM Services s
LEFT JOIN ServiceTaggings st ON s.service_id = st.service_id
LEFT JOIN ServiceTags t ON st.tag_id = t.tag_id
WHERE t.name IN ('Consulting', 'Professional');
----------------------------------
SELECT DISTINCT u.username
FROM Users u
JOIN UserBookings ub ON u.username = ub.user_name
JOIN Services s ON ub.service_id = s.service_id
JOIN ServiceCategories sc ON s.service_id = sc.service_id
JOIN Categories c ON sc.category_id = c.category_id
WHERE c.name = 'Business';
---------------------------------
SELECT p.name
FROM Providers p
JOIN ProviderServices ps ON p.provider_id = ps.provider_id
JOIN Services s ON ps.service_id = s.service_id
GROUP BY p.provider_id
HAVING COUNT(DISTINCT s.category) = (SELECT COUNT(DISTINCT category_id) FROM Categories);
---------------------------------
SELECT u.username
FROM Users u
JOIN UserFavorites uf ON u.user_id = uf.user_id
JOIN Services s ON uf.service_id = s.service_id
JOIN (
    SELECT service_id, AVG(rating) AS avg_rating
    FROM ServiceReviews
    GROUP BY service_id
    HAVING AVG(rating) >= 4.0
) AS high_rated_services ON s.service_id = high_rated_services.service_id;
-------------------------------
SELECT s.title, COUNT(ub.booking_id) AS booking_count
FROM Services s
LEFT JOIN UserBookings ub ON s.service_id = ub.service_id
GROUP BY s.service_id
ORDER BY booking_count DESC
LIMIT 5;
------------------------------
SELECT u.username, p.name AS provider_name
FROM Users u
JOIN ServiceReviews sr ON u.username = sr.user_name
JOIN Services s ON sr.service_id = s.service_id
JOIN ProviderServices ps ON s.service_id = ps.service_id
JOIN Providers p ON ps.provider_id = p.provider_id
GROUP BY u.username, p.provider_id
HAVING COUNT(DISTINCT s.service_id) = (SELECT COUNT(DISTINCT service_id) FROM Services WHERE provider_id = p.provider_id);
--------------------------------
SELECT s.title, COUNT(st.tag_id) AS tag_count
FROM Services s
LEFT JOIN ServiceTaggings st ON s.service_id = st.service_id
GROUP BY s.service_id
ORDER BY tag_count DESC
LIMIT 5;
--------------------------------
SELECT c.name AS category_name, AVG(sr.rating) AS avg_rating
FROM Categories c
LEFT JOIN ServiceCategories sc ON c.category_id = sc.category_id
LEFT JOIN Services s ON sc.service_id = s.service_id
LEFT JOIN ServiceReviews sr ON s.service_id = sr.service_id
GROUP BY c.category_id;
--------------------------------
SELECT s.title
FROM Services s
LEFT JOIN UserBookings ub ON s.service_id = ub.service_id
WHERE ub.booking_id IS NULL;
--------------------------------
CREATE VIEW ServiceDetailsView AS
SELECT s.title, s.description, s.price, p.name AS provider_name
FROM Services s
JOIN ProviderServices ps ON s.service_id = ps.service_id
JOIN Providers p ON ps.provider_id = p.provider_id;
--------------------------------
CREATE VIEW TopRatedServicesView AS
SELECT s.title, AVG(sr.rating) AS avg_rating
FROM Services s
LEFT JOIN ServiceReviews sr ON s.service_id = sr.service_id
GROUP BY s.service_id
ORDER BY avg_rating DESC;
--------------------------------
CREATE VIEW ProviderEarningsView AS
SELECT p.name AS provider_name, SUM(s.price) AS total_earnings
FROM Providers p
JOIN ProviderServices ps ON p.provider_id = ps.provider_id
JOIN Services s ON ps.service_id = s.service_id
GROUP BY p.provider_id;
----------------------------------
CREATE VIEW UserBookingsHistoryView AS
SELECT u.username, s.title, ub.booking_date
FROM Users u
JOIN UserBookings ub ON u.user_id = ub.user_id
JOIN Services s ON ub.service_id = s.service_id;
----------------------------------
CREATE VIEW CategoryServiceCountView AS
SELECT c.name AS category_name, COUNT(s.service_id) AS service_count
FROM Categories c
LEFT JOIN ServiceCategories sc ON c.category_id = sc.category_id
LEFT JOIN Services s ON sc.service_id = s.service_id
GROUP BY c.category_id;
-----------------------------------
CREATE TRIGGER UpdateAverageRating
AFTER INSERT ON ServiceReviews
FOR EACH ROW
BEGIN
    UPDATE Services
    SET average_rating = (
        SELECT AVG(rating)
        FROM ServiceReviews
        WHERE service_id = NEW.service_id
    )
    WHERE service_id = NEW.service_id;
END;
------------------------------------
CREATE TRIGGER NotifyProviderOnBooking
AFTER INSERT ON UserBookings
FOR EACH ROW
BEGIN
    DECLARE provider_email VARCHAR(255);
    SELECT email INTO provider_email
    FROM Providers
    WHERE provider_id = (
        SELECT provider_id
        FROM ProviderServices
        WHERE service_id = NEW.service_id
        LIMIT 1
    );
    -- Code to send notification to the provider's email
    -- (This is a placeholder and should be implemented based on your environment)
END;
-------------------------------------
CREATE TRIGGER CheckBookingDateValidity
BEFORE INSERT ON UserBookings
FOR EACH ROW
BEGIN
    IF NEW.booking_date < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid booking date. Please choose a future date.';
    END IF;
END;
------------------------------------
CREATE TRIGGER UpdateProviderStatusOnServiceDelete
AFTER DELETE ON Services
FOR EACH ROW
BEGIN
    UPDATE Providers
    SET status = 'Inactive'
    WHERE provider_id = (
        SELECT provider_id
        FROM ProviderServices
        WHERE service_id = OLD.service_id
        LIMIT 1
    )
    AND NOT EXISTS (
        SELECT 1
        FROM ProviderServices
        WHERE provider_id = OLD.provider_id
    );
END;
------------------------------------
CREATE TRIGGER PreventDuplicateFavorites
BEFORE INSERT ON UserFavorites
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM UserFavorites
        WHERE user_id = NEW.user_id AND service_id = NEW.service_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This service is already in your favorites.';
    END IF;
END;
-------------------------------------
