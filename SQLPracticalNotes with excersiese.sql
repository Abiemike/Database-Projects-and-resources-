use SalesDB
select * from Sales.Customers
--select FirstName 
--from Sales.Customers 
where Score >500
select Country from Sales.Customers 
where FirstName= 'Kevin';

select * 
from Sales.Orders 
where OrderStatus = 'Delivered';

---
SELECT ShipAddress, BillAddress
FROM Sales.Orders 
where Sales >=50
--- And/OR
SElECT * from Sales.Orders 
where Quantity >1  and Sales>60

SElECT * from Sales.Orders 
where Quantity >1  or  Sales>60
----NULL/NOT Null
SElECT * from Sales.Orders 
where BillAddress IS null

SElECT * from Sales.Orders 
where ShipAddress is NOT null
--- Get all orders where ShipAddress is '250 Race Court’.

Select * from Sales.Orders
where ShipAddress='250 Race Court'

/*
Aggregate functions: MIN, MAX, AVG, SUM, COUNT
➢ String functions: CONCAT, UPPER, LOWER, LEN,
SUBSTRING, REPLACE
➢ Query clauses: SELECT, FROM, WHERE, HAVING,
ORDER BY, TOP
➢ Aliasing with AS for cleaner output
➢ Data types, primary and foreign keys
➢ Practical exercises using the Sales

*/

select MAX(Sales) from Sales.Orders

select COUNT(*) As TotalCount from Sales.Orders
select COUNT(*) As TotalCustomers from Sales.Customers
select MIN(Sales) from Sales.Orders
--- Select *   is not working with group by unless all columns name are included under GroupBy clouse OR used the agregate functions follwed by the select columns  
---

SELECT Sales, COUNT(*) AS OrderCount
FROM Sales.Orders
WHERE Sales >= 10
GROUP BY Sales 
order by Sales DESC
---Or
SELECT *
FROM Sales.Orders
WHERE Sales >= 10
GROUP BY Sales, OrderID,OrderDate,OrderStatus, Quantity,
CustomerID,ProductID, SalesPersonID, ShipDate,ShipAddress,CreationTime, BillAddress
order by Sales DESC

---TOP

select Top(5) FirstName, LastName,Score 
from Sales.Customers
where score >=400
Order by Score DESC
----------------------- to Add new columns from the existing Table =>  Ater command 
ALTER TABLE Sales.Customers
ADD Email VARCHAR(100);
---

UPDATE Sales.Customers
SET Email = 'john.doe@gmail.com'
WHERE CustomerID = 1;

UPDATE Sales.Customers
SET Email = 'jane.smith@yahoo.com'
WHERE CustomerID = 2;

UPDATE Sales.Customers
SET Email = 'michael.brown@outlook.com'
WHERE CustomerID = 3;

UPDATE Sales.Customers
SET Email = 'emily.johnson@company.com'
WHERE CustomerID = 4;

UPDATE Sales.Customers
SET Email = 'david.wilson@gmail.com'
WHERE CustomerID = 5;

select * from Sales.Customers
---===============================String Functions in SQL===========================================---

/* 
1.Combine FirstName and LastName into FullName.
2. Find all Firstname with length > 10 characters.
3. Extract the first 3 characters of ProductCode.
4. Replace road with rd in all addresses.
5. Convert all emails to lowercase.
6. Trim spaces from EmployeeName.
7. Extract everything after @ in Email.
8. Get the first 3 characters of CustomerID.
10. Find all names starting with 'K' and ending with 'n'.
11. Format TotalAmount as $1234.56 */


--- 1.Combine FirstName and LastName into FullName. using the CONCAT
select CONCAT(FirstName,' ',LastName) As FullName
from Sales.Customers

---2. Find all Lastname with length > 10 characters.
select FirstName As LongCharacteredName
from Sales.Customers
where LEN(FirstName)>=6

