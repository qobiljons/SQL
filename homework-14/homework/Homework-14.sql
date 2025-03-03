create database hometask
use hometask

-- Creating tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary DECIMAL(10,2),
    Department VARCHAR(100),
    HireDate DATE
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT
);

-- Inserting sample data
INSERT INTO Employees VALUES (1, 'Alice', 50000, 'Sales', '2018-03-15');
INSERT INTO Employees VALUES (2, 'Bob', 60000, 'IT', '2015-06-20');
INSERT INTO Employees VALUES (3, 'Charlie', 55000, 'Sales', '2019-07-10');

INSERT INTO Customers VALUES (1, 'Customer A');
INSERT INTO Customers VALUES (2, 'Customer B');
INSERT INTO Customers VALUES (3, 'Customer C');

INSERT INTO Products VALUES (1, 'Product X', 100);
INSERT INTO Products VALUES (2, 'Product Y', 200);
INSERT INTO Products VALUES (3, 'Product Z', 300);

INSERT INTO Orders VALUES (1, 1, 1, '2024-02-01');
INSERT INTO Orders VALUES (2, 2, 1, '2024-02-02');
INSERT INTO Orders VALUES (3, 3, 3, '2024-02-03');

INSERT INTO OrderDetails VALUES (1, 1, 1, 3);
INSERT INTO OrderDetails VALUES (2, 1, 2, 2);
INSERT INTO OrderDetails VALUES (3, 2, 3, 1);
INSERT INTO OrderDetails VALUES (4, 3, 1, 5);

-- 1. Total sales per employee using a derived table
SELECT e.Name, SUM(od.Quantity * p.Price) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY e.Name;

-- 2. Average salary using CTE
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT * FROM AvgSalary;

-- 3. Highest sales for each product using a derived table
SELECT ProductID, MAX(TotalSales) AS HighestSales
FROM (
    SELECT od.ProductID, SUM(od.Quantity * p.Price) AS TotalSales
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID
) AS ProductSales
GROUP BY ProductID;

-- 4. Employees with more than 5 sales using CTE
WITH SalesCount AS (
    SELECT e.EmployeeID, e.Name, COUNT(o.OrderID) AS SalesCount
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.EmployeeID, e.Name
)
SELECT Name FROM SalesCount WHERE SalesCount > 5;

-- 5. Top 5 customers by total purchase amount using a derived table
SELECT TOP 5 c.Name, SUM(od.Quantity * p.Price) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.Name
ORDER BY TotalSpent DESC;

-- 6. Products with sales greater than $500 using CTE
WITH ProductSales AS (
    SELECT p.Name, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.Name
)
SELECT Name FROM ProductSales WHERE TotalSales > 500;

-- 7. Total number of orders per customer using a derived table
SELECT CustomerID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;

-- 8. Employees with salaries above average using CTE
WITH AvgSal AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT Name FROM Employees WHERE Salary > (SELECT AvgSalary FROM AvgSal);

-- 9. Total number of products sold using a derived table
SELECT SUM(Quantity) AS TotalProductsSold FROM OrderDetails;

-- 10. Employees who have not made any sales using CTE
WITH NoSales AS (
    SELECT e.Name FROM Employees e
    LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE o.OrderID IS NULL
)
SELECT Name FROM NoSales;

-- 16. Number of employees in each department using CTE
WITH DeptCount AS (
    SELECT Department, COUNT(EmployeeID) AS EmployeeCount
    FROM Employees
    GROUP BY Department
)
SELECT * FROM DeptCount;

-- 17. Top-selling products in the last quarter using a derived table
SELECT ProductID, SUM(Quantity) AS TotalSold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
WHERE OrderDate >= DATEADD(QUARTER, -1, GETDATE())
GROUP BY ProductID
ORDER BY TotalSold DESC;

