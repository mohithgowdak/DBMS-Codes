CREATE TABLE Videos (
    video_id INT PRIMARY KEY,
    video_name VARCHAR(255) NOT NULL,
    duration INT, -- in seconds
    resolution VARCHAR(20),
    upload_date DATE
);
CREATE TABLE Frames (
    frame_id INT PRIMARY KEY,
    video_id INT,
    frame_number INT,
    timestamp TIME,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);
CREATE TABLE Lanes (
    lane_id INT PRIMARY KEY,
    lane_name VARCHAR(50) NOT NULL
);
CREATE TABLE LanePoints (
    point_id INT PRIMARY KEY,
    lane_id INT,
    x_coordinate INT,
    y_coordinate INT,
    FOREIGN KEY (lane_id) REFERENCES Lanes(lane_id)
);
CREATE TABLE LaneDetections (
    detection_id INT PRIMARY KEY,
    frame_id INT,
    lane_id INT,
    confidence FLOAT,
    FOREIGN KEY (frame_id) REFERENCES Frames(frame_id),
    FOREIGN KEY (lane_id) REFERENCES Lanes(lane_id)
);
CREATE TABLE Objects (
    object_id INT PRIMARY KEY,
    object_name VARCHAR(50) NOT NULL
);
CREATE TABLE ObjectDetections (
    detection_id INT PRIMARY KEY,
    frame_id INT,
    object_id INT,
    confidence FLOAT,
    bounding_box_x INT,
    bounding_box_y INT,
    bounding_box_width INT,
    bounding_box_height INT,
    FOREIGN KEY (frame_id) REFERENCES Frames(frame_id),
    FOREIGN KEY (object_id) REFERENCES Objects(object_id)
);

CREATE TABLE WeatherConditions (
    condition_id INT PRIMARY KEY,
    condition_name VARCHAR(50) NOT NULL
);

CREATE TABLE FrameWeather (
    frame_id INT,
    condition_id INT,
    FOREIGN KEY (frame_id) REFERENCES Frames(frame_id),
    FOREIGN KEY (condition_id) REFERENCES WeatherConditions(condition_id)
);
CREATE TABLE RoadSurfaces (
    surface_id INT PRIMARY KEY,
    surface_name VARCHAR(50) NOT NULL
);
CREATE TABLE FrameRoadSurface (
    frame_id INT,
    surface_id INT,
    FOREIGN KEY (frame_id) REFERENCES Frames(frame_id),
    FOREIGN KEY (surface_id) REFERENCES RoadSurfaces(surface_id)
);
CREATE TABLE VideoAnnotations (
    annotation_id INT PRIMARY KEY,
    video_id INT,
    annotation_text TEXT,
    annotation_timestamp TIME,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);
---------------------------
SELECT f.*, ld.lane_id, ld.confidence
FROM Frames f
LEFT JOIN LaneDetections ld ON f.frame_id = ld.frame_id
WHERE f.video_id = 1;

SELECT video_name, SUM(duration) AS total_duration, resolution
FROM Videos
GROUP BY video_name, resolution;

SELECT va.annotation_id, va.annotation_text, va.annotation_timestamp
FROM VideoAnnotations va
WHERE va.video_id = 1;


SELECT v.video_name, AVG(ld.confidence) AS avg_confidence
FROM Videos v
LEFT JOIN Frames f ON v.video_id = f.video_id
LEFT JOIN LaneDetections ld ON f.frame_id = ld.frame_id
GROUP BY v.video_id;
-----------------------------
CREATE VIEW LaneDetectionSummaryView AS
SELECT v.video_name, f.frame_number, ld.confidence
FROM Videos v
JOIN Frames f ON v.video_id = f.video_id
LEFT JOIN LaneDetections ld ON f.frame_id = ld.frame_id;
-----------------------------
CREATE VIEW HighConfidenceObjectDetectionsView AS
SELECT f.frame_number, od.object_id, od.confidence
FROM Frames f
LEFT JOIN ObjectDetections od ON f.frame_id = od.frame_id
WHERE od.confidence > 0.8;
----------------------------
CREATE VIEW WeatherConditionsSummaryView AS
SELECT f.frame_number, wc.condition_name
FROM Frames f
LEFT JOIN FrameWeather fw ON f.frame_id = fw.frame_id
LEFT JOIN WeatherConditions wc ON fw.condition_id = wc.condition_id;
------------------------------
CREATE VIEW RoadSurfaceSummaryView AS
SELECT f.frame_number, rs.surface_name
FROM Frames f
LEFT JOIN FrameRoadSurface frs ON f.frame_id = frs.frame_id
LEFT JOIN RoadSurfaces rs ON frs.surface_id = rs.surface_id;
--------------------------------
CREATE VIEW VideoAnnotationsTimelineView AS
SELECT va.annotation_id, va.video_id, va.annotation_text, va.annotation_timestamp
FROM VideoAnnotations va;
--------------------------------
CREATE TRIGGER UpdateLaneConfidenceAverageOnInsert
AFTER INSERT ON LaneDetections
FOR EACH ROW
BEGIN
    UPDATE Videos v
    SET avg_lane_confidence = (
        SELECT AVG(ld.confidence)
        FROM LaneDetections ld
        JOIN Frames f ON ld.frame_id = f.frame_id
        WHERE f.video_id = NEW.video_id
    )
    WHERE v.video_id = NEW.video_id;
END;
---------------------------------
CREATE TRIGGER NotifyUserOnHighConfidenceObjectDetection
AFTER INSERT ON ObjectDetections
FOR EACH ROW
BEGIN
    IF NEW.confidence > 0.9 THEN
        -- Code to send notification to users
        -- (This is a placeholder and should be implemented based on your environment)
    END IF;
END;
---------------------------------
CREATE TRIGGER CheckWeatherConditionValidity
BEFORE INSERT ON FrameWeather
FOR EACH ROW
BEGIN
    IF NEW.condition_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid weather condition for the frame.';
    END IF;
END;
----------------------------------
CREATE TRIGGER UpdateRoadSurfaceSummaryOnDelete
AFTER DELETE ON RoadSurfaces
FOR EACH ROW
BEGIN
    REFRESH VIEW RoadSurfaceSummaryView;
END;
-----------------------------------
CREATE TRIGGER ArchiveVideosWithNoLaneDetections
AFTER INSERT ON LaneDetections
FOR EACH ROW
BEGIN
    IF NEW.timestamp > '2024-01-01' AND NOT EXISTS (
        SELECT 1
        FROM LaneDetections ld
        JOIN Frames f ON ld.frame_id = f.frame_id
        WHERE f.video_id = NEW.video_id
    ) THEN
        -- Code to archive the video
        -- (This is a placeholder and should be implemented based on your requirements)
    END IF;
END;
-------------------------------------

