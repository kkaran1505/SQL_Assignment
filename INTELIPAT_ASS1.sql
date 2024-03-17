CREATE DATABASE INTELIPAT
USE INTELIPAT

--Salesman table creation

CREATE TABLE Salesman (
    SalesmanId INT,
    Name VARCHAR(255),
    Commission DECIMAL(10, 2),
    City VARCHAR(255),
    Age INT
);

--Salesman table record insertion 

INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
VALUES
    (101, 'Joe', 50, 'California', 17),
    (102, 'Simon', 75, 'Texas', 25),
    (103, 'Jessie', 105, 'Florida', 35),
    (104, 'Danny', 100, 'Texas', 22),
    (105, 'Lia', 65, 'New Jersey', 30);

SELECT * FROM Salesman

--Customer table creation

CREATE TABLE Customer (
    SalesmanId INT,
    CustomerId INT,
    CustomerName VARCHAR(255),
    PurchaseAmount INT,
    );

--Customer table record insertion 

INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
VALUES
    (101, 2345, 'Andrew', 550),
    (103, 1575, 'Lucky', 4500),
    (104, 2345, 'Andrew', 4000),
    (107, 3747, 'Remona', 2700),
    (110, 4004, 'Julia', 4545);

SELECT * FROM CUSTOMER


--Orders table Creation


CREATE TABLE Orders (OrderId int, CustomerId int, SalesmanId int, Orderdate Date, Amount money)

--Orders table record insertion 

INSERT INTO Orders Values 
(5001,2345,101,'2021-07-01',550),
(5003,1234,105,'2022-02-15',1500)


SELECT * FROM Orders

--1. Insert a new record in your Orders table.

INSERT INTO Orders Values 
(5002,3747,107,'2021-11-15',1275)

--2. Add Primary key constraint for SalesmanId column in Salesman table. Add default
--constraint for City column in Salesman table. Add Foreign key constraint for SalesmanId
--column in Customer table. Add not null constraint in Customer_name column for the
--Customer table.

--Adding Primary key constraint for SalesmanId column in Salesman table

ALTER TABLE Salesman
ALTER COLUMN SalesmanId INT NOT NULL 

ALTER TABLE Salesman
ADD CONSTRAINT PKID PRIMARY KEY (SalesmanId)

--Adding default constraint for City column in Salesman table.

ALTER TABLE Salesman
ADD CONSTRAINT City DEFAULT 'Texas' FOR City

--Adding Foreign key constraint for SalesmanId column in Customer table.

ALTER TABLE Customer
ADD CONSTRAINT frgn_key FOREIGN KEY
(SalesmanId) REFERENCES Salesman (SalesmanId)



SELECT * FROM CUSTOMER
SELECT * FROM Salesman

SELECT * FROM Fact

SELECT * FROM Location


SELECT * FROM Product

alter table fact
alter column Date date

--1. Display the number of states present in the LocationTable.
 select count(distinct(state)) as No_of_State 
 from location

 --2. How many products are of regular type?

 select count(product) as count_regular_product 
 from product
 where type = 'regular'

 --3. How much spending has been done on marketing of product ID 1?

 select sum(marketing) as spending 
 from fact
 where productid = 1


--4. What is the minimum sales of a product?

select min(sales) as minimum_sales 
from fact

--5. Display the max Cost of Good Sold (COGS).

select max(cogs) as max_cogs 
from fact

--6. Display the details of the product where product type is coffee.

 select p.productid,p.producttype, f.*
 from product as P
 inner join
 fact as F
 on p.productid = f.productid
 where producttype='coffee'

 --7. Display the details where total expenses are greater than 40.

 select * from fact
 where totalexpenses > 40
 order by totalexpenses

 --8. What is the average sales in area code 719?

select round(avg(sales),2) as average_sales 
from fact
where areacode = 719

--9. Find out the total profit generated by Colorado state.

