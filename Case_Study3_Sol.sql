create database Case_Study3
use Case_Study3

select * from Continent
select * from Customers
select * from Transactions

alter table Transactions
alter column txn_date date

--1. Display the count of customers in each region who have done the transaction in the year 2020.

SELECT COUNT(*) AS TOTAL,CU.REGION_ID,N.region_name
FROM Customers CU 
INNER JOIN Transactions T ON T.customer_id = CU.customer_id
AND(T.txn_date BETWEEN CU.start_date AND CU.end_date)
inner join Continent N
on CU.region_id=N.region_id
WHERE YEAR(T.TXN_DATE) = 2020
GROUP BY CU.region_id,N.region_name
ORDER BY region_id;


--2.Display the maximum and minimum transaction amount of each transaction type.

select txn_type,min(txn_amount) as Minimum_Transaction, max(txn_amount) as Maximum_Tansaction
from transactions
group by txn_type


--3.Display the customer id, region name and transaction amount where transaction type is deposit and transaction amount > 2000.

select CU.customer_id,C.region_name,txn_amount
from Customers CU
inner join Continent C
on CU.region_id=C.region_id
inner join Transactions T
on T.customer_id=CU.customer_id
AND(T.txn_date BETWEEN CU.start_date AND CU.end_date)
where T.txn_type='Deposit' and T.txn_amount>200

--4. Find duplicate records in a customer table.

SELECT START_DATE 
FROM Customers
GROUP BY START_DATE
HAVING COUNT(*) > 1;

SELECT END_DATE 
FROM Customers
GROUP BY END_DATE
HAVING COUNT(*) > 1;



SELECT START_DATE, END_DATE 
FROM Customers
GROUP BY END_DATE, START_DATE
HAVING COUNT(*) > 1;

SELECT CUSTOMER_ID, START_DATE, END_DATE 
FROM Customers
GROUP BY END_DATE, START_DATE, customer_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*)
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--5. Display the detail of customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.

select CU.customer_id,C.region_name,txn_type,txn_amount
from Customers CU
inner join Continent C
on CU.region_id=C.region_id
inner join Transactions T
on CU.customer_id= T.customer_id
AND(T.txn_date BETWEEN CU.start_date AND CU.end_date)
where txn_amount in (select min(txn_amount) from transactions where txn_type='Deposit')

--6. Create a stored procedure to display details of customer and transaction tabl ewhere transaction date is greater than Jun 2020.

create procedure Customer_Details @No_of_Month int, @No_of_Year int
as
select * from Customers CU
inner join Transactions T
on CU.customer_id=T.customer_id
AND(T.txn_date BETWEEN CU.start_date AND CU.end_date)
where month(txn_date)>@No_of_Month and Year(txn_date)>=@No_of_Year

exec Customer_Details 2,2020


--7. Create a stored procedure to insert a record in the continent table.

create procedure Add_Values @region_id int, @region_name varchar(20)
as 
insert into Continent
values(@region_id,@region_name)

exec Add_Values 6,"Antarctica"


--8. Create a stored procedure to display the details of transactions that happened on a specific day.

CREATE PROCEDURE TXN_ON_SPECIFIC_DAY @YEAR INT, @MONTH INT, @DAY INT 
AS
SELECT * FROM Transactions
WHERE TXN_DATE = (SELECT DATEFROMPARTS(@YEAR, @MONTH, @DAY));

EXEC TXN_ON_SPECIFIC_DAY @YEAR = 2020, @MONTH = 01, @DAY = 21;

--9. Create a user defined function to add 10% of the transaction amount in a table.

CREATE FUNCTION ADD_AMOUNT(@ADD INT)
RETURNS TABLE
AS 
RETURN
(SELECT (TXN_AMOUNT+((@ADD/100)*TXN_AMOUNT)) AS AMOUNT FROM Transactions)

SELECT * FROM DBO.ADD_AMOUNT(10);

--10. Create a user defined function to find the total transaction amount for a given transaction type.

CREATE FUNCTION TOTAL_TXN_AMOUNT(@TYPE VARCHAR(20))
RETURNS TABLE
AS
RETURN
(SELECT TXN_TYPE, SUM(TXN_AMOUNT) AS TOTALAMOUNT FROM Transactions
WHERE txn_type = @TYPE
GROUP BY TXN_TYPE )

