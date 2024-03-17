create database assignment
use assignment

select * from jomato

select stuff('Quick Bites',6,1,'Chicken')

ALTER TABLE jomato
ADD Rating_Status AS (
    CASE
        WHEN rating > 4 THEN 'Excellent'
        WHEN rating > 3.5 THEN 'Good'
        WHEN rating > 3 THEN 'Average'
        ELSE 'Bad'
    END
)

ALTER TABLE jomato
ADD Rating_Status1 AS 
(
    IF rating > 4 'Exel'
    ELSE IF rating > 3.5 then rating='Good'
    ELSE IF rating > 3 then rating='Average'
    ELSE rating= 'Bad'

);

SELECT 
    CASE WHEN GROUPING(restauranttype) = 1 THEN 'Total' ELSE restauranttype END AS restauranttype,
    round(AVG(AverageCost),2) AS total_average_cost
FROM 
    jomato
GROUP BY 
    restauranttype WITH ROLLUP;


select STUFF('Quick Bites', CHARINDEX('Quick Bites', 'Quick Bites'), LEN('Quick Bites'), 'Quick Chicken Bites')

select CHARINDEX('Quick Bites', 'Quick Bites')
select LEN('Quick Bites')

use test

select COALESCE(dept,'Total') as department,sum(salary) as total_salary from EMP_SAL
group by dept with rollup







SELECT 
    Coalesce(restauranttype,'Total') AS Restraunt_Type,
    round(AVG(AverageCost),2) AS total_average_cost
FROM 
    jomato
GROUP BY 
    restauranttype WITH ROLLUP;




---Ceil, floor and absolute

select rating, CEILING(rating) as Ceiling_Value, floor(rating) as Floor_Value, abs(rating) as Absolute_Value from jomato

select getdate(), day(getdate()) as 'Day', Month(getdate()) as 'Month', year(getdate()) as 'year'

select restaurantname, cuisinesType from jomato
where No#of#Rating=( select max(no#of#rating) from jomato)

CREATE FUNCTION dbo.StuffChickenIntoQuickBites (@inputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @outputString NVARCHAR(MAX)
    SET @outputString = @inputString
    
    WHILE CHARINDEX('Quick Bites', @outputString) > 0
    BEGIN
        SET @outputString = STUFF(@outputString, CHARINDEX('Quick Bites', @outputString), LEN('Quick Bites'), 'Quick Chicken Bites')
    END

    RETURN @outputString
END;



UPDATE jomato
SET RestaurantType = dbo.StuffChickenIntoQuickBites(RestaurantType)
WHERE CHARINDEX('Quick Bites', RestaurantType) > 0;


--1. Create a stored procedure to display the restaurant name, type and cuisine where the
--table booking is not zero.

select * from jomato

CREATE PROCEDURE DisplayBookedRestaurants
AS
BEGIN
    SELECT RestaurantName, RestaurantType, CuisinesType
    FROM jomato
    WHERE TableBooking = 'Yes';
END;

DisplayBookedRestaurants

--Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result
--and rollback it.

BEGIN TRANSACTION;

-- Update cuisine type from 'Cafe' to 'Cafeteria'
UPDATE jomato
SET CuisinesType = 'Cafeteria'
WHERE CuisinesType = 'Cafe';

-- Check the result
SELECT * FROM jomato;

-- Rollback the transaction 
ROLLBACK TRANSACTION;


--3. Generate a row number column and find the top 5 areas with the highest rating of restaurants.

WITH RankedRestaurants AS (
    SELECT Area, Rating,
           ROW_NUMBER() OVER (PARTITION BY area ORDER BY Rating DESC) AS RowNum
    FROM jomato
)
SELECT TOP 5 Area, AVG(Rating) AS AvgRating
FROM RankedRestaurants
WHERE RowNum <=5
GROUP BY area
ORDER BY AvgRating DESC;


--4. Use the while loop to display the 1 to 50

DECLARE @counter INT = 1;

WHILE @counter <= 50
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END;

--5. Write a query to Create a Top rating view to store the generated top 5 highest rating of restaurants.

CREATE VIEW TopRatingRestaurants AS
WITH RankedRestaurants AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY rating DESC) AS RowNum
    FROM jomato
)
SELECT *
FROM RankedRestaurants
WHERE RowNum <= 5;

SELECT * FROM TopRatingRestaurants


--Create a trigger that give an message whenever a new record is inserted.

CREATE TRIGGER NewRecordInsertedTrigger
ON jomato 
AFTER INSERT
AS
BEGIN
    -- Declare variables to store the inserted values
    DECLARE @Message NVARCHAR(1000);

    -- Retrieve inserted values and construct the message
    SELECT @Message = 'A new record has been inserted with ID: ' + CONVERT(NVARCHAR(50), OrderId) 
    FROM inserted;

    -- Display the message
    PRINT @Message;
END;

INSERT INTO jomato
VALUES(5137,'Sorshe','Casual Dining',4.5,2341,700,'Yes','No','North Indian','Whitfield','Borewell Road',30)