select sum(f.profit) as Total_profit 
from fact as f
inner join location as L
on f.areacode = l.areacode
where l.state = 'colorado'

--10. Display the average inventory for each product ID.

select round(avg(inventory),2)as avg_inventory, productid  
from fact
group by productid
order by productid  

--11. Display state in a sequential order in a Location Table.

select distinct(state) from location
order by state

--12. Display the average budget of the Product where the average budget margin should be greater than 100.

select * from fact

select areacode, round(avg(BudgetMargin),2) as average_budget
from fact
group by areacode
having avg(BudgetMargin) > 100
order by areacode

--13. What is the total sales done on date 2010-01-01?

select sum(sales) as total_sales 
from fact
where date = '2010-01-01'

--14. Display the average total expense of each product ID on an individual date.

select date,productID, round(avg(totalexpenses),2) as Total_Expense 
from fact
group by date, productid
order by date, productid

--15. Display the table with the following attributes such as date, productID, product_type, product, sales, profit, state, area_code.

select top 1 * from fact
select top 1 * from location
select top 1 * from product

select f.Date, f.productid, p.producttype, p.product, f.Sales, f.profit, l.state, l.areacode
from fact as F
inner join 
location as L
on F.areacode = L.areacode
inner join 
product as P
on P.productid = F.productid


--16. Display the rank without any gap to show the sales wise rank.

select sales,DENSE_RANK() over(order by sales desc) as Sales_Wise_Rank
from fact

--17. Find the state wise profit and sales.

select sum(f.profit) as profits, sum(f.sales)as sales, l.state  from fact as F
inner join
location as L
on f.areacode = l.areacode
group by l.state


--18. Find the state wise profit and sales along with the product name.

select l.state,p.product,sum(f.profit) as profits, sum(f.sales)as sales  from fact as F
inner join
location as L
on f.areacode = l.areacode
inner join
product as p
on p.productid = f.productid
group by l.state, p.product

--19. If there is an increase in sales of 5%, calculate the increasedsales.

select sales,(sales + sales*0.05) as increasedSales
from fact

--20. Find the maximum profit along with the product ID and producttype.

select f.productid,p.producttype,max(f.profit) as Max_Profit 
from fact as f
inner join
product as p
on f.productid = p.productid
group by f.productid,p.producttype
order by Max_Profit desc


--21. Create a stored procedure to fetch the result according to the product type from Product Table.

create proc product_type @type varchar(20)
as
select * from product where producttype = @type


exec product_type 'tea'

--22. Write a query by creating a condition in which if the total expenses is less than 60 then it is a profit or else loss.

select productid, totalexpenses, iif(totalexpenses < 60, 'profit', 'loss') as Remarks 
from fact


--23. Give the total weekly sales value with the date and product ID details. Use roll-up to pull the data in hierarchical order.

select date, productid, sum(sales) as total_sales from fact
group by rollup( date, productid)
order by date, productid


--24. Apply union and intersection operator on the tables which consist of attribute area code.

select areacode from fact
union
select areacode from location


select areacode from fact
intersect
select areacode from location

--25. Create a user-defined function for the product table to fetch a particular product type based upon the user�s preference.

create function prod_type(@type varchar(20))
returns table

return (
select * from product where producttype = @type)

select * from prod_type ('coffee')

--26. Change the product type from coffee to tea where product ID is 1 and undo it.

begin transaction
update product 
set producttype = 'tea' 
where productid = 1

rollback transaction

select * from product

--27. Display the date, product ID and sales where total expenses are between 100 to 200.

select date, productid, sales from fact
where totalexpenses between 20 and 100
order by  date

--28. Delete the records in the Product Table for regular type.

begin transaction

delete product where Type = 'regular'

rollback transaction

--29. Display the ASCII value of the fifth character from the columnProduct.

select product, substring(product,5,1) as characters, ASCII(substring(product,5,1)) as ASCII
from product