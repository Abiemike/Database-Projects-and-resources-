				-- Name : Abebe Tegegne 
				--Assignment1_SQLBasics.sql



--==================Section A: Database Fundamentals (10 marks)==============================

--Q1. (3 marks)
--Create a new database named StudentPracticeDB.
--Switch to it using the USE command.
create database StudentsPracticeDB;

--Q2. (3 marks)
--Create a table named Students with the following columns:

USE StudentsPracticeDB
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50),
    Score INT NULL
);
--Q3. (2 marks)
--Insert three records into the Students table with different countries and scores (including one NULL score).
INSERT INTO Students (StudentID, FirstName, LastName, Country, Score)
VALUES 
(1, 'Abebe', 'Tegegne', 'Canada', 99),
(2, 'John', 'Mathios', 'USA', null),
(3, 'Sara', 'Kumar', 'India', 100);

--Q4. (2 marks)
--Display all records from the Students table using a SELECT * query.

select * from Students;

---==========================Section B: Filtering & Querying Data (10 marks)=================================

--Q5. (3 marks)
--List all students whose score is greater than 50.
select * from Students where Score >50

--Q6. (2 marks)
--Retrieve all students from ‘Canada’.
select * from Students where Country= 'Canada';

--Q7. (3 marks)
--Display only FirstName, LastName, and Score of students where Country is ‘USA’ or score is less than 60.
select FirstName,LastName,Score from Students where Country = 'USA' or Score<0;


--Q8. (2 marks)
--List records where Score is NULL.
select * from Students where  Score is null;
---=================Section C: Aggregate & Sorting Functions (10 marks)========================================

--Q9. (3 marks)
--Find the minimum, maximum, and average score from the Students table.
--(Hint: Use MIN(), MAX(), AVG()).
SELECT 
    MIN(Score) AS MinScore,
    MAX(Score) AS MaxScore,
    AVG(Score) AS AvgScore
FROM Students;

--Q10. (2 marks)
--Count the total number of students and the number of students with non-NULL scores.
SELECT 
    COUNT(*) AS TotalStudents, 
    COUNT(Score) AS nonNULLscores
	
FROM Students;



--Q11. (3 marks)
--Display all students ordered by Score in descending order.
SELECT *
FROM Students
ORDER BY Score DESC;


--Q12. (2 marks)
--Show only the top 2 students with the highest scores.
select 
top 2 *  from Students
ORDER By Score Desc;

--====================Section D: String Functions (5 marks)==================================

--Q13. (2 marks)
--Create a new column FullName by concatenating FirstName and LastName with a space between them.
SELECT 
    StudentID,
    FirstName,
    LastName,
    Country,
    Score,
    FirstName + ' ' + LastName AS FullName
FROM Students;

--Q14. (3 marks)
--Display the FullName in uppercase, and also show the length of each name using UPPER() and LEN(). 

SELECT 
    FirstName + ' ' + LastName AS FullName,
    UPPER(FirstName + ' ' + LastName) AS FullNameUpper,
    LEN(FirstName + ' ' + LastName) AS NameLength
FROM Students;