---3. Extract the first 8 characters of BillAddressfrom salesOreder table .
--- INB ===> SUBSTRING(column, start_position, length)
Select SUBSTRING(BillAddress, 0, 8)  from Sales.Orders

--- 4. Replace creation Time 2024 with 2025 from OrdersArchive

Select REPLACE(CreationTime, 2024 ,2025) 
From Sales.OrdersArchive

---5 Convert all FirstName to lowercase and UperCase.

select LOWER(FirstName) as 
LowerFirstname 
from Sales.Customers

select upper(FirstName) as 
LowerFirstname 
from Sales.Customers

---6 Trim spaces from EmployeeName.

/*  
			TRIM(column)          -- removes leading & trailing
			LTRIM(column)         -- removes leading spaces
			RTRIM(column)         -- removes trailing spaces*/

SELECT * , 
TRIM(FirstName) AS CleanName
FROM Sales.Customers;
---
select * from Sales.Customers
where FirstName like 'K%'
or LastName like 'S%'
--7. Extract everything after @ in Email.

SELECT Email, 
SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailDomain
FROM Sales.Customers
WHERE Email IS NOT NULL
ORDER BY EmailDomain


-------------------
--Extract everything before @ in Email
SELECT Email, 
left(Email, CHARINDEX('@', Email) -1) AS EmailUsers
FROM Sales.Customers
--WHERE Email IS NOT NULL
ORDER BY EmailUsers
--8. Get the first 3 characters of FirstName.
SELECT FirstName,
       LEFT(FirstName, 3) AS First3CharsFromFirstName
FROM Sales.Customers;
--9. Find all names starting with 'K' and ending with 'n'.
SELECT FirstName
FROM Sales.Customers
WHERE FirstName LIKE 'k%n';
--===================================================

select * from Sales.Orders
alter table Sales.Orders
ADD SolledAmount Varchar(100)


UPDATE Sales.Orders SET SoldAmount = 120.50 WHERE CustomerID = 1;
UPDATE Sales.Orders SET SoldAmount = 250.00 WHERE CustomerID = 2;
UPDATE Sales.Orders SET SoldAmount = 75.99  WHERE CustomerID = 3;
UPDATE Sales.Orders SET SoldAmount = 310.25 WHERE CustomerID = 4;
UPDATE Sales.Orders SET SoldAmount = 499.99 WHERE CustomerID = 5;
UPDATE Sales.Orders SET SoldAmount = 60.00  WHERE CustomerID = 6;
UPDATE Sales.Orders SET SoldAmount = 180.75 WHERE CustomerID = 7;
UPDATE Sales.Orders SET SoldAmount = 220.40 WHERE CustomerID = 8;
UPDATE Sales.Orders SET SoldAmount = 95.10  WHERE CustomerID = 9;
UPDATE Sales.Orders SET SoldAmount = 150.00 WHERE CustomerID = 10;

EXEC sp_rename 'Sales.Orders.SolledAmount', 'SoldAmount', 'COLUMN'
;--- used to rename  the columns name 
--====================================================
-- 10. Format TotalAmount as $1234.56 */
SELECT SoldAmount,
       FORMAT(CAST(SoldAmount AS DECIMAL(10,2)), 'C', 'en-US') AS SoldAmountFormatted
FROM Sales.Orders;

---====================================================================================-chapter three and four------------
---SQL JOINS, HAVING, GROUP BY WITH AGREGATE FUNCTIONS 
SELECT sum(Sales) as Sales_per_customer
from Sales.Orders
group by SalesPersonID

SELECT CustomerID,  sum(Sales) as Sales_per_customer
from Sales.Orders
group by CustomerID

SELECT 
    CAST(SoldAmount AS float) AS SoldAmount_Int,
    SUM(CAST(SoldAmount AS float)) AS Sales_per_customer
FROM Sales.Orders
GROUP BY SoldAmount 
select * from Sales.Orders

