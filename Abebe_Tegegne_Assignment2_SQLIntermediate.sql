
--===================== Abebe Tegegne Assignment2_SQLIntermediate.sql=============

USE SalesDB

--Intermediate SQL Tasks (Total: 10 Questions, 35 marks)

--Q1. (3 marks)--Display the total number of records in the table Sales.Orders. (Hint: Use COUNT(*)).
	USE SalesDB
	SELECT COUNT(*) AS TotalRecords
	FROM Sales.Orders;
--Q2. (3 marks) List the total number of customers from each country using the Sales.Customers table. (Hint: Use GROUP BY Country).
	select Country,  COUNT(*)As TotalCustomers
	from Sales.Customers
	group by Country;
--Q3. (4 marks)Find the average Sales amount for each OrderStatus in the Sales.Orders table.Display columns as C and AverageSales.
 
	select OrderStatus AS C, 
	AVG(Sales) As AverageSales
	from Sales.Orders
	group by  OrderStatus ;

--Q4. (3 marks) List all countries from Sales.Customers that have more than 2 customers. (Hint: Use HAVING COUNT() > 2).
	
	select Country
	from Sales.Customers
	group by Country
	having COUNT(*) > 2;
	
--Q5. (4 marks) Join the Sales.Customers and Sales.Orders tables on CustomerID to display the following columns: CustomerID, FirstName, OrderID, OrderDate, and Sales.
		Select 
		c.CustomerID,
		c.FirstName,
		o.OrderID,
		o.OrderDate,
		o.Sales 
	from Sales.Customers c
	INNER JOIN Sales.Orders o
	ON c.CustomerID = o.CustomerID;


	
--Q6. (4 marks) Find customers who have placed more than one order. Display CustomerID, FirstName, and the total number of orders they placed.
		select 
			c.CustomerID, 
			c.FirstName,
		count(o.OrderID)as TotalOrder
		from Sales.Customers as C
		inner join Sales.Orders as o
		on c.CustomerID =o.CustomerID
		Group by c.CustomerID, c.FirstName
		having count(orderID) > 1


--Q7. (3 marks) Display all orders with the highest Sales amount using a subquery. (Hint: Compare Sales to the maximum Sales value in the table.)
		select *
		from Sales.Orders
		where Sales =(SELECT MAX(Sales) FROM Sales.Orders);
--Q8. (4 marks) Create a new column FullAddress that combines ShipAddress and BillAddress separated by a comma. (Hint: Use CONCAT() or + operator depending on compatibility.)
	Select 
		ShipAddress,
		BillAddress,
    CONCAT(ShipAddress, ', ', BillAddress) AS FullAddress
	From Sales.Orders;
 --Q9. (3 marks)Show the top 5 orders with the highest Quantity and display columns OrderID, CustomerID, and Quantity. (Hint: Use ORDER BY Quantity DESC and TOP 5.)

		Select TOP(5)
			OrderID,
			CustomerID,
			Quantity
		From Sales.Orders
		ORDER BY Quantity DESC;
--Q10. (4 marks)Write a query that shows each customer’s FirstName, LastName, and their total purchase value (sum of Sales). (Hint: Use SUM() with GROUP BY CustomerID, FirstName, LastName.) 
		Select 
			c.CustomerID, -- I have to used CustomerID under select clouse, to use it under group by clouse 
			FirstName,
			LastName,
			SUM(Sales) AS TotalPurchase
		From Sales.Orders o
		INNER JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		GROUP BY 
			c.CustomerID, 
			FirstName, 
			LastName;