-- Easy Tasks

-- 1. Assign a row number to each employee ordered by Salary
SELECT EmployeeID, Salary, ROW_NUMBER() OVER (ORDER BY Salary) AS RowNum FROM Employees;

-- 2. Rank all products based on Price in descending order
SELECT ProductID, Price, RANK() OVER (ORDER BY Price DESC) AS Rank FROM Products;

-- 3. Rank employees by Salary using DENSE_RANK()
SELECT EmployeeID, Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Rank FROM Employees;

-- 4. Display the next salary in the same department using LEAD()
SELECT EmployeeID, DepartmentID, Salary, LEAD(Salary) OVER (PARTITION BY DepartmentID ORDER BY Salary) AS NextSalary FROM Employees;

-- 5. Assign a unique number to each order in the Orders table
SELECT OrderID, ROW_NUMBER() OVER (ORDER BY OrderDate) AS OrderNum FROM Orders;

-- 6. Identify the highest and second-highest salaries using RANK()
SELECT EmployeeID, Salary, RANK() OVER (ORDER BY Salary DESC) AS SalaryRank FROM Employees WHERE SalaryRank <= 2;

-- 7. Show the previous salary using LAG()
SELECT EmployeeID, Salary, LAG(Salary) OVER (ORDER BY Salary) AS PrevSalary FROM Employees;

-- 8. Divide employees into 4 groups based on Salary using NTILE(4)
SELECT EmployeeID, Salary, NTILE(4) OVER (ORDER BY Salary) AS SalaryGroup FROM Employees;

-- 9. Assign a row number within each department
SELECT EmployeeID, DepartmentID, ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary) AS DeptRowNum FROM Employees;

-- 10. Rank products by Price in ascending order using DENSE_RANK()
SELECT ProductID, Price, DENSE_RANK() OVER (ORDER BY Price) AS Rank FROM Products;