select CustomerID, AVG(Sales) as AvrageSalesPercustomer
from Sales.Orders
group by CustomerID

select CustomerID, 
COUNT(Sales) As ToalNumberOfSalesPerCustomer,
AVG(Sales) as AvrageSalesPercustomer,
sum(Sales) as Sales_per_customer
from Sales.Orders
group by CustomerID

select * from Sales.Orders
---Filtering on Aggregated Values using HAVING
select CustomerID, 
COUNT(Sales) As ToalNumberOfSalesPerCustomer,
AVG(Sales) as AvrageSalesPercustomer,
sum(Sales) as Sales_per_customer
from Sales.Orders
group by CustomerID
having  AVG(Sales) >20  and CustomerID <5

 
--1. List FirstNames with score higher than 500
Select FirstName  from Sales.Customers
where Score>300

--2. List Records from USA
select * from Sales.Customers
where Country ='USA'
--3. What is the “LastName” of “Kevin”? 

select LastName from Sales.Customers
where FirstName= 'Kevin'

/* 
For task 1-5 use Orders table from SalesDB database
1. Group orders by ProductID and calculate average sales
2. Group orders by Status and count the number of orders.
3. Group orders by ShipAddress and count the number of orders.
4. Show customers whose total quantity ordered is greater than 3.
5. Show products with average price greater than 40

*/
--1
select ProductID,  AVG(Sales)
from Sales.Orders
group by ProductID

---2
select OrderStatus,  count(Sales)
from Sales.Orders
group by OrderStatus

--3
select ShipAddress,  count(Sales)
from Sales.Orders
group by ShipAddress

--4
select CustomerId ,
sum(Quantity) as TotallQuantity
from Sales.Orders
group by CustomerId
having sum(Quantity) >3

--5
select ProductID ,
avg(Sales) as AverageProduct
from Sales.Orders
group by ProductID
having avg(Sales) >40

--==============================JOINs===========================
USE MyDatabase
select * from dbo.Customers
select * from dbo.Orders
-- INNER JOIN ==> logically A ∩ A  
	select * 
	from dbo.Customers 
	inner join  dbo.orders
	ON dbo.Customers.id = dbo.orders.customer_id;
-- left join ==> A ∩ B + A only

select *
from dbo.customers
left join dbo.orders
on dbo.customers.id = dbo.orders.customer_id

--Right join ==> B ∩ A + B only

select *
from dbo.customers
right join dbo.orders
on dbo.customers.id = dbo.orders.customer_id
--OUTER JOIN   ==> 
select *
from dbo.customers
 full outer join dbo.orders
on dbo.customers.id = dbo.orders.customer_id

select *
from dbo.customers
 LEFT outer join dbo.orders
on dbo.customers.id = dbo.orders.customer_id

select *
from dbo.customers
 RIGHT outer join dbo.orders
on dbo.customers.id = dbo.orders.customer_id


---ANTI-JOINS 
--Left Ant-Joins
select *
from dbo.customers
 LEFT join dbo.orders
on dbo.customers.id = dbo.orders.customer_id
where dbo.orders.customer_id is null

select * from dbo.orders
--RIGHT ANTI-JOIN  
select *
from dbo.customers as c
 RIGHT join dbo.orders as o
on c.id = o.customer_id
where c.id is null

--CROSE JOIN
select first_name,score, order_id, order_date
from dbo.customers
 CROSS join dbo.orders

 /*   
 For Tasks 6 – 9 use Customers and OrdersArchive table form SalesDB
database
6. Join customers with their archived orders (only matching records).
7. Show all customers and their orders if available.
8. Show all orders and their customer info if available.
9. Show all customers and all orders, including unmatched records.
 */
 USE SalesDB
--6
 select * 
 from Sales.Customers as c
 inner join Sales.OrdersArchive as oa
 on c.CustomerID = oa.CustomerID
 --7
 select *
 from Sales.Customers as c
 left join Sales.Orders as o
 on o.CustomerID= c.CustomerID

 --8