-- 18. Employees with sales higher than $1000 using CTE
WITH EmployeeSales AS (
    SELECT e.Name, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY e.Name
)
SELECT Name FROM EmployeeSales WHERE TotalSales > 1000;

-- 19. Number of orders made by each customer using a derived table
SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID;

-- 20. Total sales per employee for the last month using CTE
WITH LastMonthSales AS (
    SELECT e.Name, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE OrderDate >= DATEADD(MONTH, -1, GETDATE())
    GROUP BY e.Name
)
SELECT * FROM LastMonthSales;

-- Creating tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary DECIMAL(10,2),
    Department VARCHAR(100),
    HireDate DATE,
    ManagerID INT NULL
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Region VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100),
    Price DECIMAL(10,2),
    CategoryID INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT
);

-- Inserting sample data
INSERT INTO Employees VALUES (1, 'Alice', 50000, 'Sales', '2018-03-15', NULL);
INSERT INTO Employees VALUES (2, 'Bob', 60000, 'IT', '2015-06-20', NULL);
INSERT INTO Employees VALUES (3, 'Charlie', 55000, 'Sales', '2019-07-10', 1);

INSERT INTO Customers VALUES (1, 'Customer A', 'North');
INSERT INTO Customers VALUES (2, 'Customer B', 'South');
INSERT INTO Customers VALUES (3, 'Customer C', 'East');

INSERT INTO Products VALUES (1, 'Product X', 100, 1);
INSERT INTO Products VALUES (2, 'Product Y', 200, 2);
INSERT INTO Products VALUES (3, 'Product Z', 300, 1);

INSERT INTO Orders VALUES (1, 1, 1, '2024-02-01');
INSERT INTO Orders VALUES (2, 2, 1, '2024-02-02');
INSERT INTO Orders VALUES (3, 3, 3, '2024-02-03');

INSERT INTO OrderDetails VALUES (1, 1, 1, 3);
INSERT INTO OrderDetails VALUES (2, 1, 2, 2);
INSERT INTO OrderDetails VALUES (3, 2, 3, 1);
INSERT INTO OrderDetails VALUES (4, 3, 1, 5);

-- 21. Running total of sales per employee using CTE
WITH RunningSales AS (
    SELECT EmployeeID, OrderDate, SUM(od.Quantity * p.Price) OVER (PARTITION BY EmployeeID ORDER BY OrderDate) AS RunningTotal
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
)
SELECT * FROM RunningSales;

-- 22. Generate sequence of numbers from 1 to 10 using recursive CTE
WITH Numbers AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1 FROM Numbers WHERE Num < 10
)
SELECT * FROM Numbers;

-- 23. Average sales per region using derived table
SELECT Region, AVG(TotalSales) AS AverageSales FROM (
    SELECT c.Region, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.Region
) AS SalesData GROUP BY Region;

-- 24. Rank employees based on total sales using CTE
WITH EmployeeRank AS (
    SELECT e.Name, SUM(od.Quantity * p.Price) AS TotalSales,
           RANK() OVER (ORDER BY SUM(od.Quantity * p.Price) DESC) AS Rank
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY e.Name
)
SELECT * FROM EmployeeRank;

-- 25. Top 5 employees by number of orders using derived table
SELECT TOP 5 EmployeeID, COUNT(OrderID) AS OrderCount FROM (
    SELECT EmployeeID, COUNT(OrderID) AS OrderCount
    FROM Orders
    GROUP BY EmployeeID
) AS OrderCounts ORDER BY OrderCount DESC;

-- 26. List employees reporting to a specific manager using recursive CTE
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, Name, ManagerID FROM Employees WHERE ManagerID = @ManagerID
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy;

