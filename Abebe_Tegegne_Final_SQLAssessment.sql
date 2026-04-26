use SalesDB


--1. (5 marks) From the Sales.Customers table, display all columns for customers located in Canada.

	select * 
	from Sales.Customers
	where Country = 'Canada'

--Q2. (5 marks) From the Sales.Orders table, list the OrderID, CustomerID, and Sales for orders where Sales is greater than 60.
	select OrderID, CustomerID,Sales
	from Sales.Orders
	where Sales >60

--Q3. (5 marks) Display all customers whose FirstName starts with the letter ‘A’ from the Sales.Customers table.
	select *
	from Sales.Customers
	where FirstName like '%A'

--Q4. (5 marks) List all unique countries from the Sales.Customers table in alphabetical order.
	select distinct Country
	from Sales.Customers
	ORDER BY Country ASC;
--Q5. (10 marks)Using the Sales.Orders table, calculate the total number of orders and total sales amount for each CustomerID.
	select  
		CustomerID,
		COUNT(*) AS TotalOrders,
		SUM(Sales) AS TotalSalesAmount
	from Sales.Orders
	GROUP BY CustomerID;

--Q6. (10 marks)Display each customer’s FirstName, LastName, and their total number of orders by joining Sales.Customers and Sales.Orders tables.

	SELECT 
		c.FirstName,
		c.LastName,
		COUNT(o.OrderID) AS TotalOrders
	FROM Sales.Customers c
	LEFT JOIN Sales.Orders o
		ON c.CustomerID = o.CustomerID
	GROUP BY 
		c.FirstName,
		c.LastName;
--Q7. (10 marks) Find customers who have a total sales value greater than 200 using GROUP BY and HAVING clauses. Display CustomerID and TotalSales.
	SELECT 
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	HAVING SUM(Sales) > 200;
--Q8. (15 marks)
--Create a query that lists OrderID, CustomerID, and a new column named SalesCategory that shows:
--• “High” if Sales > 100
--• “Medium” if Sales between 50 and 100
--• “Low” if Sales < 50
	SELECT 
		OrderID,
		CustomerID,
		Sales,
		CASE 
			WHEN Sales > 100 THEN 'High'
			WHEN Sales BETWEEN 50 AND 100 THEN 'Medium'
			ELSE 'Low'
		END AS SalesCategory
	FROM Sales.Orders;

--Q9. (10 marks) From the Sales.Orders table, retrieve the top 3 orders with the highest Quantity, and display OrderID, CustomerID, and Quantity.
	SELECT TOP 3
		OrderID,
		CustomerID,
		Quantity
	FROM Sales.Orders
	ORDER BY Quantity DESC;

--Q10. (25 marks)
--Write a subquery to display all customers from Sales.Customers who have placed at least one order in Sales.Orders.
--Display CustomerID, FirstName, and LastName.

	SELECT 
		CustomerID,
		FirstName,
		LastName
	FROM Sales.Customers
	WHERE CustomerID IN (
		SELECT CustomerID
		FROM Sales.Orders
	);