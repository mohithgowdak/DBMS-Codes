/* creating a new data base (if DATABASE already exixst then only use "USE" command */
CREATE DATABASE university;
USE university;
/* creating a tabel*/
CREATE TABLE Student (
    SID INT PRIMARY KEY,
    NAME VARCHAR(100),
    BRANCH VARCHAR(100),
    SEMESTER INT,
    ADDRESS VARCHAR(100),
    PHONE VARCHAR(15),
    EMAIL VARCHAR(100)
);
/* entering values to table*/
INSERT INTO Student (SID, NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL)
VALUES
    (11, 'Virat Kohli', 'CSE', 5, '10 Kuvempunagar, Bangalore', '9876543210', 'virat@example.com'),
    (12, 'Rohit Sharma', 'ECE', 4, '20 Kuvempunagar, Mumbai', '8765432109', 'rohit@example.com'),
    (13, 'MS Dhoni', 'CSE', 6, '30 Kuvempunagar, Ranchi', '7654321098', 'ms@example.com'),
    (14, 'Sachin Tendulkar', 'ME', 8, '40 Kuvempunagar, Mumbai', '6543210987', 'sachin@example.com'),
    (15, 'Rahul Dravid', 'CSE', 7, '50 Brigade Road, Bangalore', '9876123456', 'rahul@example.com'),
    (16, 'Yuvraj Singh', 'ECE', 6, '60 Church Street, Chandigarh', '8761234567', 'yuvraj@example.com'),
    (17, 'Harbhajan Singh', 'ME', 5, '70 Model Town, Jalandhar', '7652345678', 'harbhajan@example.com'),
    (18, 'Virender Sehwag', 'CSE', 4, '80 Green Park, Delhi', '6543456789', 'sehwag@example.com'),
    (19, 'Gautam Gambhir', 'ME', 3, '90 Connaught Place, Delhi', '5434567890', 'gambhir@example.com'),
    (20, 'Suresh Raina', 'CSE', 5, '100 Mount Road, Chennai', '4325678901', 'raina@example.com');
/*
PERFORMING VARIOUS OPERATIONS
*/
/* 1.INSERT*/
INSERT INTO Student (SID, NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL)
VALUES (11, 'Bob Anderson', 'ME', 2, '321 Pine St', '111-222-3333', 'bob@example.com');

/*2.Modify*/
UPDATE Student
SET ADDRESS = '555 Maple St'
WHERE SID = 2;

/* 3.Delete student entry using SID*/
DELETE FROM Student
WHERE SID = 3;

/* 4.Listing all the students*/
SELECT * FROM Student;

/* 5.List all the students of CSE branch:*/
SELECT * FROM Student
WHERE BRANCH = 'CSE';

/*6.  List all the students of CSE branch and reside in Kuvempunagar:*/
SELECT * FROM Student
WHERE BRANCH = 'CSE'
AND ADDRESS LIKE '%Kuvempunagar%';
