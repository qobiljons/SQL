-- Task 1: Basic MERGE Operation
MERGE INTO Employees AS e
USING NewEmployees AS ne
ON e.EmployeeID = ne.EmployeeID
WHEN MATCHED THEN 
    UPDATE SET e.Name = ne.Name, e.Position = ne.Position, e.Salary = ne.Salary
WHEN NOT MATCHED THEN 
    INSERT (EmployeeID, Name, Position, Salary)
    VALUES (ne.EmployeeID, ne.Name, ne.Position, ne.Salary);

-- Task 2: Delete Records with MERGE
MERGE INTO OldProducts AS op
USING CurrentProducts AS cp
ON op.ProductID = cp.ProductID
WHEN NOT MATCHED BY SOURCE THEN 
    DELETE;

-- Task 3: MERGE with Conditional Updates
MERGE INTO Employees AS e
USING NewSalaryDetails AS ns
ON e.EmployeeID = ns.EmployeeID
WHEN MATCHED AND ns.Salary > e.Salary THEN 
    UPDATE SET e.Salary = ns.Salary;

-- Task 4: MERGE with Multiple Conditions
MERGE INTO Orders AS o
USING NewOrders AS no
ON o.OrderID = no.OrderID AND o.CustomerID = no.CustomerID
WHEN MATCHED AND no.OrderAmount > o.OrderAmount THEN 
    UPDATE SET o.OrderAmount = no.OrderAmount
WHEN NOT MATCHED THEN 
    INSERT (OrderID, CustomerID, OrderAmount)
    VALUES (no.OrderID, no.CustomerID, no.OrderAmount);

-- Task 5: MERGE with Data Validation and Logging
MERGE INTO StudentRecords AS sr
USING (SELECT * FROM NewStudentRecords WHERE Age > 18) AS nsr
ON sr.StudentID = nsr.StudentID
WHEN MATCHED THEN 
    UPDATE SET sr.Name = nsr.Name, sr.Age = nsr.Age, sr.Grade = nsr.Grade
WHEN NOT MATCHED THEN 
    INSERT (StudentID, Name, Age, Grade)
    VALUES (nsr.StudentID, nsr.Name, nsr.Age, nsr.Grade);

INSERT INTO MergeLog (ActionType, StudentID, ActionDate)
SELECT 'INSERTED', StudentID, GETDATE()
FROM NewStudentRecords WHERE Age > 18;

-- View and Function Practice

-- Task 1: Aggregated Sales Summary
CREATE VIEW SalesSummary AS
SELECT CustomerID, SUM(SalesAmount) AS TotalSales, COUNT(OrderID) AS OrderCount
FROM Sales
GROUP BY CustomerID;

-- Task 2: Employee Department Details
CREATE VIEW EmployeeDepartmentDetails AS
SELECT e.EmployeeID, e.Name, e.Position, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Task 3: Product Inventory Status
CREATE VIEW InventoryStatus AS
SELECT p.ProductID, p.ProductName, i.StockQuantity, i.LastRestockDate
FROM Products p
JOIN Inventory i ON p.ProductID = i.ProductID;

-- Task 4: Simple Scalar Function
CREATE FUNCTION fn_GetFullName (@FirstName NVARCHAR(50), @LastName NVARCHAR(50))
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN @FirstName + ' ' + @LastName;
END;

-- Task 5: Inline Table-Valued Function
CREATE FUNCTION fn_GetHighSales (@Threshold DECIMAL(10,2))
RETURNS TABLE
AS
RETURN 
(
    SELECT * FROM Sales WHERE SalesAmount > @Threshold
);

-- Task 6: Multi-Statement Table-Valued Function
CREATE FUNCTION fn_GetCustomerStats ()
RETURNS @CustomerStats TABLE (CustomerID INT, TotalOrders INT, TotalSales DECIMAL(10,2))
AS
BEGIN
    INSERT INTO @CustomerStats
    SELECT CustomerID, COUNT(OrderID), SUM(OrderAmount)
    FROM Orders
    GROUP BY CustomerID;
    RETURN;
END;

-- Window Functions in SQL

-- Task 1: Cumulative Sales Calculation
SELECT CustomerID, OrderID, OrderAmount, 
       SUM(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- Task 2: Average Salary per Department
SELECT EmployeeID, DepartmentID, Salary,
       AVG(Salary) OVER (PARTITION BY DepartmentID) AS AvgSalary
FROM Employees;

-- Task 3: Partition By vs Group By
SELECT ProductCategory, OrderID, OrderAmount,
       SUM(OrderAmount) OVER (PARTITION BY ProductCategory ORDER BY OrderDate) AS CumulativeRevenue
FROM Orders;

SELECT ProductCategory, SUM(OrderAmount) AS TotalRevenue
FROM Orders
GROUP BY ProductCategory;

-- Task 4: ROW_NUMBER, RANK, and DENSE_RANK
SELECT StudentID, TestScore,
       ROW_NUMBER() OVER (ORDER BY TestScore DESC) AS RowNumber,
       RANK() OVER (ORDER BY TestScore DESC) AS Rank,
       DENSE_RANK() OVER (ORDER BY TestScore DESC) AS DenseRank
FROM Students;

-- Task 5: LEAD and LAG Functions
SELECT StockID, StockDate, Price,
       LAG(Price) OVER (PARTITION BY StockID ORDER BY StockDate) AS PrevPrice,
       LEAD(Price) OVER (PARTITION BY StockID ORDER BY StockDate) AS NextPrice
FROM StockPrices;

-- Task 6: NTILE Function
SELECT CustomerID, TotalSpending,
       NTILE(4) OVER (ORDER BY TotalSpending DESC) AS Quartile,
       NTILE(5) OVER (ORDER BY TotalSpending DESC) AS Quintile
FROM Customers;
