  -- Step 1: Create the Database
   CREATE DATABASE db_Abebe;
   GO

	USE db_Abebe
	GO
--==========================================================================================================
-- Q# 2: Create Customer Table
	create   TABLE Customer(
    CustomerID INT NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL
);
GO
--==========================================================================================================

-- Q#  3: Create Orders Table
USE db_Abebe

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
   
);
GO
--==========================================================================================================

-- Step 4: Implement Triggers to Enforce Constraints

-- a) Prevent deletion of a customer if they have existing orders
CREATE OR ALTER TRIGGER trg_PreventCustomerDeletion
ON Customer
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM DELETED))
    BEGIN
            
		ROLLBACK;
    END
    ELSE
    BEGIN
        DELETE FROM Customer WHERE CustomerID IN (SELECT CustomerID FROM DELETED);
    END
END;
GO
-- Test 
INSERT INTO Customer (CustomerID, FirstName, LastName)
VALUES (11, 'John', 'Mulu'),
       (22, 'Jane', 'Smith');

-- Insert orders for customer 1 (John Doe)
INSERT INTO Orders (OrderID,  OrderDate)
VALUES (11,  '2024-11-01')
       (22,  '2024-11-10');
	   select * from Customer
	   select * from Orders
	   DELETE FROM Customer WHERE CustomerID = 13;
	   --- Msg 50000, Level 16, State 1, Procedure trg_PreventCustomerDeletion, Line 9 [Batch Start Line 58] Cannot delete customer with existing orders. Msg 3609, Level 16, State 1, Line 59 The transaction ended in the trigger. The batch has been aborted.

--==========================================================================================================
--b) b) Create a custom error message using RAISEERROR to notify if the deletion of a customer with orders fails.

CREATE OR ALTER TRIGGER trg_PreventCustomerDeletion
ON Customer
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM DELETED))
    BEGIN
        
        RAISERROR('Cannot delete customer with existing orders.', 16, 1);
		ROLLBACK;
    END
    ELSE
    BEGIN
        DELETE FROM Customer WHERE CustomerID IN (SELECT CustomerID FROM DELETED);
    END
END;
GO
--from question number above the script in answer (a) " RAISERROR('Cannot delete customer with existing orders.', 16, 1);
--		ROLLBACK;" produces the following error 'Msg 50000, Level 16, State 1, Procedure trg_PreventCustomerDeletion, Line 10 [Batch Start Line 52]
--Cannot delete customer with existing orders.--Msg 3609, Level 16, State 1, Line 54
--The transaction ended in the trigger. The batch has been aborted.'


--================================================================
-- C) Ensure that if CustomerID is updated in the Customer table, all related rows in the Orders table are updated accordingly.
CREATE OR ALTER TRIGGER trg_UpdateCustomerID
ON Customer
AFTER UPDATE
AS
BEGIN
    IF UPDATE(CustomerID)
    BEGIN
        UPDATE Orders
        SET Orders.CustomerID = I.CustomerID
        FROM Orders
        INNER JOIN deleted D ON Orders.CustomerID = D.CustomerID
        INNER JOIN inserted I ON D.CustomerID = I.CustomerID;
    END
END;

select *from Customer
select *from Orders
--test-c ==========================================================================================================
UPDATE [dbo].[Customer]
   SET [CustomerID] = 23
      ,[FirstName] = 'AAAAAAAA'
      ,[LastName] = 'BBBBBBBB'
 WHERE CustomerID =2
GO

--==========================================================================================================
-- D) When inserting or updating records in the Orders table, validate that the CustomerID exists in the Customer table. If not, use RAISEERROR to display an appropriate message.

CREATE OR ALTER TRIGGER trg_ValidateCustomerID
ON Orders
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for invalid CustomerID during INSERT or UPDATE
    IF EXISTS (
        SELECT 1
        FROM inserted I
        LEFT JOIN Customer C ON I.CustomerID = C.CustomerID
        WHERE C.CustomerID IS NULL
    )
    BEGIN
        -- Raise a custom error message
       RAISEERROR ('Error: CustomerID does not exist in the Customers table. Please provide a valid CustomerID.', 16, 1);
        RETURN;
    END

    -- Proceed with the operation if all validations pass
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- For INSERT
        INSERT INTO Orders (OrderID, CustomerID, OrderDate)
        SELECT OrderID, CustomerID, OrderDate FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- For UPDATE
        UPDATE Orders
        SET CustomerID = I.CustomerID,
            OrderDate = I.OrderDate
         FROM Orders O
        INNER JOIN inserted I ON O.OrderID = I.OrderID;
    END;