-- 27. Sales difference between current and previous month using CTE
WITH SalesDiff AS (
    SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(od.Quantity * p.Price) AS MonthlySales,
           LAG(SUM(od.Quantity * p.Price)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS PreviousMonthSales
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT *, MonthlySales - PreviousMonthSales AS SalesDifference FROM SalesDiff;

-- 28. Employees with highest sales in each department using derived table
SELECT Department, Name, TotalSales FROM (
    SELECT e.Department, e.Name, SUM(od.Quantity * p.Price) AS TotalSales,
           RANK() OVER (PARTITION BY e.Department ORDER BY SUM(od.Quantity * p.Price) DESC) AS Rank
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY e.Department, e.Name
) AS SalesRank WHERE Rank = 1;

-- 29. Find all ancestors of an employee in a hierarchical organization using recursive CTE
WITH Ancestors AS (
    SELECT EmployeeID, Name, ManagerID FROM Employees WHERE EmployeeID = @EmployeeID
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID FROM Employees e
    JOIN Ancestors a ON e.EmployeeID = a.ManagerID
)
SELECT * FROM Ancestors;

-- 30. Employees who have not sold anything in the last year using CTE
WITH NoSales AS (
    SELECT e.EmployeeID, e.Name FROM Employees e
    LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
    WHERE o.OrderID IS NULL
)
SELECT * FROM NoSales;

-- 31. Total sales per region and year using derived table
SELECT Year, Region, SUM(TotalSales) AS TotalSales FROM (
    SELECT YEAR(o.OrderDate) AS Year, c.Region, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY YEAR(o.OrderDate), c.Region
) AS SalesData GROUP BY Year, Region;

-- 32. Factorial of a number using recursive CTE
WITH FactorialCTE (Num, Fact) AS (
    SELECT 1, 1
    UNION ALL
    SELECT Num + 1, Fact * (Num + 1) FROM FactorialCTE WHERE Num < 10
)
SELECT * FROM FactorialCTE;

-- 33. Customers with more than 10 orders using derived table
SELECT CustomerID, COUNT(OrderID) AS OrderCount FROM (
    SELECT CustomerID, COUNT(OrderID) AS OrderCount FROM Orders GROUP BY CustomerID
) AS OrderCounts WHERE OrderCount > 10;

-- 34. Traverse product category hierarchy using recursive CTE
WITH CategoryHierarchy AS (
    SELECT CategoryID, ParentCategoryID FROM Categories WHERE ParentCategoryID IS NULL
    UNION ALL
    SELECT c.CategoryID, c.ParentCategoryID FROM Categories c
    JOIN CategoryHierarchy ch ON c.ParentCategoryID = ch.CategoryID
)
SELECT * FROM CategoryHierarchy;

-- 35. Rank products by total sales in the last year using CTE
WITH ProductSales AS (
    SELECT p.ProductID, p.Name, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY p.ProductID, p.Name
)
SELECT *, RANK() OVER (ORDER BY TotalSales DESC) AS Rank FROM ProductSales;

-- 36. Sales per product category using derived table
SELECT CategoryID, SUM(TotalSales) AS CategorySales FROM (
    SELECT p.CategoryID, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    GROUP BY p.CategoryID
) AS SalesData GROUP BY CategoryID;

-- 37. Employees with highest sales growth compared to last year using CTE
WITH SalesGrowth AS (
    SELECT e.EmployeeID, e.Name,
           SUM(CASE WHEN YEAR(o.OrderDate) = YEAR(GETDATE()) - 1 THEN od.Quantity * p.Price ELSE 0 END) AS LastYearSales,
           SUM(CASE WHEN YEAR(o.OrderDate) = YEAR(GETDATE()) THEN od.Quantity * p.Price ELSE 0 END) AS ThisYearSales
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY e.EmployeeID, e.Name
)
SELECT *, (ThisYearSales - LastYearSales) AS SalesGrowth FROM SalesGrowth ORDER BY SalesGrowth DESC;

-- 38. Employees with sales over $5000 per quarter using derived table
SELECT EmployeeID, Quarter, SUM(TotalSales) AS QuarterlySales FROM (
    SELECT e.EmployeeID, DATEPART(QUARTER, o.OrderDate) AS Quarter, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY e.EmployeeID, DATEPART(QUARTER, o.OrderDate)
) AS SalesData WHERE QuarterlySales > 5000 GROUP BY EmployeeID, Quarter;

-- 39. Descendants of a product in category tree using recursive CTE
WITH ProductDescendants AS (
    SELECT ProductID, CategoryID FROM Products WHERE CategoryID = @CategoryID
    UNION ALL
    SELECT p.ProductID, p.CategoryID FROM Products p
    JOIN ProductDescendants pd ON p.CategoryID = pd.ProductID
)
SELECT * FROM ProductDescendants;

-- 40. Top 3 employees by total sales in last month using derived table
SELECT TOP 3 EmployeeID, SUM(TotalSales) AS TotalSales FROM (
    SELECT e.EmployeeID, SUM(od.Quantity * p.Price) AS TotalSales
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE o.OrderDate >= DATEADD(MONTH, -1, GETDATE())
    GROUP BY e.EmployeeID
) AS SalesData ORDER BY TotalSales DESC;

-- Create and populate tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    ManagerID INT,
    Sales DECIMAL(10,2),
    DepartmentID INT,
    Region VARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    SaleAmount DECIMAL(10,2),
    SaleDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100),
    ParentProductID INT NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2),
    TaxRate DECIMAL(5,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Fibonacci Sequence
WITH Fibonacci (n, f1, f2) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n + 1, f2, f1 + f2
    FROM Fibonacci
    WHERE n < 20
)
SELECT n, f1 FROM Fibonacci;