SELECT * FROM DBO.TOTAL_TXN_AMOUNT('DEPOSIT');

--11. Create a table value function which comprises the columns customer_id, region_id ,txn_date , txn_type , 
--txn_amount which will retrieve data from the above table.

CREATE FUNCTION DETAILS()
RETURNS TABLE
AS
RETURN
(SELECT CU.CUSTOMER_ID,CU.REGION_ID,T.TXN_DATE,T.TXN_TYPE,T.TXN_AMOUNT
FROM Customers CU INNER JOIN Transactions T 
ON T.customer_id = CU.customer_id 
AND (T.txn_date BETWEEN CU.start_date AND CU.end_date))

SELECT * FROM DBO.DETAILS();

--12. Create a TRY...CATCH block to print a region id and region name in a single column.

BEGIN TRY
SELECT REGION_ID+''+ REGION_NAME AS 'RegionID_&_Name' 
FROM Continent
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE() AS ERROR
END CATCH;

--13. Create a TRY...CATCH block to insert a value in the Continent table.

BEGIN TRY
INSERT INTO Continent VALUES(7, 'Oceania')
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE() AS ERROR
END CATCH;
DELETE FROM Continent WHERE region_id = 6

--14. Create a trigger to prevent deleting a table in a database.

CREATE TRIGGER TRG_DELETE
ON CONTINENT
FOR DELETE
AS
BEGIN
	ROLLBACK
	PRINT '********************************************'
	PRINT 'YOU CANNOT DELETE FROM THIS TABLE'
	PRINT '********************************************'
END

--15. Create a trigger to audit the data in a table.

SELECT * FROM Continent;
CREATE TABLE CONTINENT_AUDIT(REGION_ID INT,REGION_NAME VARCHAR(20),INSERTED_BY VARCHAR(50));
CREATE TRIGGER TRG_CONTINETON CONTINENT
FOR INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @ID INT, @NAME VARCHAR(20)SELECT @ID = REGION_ID, @NAME = REGION_NAME FROM inserted
INSERT INTO CONTINENT_AUDIT(REGION_ID, REGION_NAME, INSERTED_BY)VALUES (@ID, @NAME, ORIGINAL_LOGIN())
PRINT 'INSERT TRIGGER EXECUTED'END;
SELECT * FROM CONTINENT_AUDIT;
INSERT INTO CONTINENT VALUES(6, 'RUSSIA');
DELETE FROM Continent
WHERE REGION_ID = 6;
UPDATE CONTINENT
SET REGION_NAME = 'INDIA'WHERE region_id = 6;
ENABLE TRIGGER TRG_DELETE ON CONTINENT;

--16. Create a trigger to prevent login of the same user id in multiple pages.

CREATE TRIGGER PREVENT_MULTIPLE_LOGINS
ON ALL SERVER
FOR LOGON
AS
BEGIN
	DECLARE @SESSION_COUNT INT
	SELECT @SESSION_COUNT = COUNT(*)FROM SYS.DM_EXEC_SESSIONS
	WHERE is_user_process = 1 AND LOGIN_NAME = ORIGINAL_LOGIN()
	IF @SESSION_COUNT > 1
		BEGIN
			PRINT 'MULTIPLE LOGINS NOT ALLOWED'
			ROLLBACK
		END
END;
DISABLE TRIGGER PREVENT_MULTIPLE_LOGINS ON ALL SERVER;

--17. Display top n customers on the basis of transaction type.

SELECT TOP 100 * 
FROM Transactions
WHERE TXN_TYPE = 'DEPOSIT'
ORDER BY TXN_AMOUNT DESC

--18. Create a pivot table to display the total purchase, withdrawal and deposit for all the customers.

SELECT * FROM
(
SELECT CUSTOMER_ID, TXN_TYPE, TXN_AMOUNT FROM Transactions) AS T
PIVOT
(
SUM(TXN_AMOUNT)
FOR TXN_TYPE IN (PURCHASE, DEPOSIT, WITHDRAWAL) 
) AS P