END


--=====================================================================================================
--TESET-d

UPDATE [dbo].Orders
   SET [OrderID] = 16
     
 WHERE OrderID=7
GO
select *from Customer
select *from Orders

--===============================================================================================

--Step 5: Develop a scalar function named fn_CheckName(@FirstName, @LastName) to ensure that FirstName and LastName are not identical.
CREATE OR ALTER FUNCTION fn_CheckName
(
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    -- Declare a variable to store the result
    DECLARE @Result BIT;

    -- Check if FirstName and LastName are identical
    IF @FirstName = @LastName
        SET @Result = 0; -- Identical names are not allowed
    ELSE
        SET @Result = 1; -- Names are valid

    -- Return the result
    RETURN @Result;
END;
GO

---- test 
SELECT dbo.fn_CheckName('Abebe', 'mulu') AS IsValid; -- Returns 1 (valid)
SELECT dbo.fn_CheckName('mulu', 'mulu') AS IsValid; -- Returns 0 (invalid)


--==========================================================================================================
-- Step 6-a): Create Stored Procedure for Customer Insertion
CREATE OR ALTER PROCEDURE sp_InsertCustomer
(
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @CustomerID INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if CustomerID is provided
    IF @CustomerID IS NULL
    BEGIN
        -- Get the maximum CustomerID and increment it by 1
        SELECT @CustomerID = ISNULL(MAX(CustomerID), 0) + 1
        FROM Customer;
    END

    -- Insert the new customer
    INSERT INTO Customer (CustomerID, FirstName, LastName)
    VALUES (@CustomerID, @FirstName, @LastName);

    PRINT 'Customer inserted successfully!';
END;
GO
--b =============================================================================================
CREATE OR ALTER PROCEDURE sp_InsertCustomer
(
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @CustomerID INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate names using fn_CheckName
    IF dbo.fn_CheckName(@FirstName, @LastName) = 0
    BEGIN
        PRINT 'Error: FirstName and LastName cannot be identical.';
        RETURN;
    END

    -- Check if CustomerID is provided
    IF @CustomerID IS NULL
    BEGIN
        -- Get the maximum CustomerID and increment it by 1
        SELECT @CustomerID = ISNULL(MAX(CustomerID), 0) + 1
        FROM Customer;
    END

    -- Insert the new customer
    INSERT INTO Customer (CustomerID, FirstName, LastName)
    VALUES (@CustomerID, @FirstName, @LastName);

    PRINT 'Customer inserted successfully!';
END;
GO

---test
EXEC sp_InsertCustomer @FirstName = 'John', @LastName = 'abebe'; 
EXEC sp_InsertCustomer @FirstName = 'Abebe', @LastName = 'abebe'; 
-- Output: Error: FirstName and LastName cannot be identical.

--==========================================================================================================

-- Step 7: Implement Audit Logging

-- Create AuditLog Table
USE db_Abebe
CREATE  TABLE AuditLog (
    LogID INT IDENTITY PRIMARY KEY,
    Action NVARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE(),
    UserID NVARCHAR(50),
    Details NVARCHAR(MAX)
);
GO
--==========================================================================================================

-- Trigger to log customer insertions
CREATE OR ALTER TRIGGER trg_LogCustomerInsert
ON Customer
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (Action, UserID, Details)
    SELECT 'INSERT', SYSTEM_USER, 'Inserted CustomerID: ' + CAST(CustomerID AS NVARCHAR(50))
    FROM inserted;
END;
GO
--==========================================================================================================

-- Trigger to log customer deletions
CREATE OR ALTER TRIGGER trg_LogCustomerDelete
ON Customer
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (Action, UserID, Details)
    SELECT 'DELETE', SYSTEM_USER, 'Deleted CustomerID: ' + CAST(CustomerID AS NVARCHAR(50))
    FROM deleted;
END;
GO
select * from Customer
UPDATE Customer
SET FirstName = 'Natan', LastName = 'Abebe'
WHERE CustomerID = 14;

SELECT * FROM AuditLog;