-- 11. Calculate moving average of Price in Products table
SELECT ProductID, Price, AVG(Price) OVER (ORDER BY ProductID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg FROM Products;

-- 12. Display the salary of the next employee using LEAD()
SELECT EmployeeID, Salary, LEAD(Salary) OVER (ORDER BY Salary) AS NextSalary FROM Employees;

-- 13. Compute cumulative sum of SalesAmount in Sales table
SELECT SaleID, SalesAmount, SUM(SalesAmount) OVER (ORDER BY SaleID) AS CumulativeSales FROM Sales;

-- 14. Identify the top 5 most expensive products
SELECT ProductID, Price, ROW_NUMBER() OVER (ORDER BY Price DESC) AS Rank FROM Products WHERE Rank <= 5;

-- 15. Calculate total OrderAmount per Customer
SELECT CustomerID, SUM(OrderAmount) OVER (PARTITION BY CustomerID) AS TotalOrderAmount FROM Orders;

-- 16. Rank orders by OrderAmount
SELECT OrderID, OrderAmount, RANK() OVER (ORDER BY OrderAmount DESC) AS Rank FROM Orders;

-- 17. Compute percentage contribution of SalesAmount by ProductCategory
SELECT ProductCategory, SalesAmount, SalesAmount * 100.0 / SUM(SalesAmount) OVER (PARTITION BY ProductCategory) AS Percentage FROM Sales;

-- 18. Retrieve next order date using LEAD()
SELECT OrderID, OrderDate, LEAD(OrderDate) OVER (ORDER BY OrderDate) AS NextOrderDate FROM Orders;

-- 19. Divide employees into 3 groups based on Age
SELECT EmployeeID, Age, NTILE(3) OVER (ORDER BY Age) AS AgeGroup FROM Employees;

-- 20. List the most recently hired employees
SELECT EmployeeID, HireDate, ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS HireRank FROM Employees;


--Medium Tasks

-- 1. Compute the cumulative average salary of employees, ordered by Salary
SELECT EmployeeID, Salary, 
       AVG(Salary) OVER (ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAvgSalary
FROM Employees;

-- 2. Rank products by their total sales while handling ties
SELECT ProductID, SUM(SalesAmount) AS TotalSales, 
       RANK() OVER (ORDER BY SUM(SalesAmount) DESC) AS SalesRank
FROM Sales
GROUP BY ProductID;

-- 3. Retrieve the previous order's date for each order
SELECT OrderID, CustomerID, OrderDate, 
       LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
FROM Orders;

-- 4. Calculate the moving sum of Price for products with a window frame of 3 rows
SELECT ProductID, Price, 
       SUM(Price) OVER (ORDER BY ProductID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingSum
FROM Products;

-- 5. Assign employees to four salary ranges using NTILE(4)
SELECT EmployeeID, Salary, 
       NTILE(4) OVER (ORDER BY Salary) AS SalaryRange
FROM Employees;

-- 6. Partition Sales table by ProductID and calculate total SalesAmount per product
SELECT ProductID, SUM(SalesAmount) AS TotalSalesAmount
FROM Sales
GROUP BY ProductID;

-- 7. Rank products by StockQuantity without gaps using DENSE_RANK()
SELECT ProductID, StockQuantity, 
       DENSE_RANK() OVER (ORDER BY StockQuantity DESC) AS StockRank
FROM Products;

-- 8. Identify the second highest salary in each department
SELECT EmployeeID, DepartmentID, Salary
FROM (SELECT EmployeeID, DepartmentID, Salary, 
             ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
      FROM Employees) AS Ranked
WHERE Rank = 2;

-- 9. Calculate the running total of sales for each product
SELECT ProductID, SalesAmount, 
       SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal
FROM Sales;

-- 10. Display the SalesAmount of the next row for each employee’s sale
SELECT EmployeeID, SalesAmount, 
       LEAD(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS NextSalesAmount
FROM Sales;

-- 11. Determine the highest earners within each department using RANK()
SELECT EmployeeID, DepartmentID, Salary, 
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
FROM Employees;

-- 12. Partition employees by DepartmentID and rank them by salary
SELECT EmployeeID, DepartmentID, Salary, 
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 13. Divide products into five groups based on their Price using NTILE(5)
SELECT ProductID, Price, 
       NTILE(5) OVER (ORDER BY Price) AS PriceGroup
FROM Products;

-- 14. Calculate the difference between each employee's salary and the highest salary in their department
SELECT EmployeeID, DepartmentID, Salary, 
       MAX(Salary) OVER (PARTITION BY DepartmentID) - Salary AS SalaryDifference
FROM Employees;

-- 15. Display the previous product's SalesAmount for each sale using LAG()
SELECT ProductID, SaleDate, SalesAmount, 
       LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS PreviousSalesAmount
FROM Sales;

-- 16. Calculate the cumulative sum of OrderAmount for each customer
SELECT CustomerID, OrderID, OrderAmount, 
       SUM(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS CumulativeOrderAmount
FROM Orders;

-- 17. Identify the 3rd most recent order for each customer
SELECT CustomerID, OrderID, OrderDate
FROM (SELECT CustomerID, OrderID, OrderDate, 
             ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS Rank
      FROM Orders) AS Ranked
WHERE Rank = 3;

-- 18. Rank employees by HireDate within each department
SELECT EmployeeID, DepartmentID, HireDate, 
       RANK() OVER (PARTITION BY DepartmentID ORDER BY HireDate) AS HireRank
FROM Employees;

-- 19. Find the 3rd highest Salary in each department using DENSE_RANK()
SELECT EmployeeID, DepartmentID, Salary
FROM (SELECT EmployeeID, DepartmentID, Salary, 
             DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
      FROM Employees) AS Ranked
WHERE Rank = 3;

-- 20. Calculate the difference in OrderDate between consecutive orders using LEAD()
SELECT OrderID, CustomerID, OrderDate, 
       LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) - OrderDate AS DateDifference
FROM Orders;

--Hard Questions

-- 1. Rank products by sales (handling ties) but exclude the top 10% of products by sales
WITH RankedProducts AS (
    SELECT 
        ProductID, 
        ProductName, 
        SalesAmount,
        RANK() OVER (ORDER BY SalesAmount DESC) AS SalesRank,
        COUNT(*) OVER () AS TotalProducts
    FROM Products
)
SELECT *
FROM RankedProducts
WHERE SalesRank > (TotalProducts * 0.1);

-- 2. List employees with over 5 years of service, ordered by HireDate using ROW_NUMBER()
SELECT 
    EmployeeID, 
    EmployeeName, 
    HireDate,
    ROW_NUMBER() OVER (ORDER BY HireDate) AS RowNum
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5;

-- 3. Divide employees into 10 groups based on Salary using NTILE(10)
SELECT 
    EmployeeID, 
    EmployeeName, 
    Salary,
    NTILE(10) OVER (ORDER BY Salary) AS SalaryGroup
FROM Employees;

-- 4. Calculate next SalesAmount for each sale by an employee using LEAD()
SELECT 
    EmployeeID, 
    SaleID, 
    SalesAmount, 
    LEAD(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS NextSalesAmount
FROM Sales;

-- 5. Compute average Price for each category
SELECT 
    CategoryID, 
    AVG(Price) AS AvgPrice
FROM Products
GROUP BY CategoryID;

-- 6. Determine the top 3 most-sold products using RANK()
SELECT 
    ProductID, 
    ProductName, 
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM Products
WHERE SalesRank <= 3;

-- 7. List top 5 highest-paid employees from each department using ROW_NUMBER()
SELECT * FROM (
    SELECT 
        EmployeeID, 
        EmployeeName, 
        Salary, 
        DepartmentID,
        ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
    FROM Employees
) RankedEmployees
WHERE Rank <= 5;

-- 8. Compute moving average of sales over a 5-day window using LEAD() and LAG()
SELECT 
    SaleID, 
    EmployeeID, 
    SalesAmount,
    AVG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS MovingAvg
FROM Sales;

-- 9. Find top 5 highest sales figures using DENSE_RANK()
SELECT 
    ProductID, 
    ProductName, 
    SalesAmount,
    DENSE_RANK() OVER (ORDER BY SalesAmount DESC) AS Rank
FROM Products
WHERE Rank <= 5;

-- 10. Partition orders by OrderAmount into four quartiles using NTILE(4)
SELECT 
    OrderID, 
    CustomerID, 
    OrderAmount,
    NTILE(4) OVER (ORDER BY OrderAmount) AS Quartile
FROM Orders;

-- 11. Assign a unique sequence to each order within each CustomerID using ROW_NUMBER()
SELECT 
    OrderID, 
    CustomerID, 
    OrderDate,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS OrderRank
FROM Orders;

-- 12. Calculate total employees in each department
SELECT 
    DepartmentID, 
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;

-- 13. List top 3 highest and bottom 3 salaries within each department using RANK()
WITH RankedSalaries AS (
    SELECT 
        EmployeeID, 
        EmployeeName, 
        Salary, 
        DepartmentID,
        RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS TopRank,
        RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary ASC) AS BottomRank
    FROM Employees
)
SELECT *
FROM RankedSalaries
WHERE TopRank <= 3 OR BottomRank <= 3;

-- 14. Calculate percentage change in SalesAmount from the previous sale using LAG()
SELECT 
    EmployeeID, 
    SaleID, 
    SalesAmount,
    LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS PrevSales,
    (SalesAmount - LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate)) * 100.0 / LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS PercentChange
FROM Sales;

-- 15. Compute cumulative sum and average of sales for each product
SELECT 
    ProductID, 
    SaleID, 
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeSum,
    AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeAvg
FROM Sales;

-- 16. Rank employees by Age using NTILE(3)
SELECT 
    EmployeeID, 
    EmployeeName, 
    Age,
    NTILE(3) OVER (ORDER BY Age) AS AgeGroup
FROM Employees;

-- 17. Identify top 10 employees with highest sales using ROW_NUMBER()
SELECT * FROM (
    SELECT 
        EmployeeID, 
        EmployeeName, 
        SalesAmount,
        ROW_NUMBER() OVER (ORDER BY SalesAmount DESC) AS Rank
    FROM Employees
) RankedEmployees
WHERE Rank <= 10;

-- 18. Calculate price difference between each product and the next one using LEAD()
SELECT 
    ProductID, 
    ProductName, 
    Price,
    LEAD(Price) OVER (ORDER BY Price) - Price AS PriceDifference
FROM Products;

-- 19. Rank employees based on performance score using DENSE_RANK()
SELECT 
    EmployeeID, 
    EmployeeName, 
    PerformanceScore,
    DENSE_RANK() OVER (ORDER BY PerformanceScore DESC) AS PerformanceRank
FROM Employees;

-- 20. Determine difference in SalesAmount relative to previous and next orders using LAG() and LEAD()
SELECT 
    OrderID, 
    ProductID, 
    SalesAmount,
    LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate) AS PrevSales,
    LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate) AS NextSales,
    SalesAmount - LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate) AS ChangeFromPrev,
    LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate) - SalesAmount AS ChangeToNext
FROM Orders;