-- Cumulative Sales of Employees
WITH CumulativeSales AS (
    SELECT EmployeeID, SUM(SaleAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY EmployeeID
)
SELECT * FROM CumulativeSales;

-- Find all subordinates of a manager
WITH Subordinates AS (
    SELECT EmployeeID, Name, ManagerID FROM Employees WHERE ManagerID = @ManagerID
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID FROM Employees e
    JOIN Subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT * FROM Subordinates;

-- Employees with sales above company average per region
WITH RegionSales AS (
    SELECT Region, AVG(Sales) AS AvgSales FROM Employees GROUP BY Region
)
SELECT e.* FROM Employees e
JOIN RegionSales rs ON e.Region = rs.Region
WHERE e.Sales > rs.AvgSales;

-- Calculate depth of a product hierarchy
WITH ProductHierarchy AS (
    SELECT ProductID, Name, ParentProductID, 1 AS Depth FROM Products WHERE ParentProductID IS NULL
    UNION ALL
    SELECT p.ProductID, p.Name, p.ParentProductID, ph.Depth + 1 FROM Products p
    JOIN ProductHierarchy ph ON p.ParentProductID = ph.ProductID
)
SELECT * FROM ProductHierarchy;

-- Sales totals by department and product
WITH DepartmentSales AS (
    SELECT DepartmentID, SUM(Sales) AS TotalSales FROM Employees GROUP BY DepartmentID
),
ProductSales AS (
    SELECT EmployeeID, SUM(SaleAmount) AS TotalSales FROM Sales GROUP BY EmployeeID
)
SELECT d.*, p.TotalSales FROM DepartmentSales d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
JOIN ProductSales p ON e.EmployeeID = p.EmployeeID;

-- List all direct and indirect reports of a manager
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, ManagerID FROM Employees WHERE ManagerID = @ManagerID
    UNION ALL
    SELECT e.EmployeeID, e.ManagerID FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy;

-- Employees with most sales in last 6 months
WITH Last6MonthsSales AS (
    SELECT EmployeeID, SUM(SaleAmount) AS TotalSales FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
)
SELECT * FROM Last6MonthsSales ORDER BY TotalSales DESC;

-- Total cost of an order including taxes and discounts
WITH OrderCost AS (
    SELECT OrderID, (Quantity * UnitPrice * (1 - Discount) * (1 + TaxRate)) AS TotalCost FROM Orders
)
SELECT * FROM OrderCost;

-- Employees with largest sales growth rate
WITH SalesGrowth AS (
    SELECT EmployeeID, (SUM(SaleAmount) - LAG(SUM(SaleAmount)) OVER (PARTITION BY EmployeeID ORDER BY YEAR(SaleDate))) / NULLIF(LAG(SUM(SaleAmount)) OVER (PARTITION BY EmployeeID ORDER BY YEAR(SaleDate)), 0) AS GrowthRate
    FROM Sales
    GROUP BY EmployeeID, YEAR(SaleDate)
)
SELECT * FROM SalesGrowth ORDER BY GrowthRate DESC;

-- Total sales per employee over all years
WITH EmployeeSales AS (
    SELECT EmployeeID, SUM(SaleAmount) AS TotalSales FROM Sales GROUP BY EmployeeID
)
SELECT * FROM EmployeeSales;

-- Highest-selling product and the employee who sold it
WITH ProductSales AS (
    SELECT EmployeeID, ProductID, SUM(SaleAmount) AS TotalSales FROM Sales GROUP BY EmployeeID, ProductID
),
TopSale AS (
    SELECT TOP 1 * FROM ProductSales ORDER BY TotalSales DESC
)
SELECT * FROM TopSale;

-- All generations of an organization’s hierarchy
WITH OrgHierarchy AS (
    SELECT EmployeeID, Name, ManagerID, 1 AS Level FROM Employees WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID, oh.Level + 1 FROM Employees e
    JOIN OrgHierarchy oh ON e.ManagerID = oh.EmployeeID
)
SELECT * FROM OrgHierarchy;

-- Employees with sales greater than department average
WITH DeptSales AS (
    SELECT DepartmentID, AVG(Sales) AS AvgSales FROM Employees GROUP BY DepartmentID
)
SELECT e.* FROM Employees e
JOIN DeptSales ds ON e.DepartmentID = ds.DepartmentID
WHERE e.Sales > ds.AvgSales;

-- Average sales per employee by region
WITH AvgSales AS (
    SELECT Region, AVG(Sales) AS AvgSales FROM Employees WHERE Sales > 0 GROUP BY Region
)
SELECT * FROM AvgSales;

-- Employees reporting to a specific manager
WITH EmployeeReports AS (
    SELECT EmployeeID, ManagerID FROM Employees WHERE ManagerID = @ManagerID
    UNION ALL
    SELECT e.EmployeeID, e.ManagerID FROM Employees e
    JOIN EmployeeReports er ON e.ManagerID = er.EmployeeID
)
SELECT * FROM EmployeeReports;

-- Average products sold per employee in last year
WITH AvgProducts AS (
    SELECT EmployeeID, AVG(Quantity) AS AvgProducts FROM Orders WHERE OrderDate >= DATEADD(YEAR, -1, GETDATE()) GROUP BY EmployeeID
)
SELECT * FROM AvgProducts;

-- Departments reporting to a parent department
WITH DeptHierarchy AS (
    SELECT DepartmentID, ParentDepartmentID FROM Departments WHERE ParentDepartmentID = @ParentDeptID
    UNION ALL
    SELECT d.DepartmentID, d.ParentDepartmentID FROM Departments d
    JOIN DeptHierarchy dh ON d.ParentDepartmentID = dh.DepartmentID
)
SELECT * FROM DeptHierarchy;

-- Number of levels in product category hierarchy
WITH CategoryLevels AS (
    SELECT ProductID, ParentProductID, 1 AS Level FROM Products WHERE ParentProductID IS NULL
    UNION ALL
    SELECT p.ProductID, p.ParentProductID, cl.Level + 1 FROM Products p
    JOIN CategoryLevels cl ON p.ParentProductID = cl.ProductID
)
SELECT MAX(Level) FROM CategoryLevels;