select *
 from Sales.Customers as c
 right join Sales.Orders as o
 on o.CustomerID= c.CustomerID
 --9
 select *
 from Sales.Customers as c
 full outer join Sales.Orders as o
 on o.CustomerID= c.CustomerID

 --========= VARIABLE========================
 Declare @x int
 set @x=60
 select @x *@x as totalsale

 Declare @AvgSale int
 Set @AvgSale  =  (Select   AVG(Sales) from Sales.Orders)
select @AvgSale as AverageSale

---================= CASE STATMENTS===============
---create three categories, Low (=<30), Medium(=<50), High(>50)
Select Sales ,
	CASE 
		when Sales > 60 then 'High'
		when Sales > 30 then 'Medium'
		else 'Low'
End AS  Sales_cate2
from Sales.Orders

---================= other=============== 
/* Use a Fixed Variable to Categorize Based on Sales. Use a fixed
threshold value to label orders as 'Below Threshold’ (<=50) or 'Above
Threshold’ (>50). */

Declare @Threshold int
Set @Threshold = 50

Select Sales,
	CASE
		WHEN Sales <= @Threshold THEN 'Below Threshold'
		ELSE 'Above Threshold'
	END AS Sales_Category
FROM Sales.Orders

/* Use a Variable to Categorize Based on Sales. Use a variable
threshold value to label orders as 'Below Threshold’ (<=50) or 'Above
Threshold’ (>50). */

Declare @Threshold int
Set @Threshold = 50

Select Sales,
	CASE
		WHEN Sales <= @Threshold THEN 'Below Threshold'
		ELSE 'Above Threshold'
	END AS Sales_Category

	FROM Sales.Orders
	/*   Categorize Orders into Two Groups Based on Quantity ‘Low’ (<=1) or
‘High’ (>1)*/

Select Quantity,
	CASE
		WHEN Quantity <= 1 THEN 'Low'
		ELSE 'High'
	END AS Quantity_Category
	FROM Sales.Orders
	--Common Table Expressions (CTE)
	WITH SalesPerCustomer AS
		(
			SELECT CustomerID, SUM(Sales) AS TotalSales
			FROM Sales.Orders
			GROUP BY CustomerID
		)
	SELECT *
	FROM SalesPerCustomer
	WHERE TotalSales > 10

--WITH Statements
WITH SalesPerCustomer AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)
SELECT *
FROM SalesPerCustomer
WHERE TotalSales < 1000

--WITH Statements
WITH SalesPerCustomer AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)
SELECT *
FROM SalesPerCustomer
WHERE TotalSales > 1000

--WITH Statements
WITH SalesPerCustomer AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)
SELECT *
FROM SalesPerCustomer
WHERE TotalSales > 1000

---WITH Statements
WITH SalesPerCustomer AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
),
SalesPerStatus AS
(
	SELECT OrderStatus, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY OrderStatus
)
SELECT *
FROM SalesPerCustomer
INNER JOIN SalesPerStatus
ON SalesPerCustomer.CustomerID = SalesPerStatus.CustomerID
WHERE TotalSales > 1000

---WITH Statements
WITH SalesPerCustomer AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
),
SalesPerStatus AS
(
	SELECT OrderStatus, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY OrderStatus
)
SELECT *
FROM SalesPerCustomer
INNER JOIN SalesPerStatus
ON SalesPerCustomer.CustomerID = SalesPerStatus.CustomerID
WHERE TotalSales > 1000

---WITH Statements
WITH SalesPerCustomer AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
),
SalesPerStatus AS
(
	SELECT OrderStatus, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY OrderStatus
)
SELECT *
FROM SalesPerCustomer
INNER JOIN SalesPerStatus
ON SalesPerCustomer.CustomerID = SalesPerStatus.CustomerID
WHERE TotalSales > 1000		