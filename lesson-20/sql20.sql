1. -- Running total of SalesAmount for each product  
   SELECT ProductID, SaleDate, SalesAmount,  
          SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal  
   FROM Sales;

2. -- Cumulative sum of Amount for each customer in Orders table  
   SELECT CustomerID, OrderDate, Amount,  
          SUM(Amount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS CumulativeSum  
   FROM Orders;

3. -- Running total of OrderAmount in Orders table, partitioned by CustomerID  
   SELECT CustomerID, OrderDate, OrderAmount,  
          SUM(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal  
   FROM Orders;

4. -- Average sales amount up to the current row for each product  
   SELECT ProductID, SaleDate, SalesAmount,  
          AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningAvg  
   FROM Sales;

5. -- Rank each order’s OrderAmount using RANK()  
   SELECT OrderID, CustomerID, OrderAmount,  
          RANK() OVER (ORDER BY OrderAmount DESC) AS OrderRank  
   FROM Orders;

6. -- Retrieve the next row's Amount for each product  
   SELECT ProductID, SaleDate, SalesAmount,  
          LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS NextSalesAmount  
   FROM Sales;

7. -- Total sales for each customer using SUM() as a window function  
   SELECT CustomerID, OrderID, OrderAmount,  
          SUM(OrderAmount) OVER (PARTITION BY CustomerID) AS TotalSales  
   FROM Orders;

8. -- Count of orders placed up to the current row  
   SELECT CustomerID, OrderDate, OrderID,  
          COUNT(OrderID) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningOrderCount  
   FROM Orders;

9. -- Running total of SalesAmount partitioned by ProductCategory  
   SELECT ProductCategory, ProductID, SaleDate, SalesAmount,  
          SUM(SalesAmount) OVER (PARTITION BY ProductCategory ORDER BY SaleDate) AS RunningTotal  
   FROM Sales;

10. -- Assign a unique rank to each order using ROW_NUMBER()  
    SELECT OrderID, CustomerID, OrderDate,  
           ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNum  
    FROM Orders;

11. -- OrderAmount from the previous row using LAG()  
    SELECT OrderID, CustomerID, OrderAmount,  
           LAG(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderAmount  
    FROM Orders;

12. -- Divide products into 4 equal groups based on Price using NTILE(4)  
    SELECT ProductID, ProductName, Price,  
           NTILE(4) OVER (ORDER BY Price) AS PriceGroup  
    FROM Products;

13. -- Cumulative total of sales for each salesperson  
    SELECT SalespersonID, SaleDate, SalesAmount,  
           SUM(SalesAmount) OVER (PARTITION BY SalespersonID ORDER BY SaleDate) AS CumulativeSales  
    FROM Sales;

14. -- Rank products based on StockQuantity using DENSE_RANK()  
    SELECT ProductID, ProductName, StockQuantity,  
           DENSE_RANK() OVER (ORDER BY StockQuantity DESC) AS StockRank  
    FROM Products;

15. -- Compute the difference between the current and next OrderAmount  
    SELECT OrderID, CustomerID, OrderAmount,  
           LEAD(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) - OrderAmount AS AmountDifference  
    FROM Orders;

16. -- Rank products based on Price using RANK()  
    SELECT ProductID, ProductName, Price,  
           RANK() OVER (ORDER BY Price DESC) AS PriceRank  
    FROM Products;

17. -- Average order amount for each customer  
    SELECT CustomerID, OrderID, OrderAmount,  
           AVG(OrderAmount) OVER (PARTITION BY CustomerID) AS AvgOrderAmount  
    FROM Orders;

18. -- Assign a unique row number to each employee ordered by Salary  
    SELECT EmployeeID, EmployeeName, Salary,  
           ROW_NUMBER() OVER (ORDER BY Salary DESC) AS SalaryRank  
    FROM Employees;

19. -- Cumulative sum of SalesAmount for each store  
    SELECT StoreID, SaleDate, SalesAmount,  
           SUM(SalesAmount) OVER (PARTITION BY StoreID ORDER BY SaleDate) AS RunningTotal  
    FROM Sales;

20. -- Previous order's OrderAmount using LAG()  
    SELECT OrderID, CustomerID, OrderAmount,  
           LAG(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderAmount  
    FROM Orders;
--medium tasks

1. -- Cumulative sum of SalesAmount for each employee  
   SELECT EmployeeID, SaleDate, SalesAmount,  
          SUM(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS CumulativeSales  
   FROM Sales;

2. -- Difference in OrderAmount between the current and next row using LEAD()  
   SELECT OrderID, CustomerID, OrderAmount,  
          LEAD(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) - OrderAmount AS AmountDifference  
   FROM Orders;

3. -- Top 5 products based on SalesAmount using ROW_NUMBER()  
   SELECT ProductID, ProductName, SalesAmount  
   FROM (  
       SELECT ProductID, ProductName, SalesAmount,  
              ROW_NUMBER() OVER (ORDER BY SalesAmount DESC) AS Rank  
       FROM Sales  
   ) Ranked  
   WHERE Rank <= 5;

4. -- Top 10 products based on SalesAmount using RANK()  
   SELECT ProductID, ProductName, SalesAmount  
   FROM (  
       SELECT ProductID, ProductName, SalesAmount,  
              RANK() OVER (ORDER BY SalesAmount DESC) AS Rank  
       FROM Products  
   ) Ranked  
   WHERE Rank <= 10;

5. -- Number of orders per product using COUNT()  
   SELECT ProductID, COUNT(OrderID) AS OrderCount  
   FROM Sales  
   GROUP BY ProductID;

6. -- Running total of SalesAmount for each ProductCategory  
   SELECT ProductCategory, ProductID, SaleDate, SalesAmount,  
          SUM(SalesAmount) OVER (PARTITION BY ProductCategory ORDER BY SaleDate) AS RunningTotal  
   FROM Sales;

7. -- Rank employees by Salary within each DepartmentID using DENSE_RANK()  
   SELECT EmployeeID, DepartmentID, Salary,  
          DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank  
   FROM Employees;

8. -- Moving average of SalesAmount for each product  
   SELECT ProductID, SaleDate, SalesAmount,  
          AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg  
   FROM Sales;

9. -- Divide products into 3 groups based on Price using NTILE(3)  
   SELECT ProductID, ProductName, Price,  
          NTILE(3) OVER (ORDER BY Price) AS PriceGroup  
   FROM Products;

10. -- Previous SalesAmount for each employee using LAG()  
    SELECT EmployeeID, SaleDate, SalesAmount,  
           LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS PreviousSalesAmount  
    FROM Sales;

11. -- Cumulative sum of SalesAmount for each salesperson, ordered by SaleDate  
    SELECT SalespersonID, SaleDate, SalesAmount,  
           SUM(SalesAmount) OVER (PARTITION BY SalespersonID ORDER BY SaleDate) AS CumulativeSales  
    FROM Sales;

12. -- Retrieve the SalesAmount of the next sale for each product using LEAD()  
    SELECT ProductID, SaleDate, SalesAmount,  
           LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS NextSalesAmount  
    FROM Sales;

13. -- Moving sum of SalesAmount for each product  
    SELECT ProductID, SaleDate, SalesAmount,  
           SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingSum  
    FROM Products;

14. -- Top 3 employees based on Salary using RANK()  
    SELECT EmployeeID, EmployeeName, Salary  
    FROM (  
        SELECT EmployeeID, EmployeeName, Salary,  
               RANK() OVER (ORDER BY Salary DESC) AS SalaryRank  
        FROM Employees  
    ) Ranked  
    WHERE SalaryRank <= 3;

15. -- Average order amount for each customer  
    SELECT CustomerID, OrderID, OrderAmount,  
           AVG(OrderAmount) OVER (PARTITION BY CustomerID) AS AvgOrderAmount  
    FROM Orders;

16. -- Assign a unique row number to orders, ordered by OrderDate  
    SELECT OrderID, CustomerID, OrderDate,  
           ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNum  
    FROM Orders;

17. -- Running total of SalesAmount for each employee, partitioned by DepartmentID  
    SELECT EmployeeID, DepartmentID, SaleDate, SalesAmount,  
           SUM(SalesAmount) OVER (PARTITION BY DepartmentID, EmployeeID ORDER BY SaleDate) AS RunningTotal  
    FROM Sales;

18. -- Divide employees into 5 equal groups based on Salary using NTILE(5)  
    SELECT EmployeeID, EmployeeName, Salary,  
           NTILE(5) OVER (ORDER BY Salary) AS SalaryGroup  
    FROM Employees;

19. -- Cumulative sum and total sales for each product  
    SELECT ProductID, SaleDate, SalesAmount,  
           SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeSales,  
           SUM(SalesAmount) OVER (PARTITION BY ProductID) AS TotalSales  
    FROM Sales;

20. -- Identify the top 5 products based on SalesAmount using DENSE_RANK()  
    SELECT ProductID, ProductName, SalesAmount  
    FROM (  
        SELECT ProductID, ProductName, SalesAmount,  
               DENSE_RANK() OVER (ORDER BY SalesAmount DESC) AS Rank  
        FROM Sales  
    ) Ranked  
    WHERE Rank <= 5;
--Hard tasks

1. -- Running total of SalesAmount for each product
   UPDATE Sales
   SET RunningTotal = (
       SELECT SUM(SalesAmount) 
       OVER (PARTITION BY ProductID ORDER BY SaleDate) 
   );

2. -- Percentage change in OrderAmount between current and next row using LEAD()
   SELECT OrderID, OrderAmount, 
          LEAD(OrderAmount) OVER (ORDER BY OrderDate) AS NextOrderAmount, 
          ((LEAD(OrderAmount) OVER (ORDER BY OrderDate) - OrderAmount) / NULLIF(OrderAmount, 0)) * 100 AS PercentageChange
   FROM Orders;

3. -- Top 3 products by SalesAmount using ROW_NUMBER()
   SELECT ProductID, ProductName, SalesAmount
   FROM (
       SELECT ProductID, ProductName, SalesAmount, 
              ROW_NUMBER() OVER (ORDER BY SalesAmount DESC) AS RowNum
       FROM Sales
   ) Ranked
   WHERE RowNum <= 3;

4. -- Rank employees by Salary within each DepartmentID using RANK()
   SELECT EmployeeID, DepartmentID, Salary,
          RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
   FROM Employees;

5. -- Top 10% of orders based on OrderAmount using NTILE()
   SELECT OrderID, CustomerID, OrderAmount
   FROM (
       SELECT OrderID, CustomerID, OrderAmount,
              NTILE(10) OVER (ORDER BY OrderAmount DESC) AS RankGroup
       FROM Orders
   ) Ranked
   WHERE RankGroup = 1;

6. -- Change in SalesAmount between the previous and current sale for each product using LAG()
   SELECT ProductID, SaleDate, SalesAmount,
          SalesAmount - LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS ChangeFromPrevious
   FROM Sales;

7. -- Cumulative average of SalesAmount for each product
   SELECT ProductID, SaleDate, SalesAmount,
          AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAvg
   FROM Sales;

8. -- Top 5 products with highest SalesAmount using DENSE_RANK(), ignoring ties
   SELECT ProductID, ProductName, SalesAmount
   FROM (
       SELECT ProductID, ProductName, SalesAmount, 
              DENSE_RANK() OVER (ORDER BY SalesAmount DESC) AS Rank
       FROM Products
   ) Ranked
   WHERE Rank <= 5;

9. -- Running total of SalesAmount partitioned by ProductCategory
   SELECT ProductCategory, ProductID, SaleDate, SalesAmount,
          SUM(SalesAmount) OVER (PARTITION BY ProductCategory ORDER BY SaleDate) AS RunningTotal
   FROM Sales;

10. -- Difference in OrderAmount between the previous and next rows using LEAD() and LAG()
    SELECT OrderID, OrderAmount,
           OrderAmount - LAG(OrderAmount) OVER (ORDER BY OrderDate) AS DifferenceFromPrevious,
           LEAD(OrderAmount) OVER (ORDER BY OrderDate) - OrderAmount AS DifferenceToNext
    FROM Orders;

11. -- Cumulative total of SalesAmount for each salesperson
    SELECT SalespersonID, SaleDate, SalesAmount,
           SUM(SalesAmount) OVER (PARTITION BY SalespersonID ORDER BY SaleDate) AS CumulativeSales
    FROM Sales;

12. -- Divide products into 10 groups based on Price using NTILE(10)
    SELECT ProductID, ProductName, Price,
           NTILE(10) OVER (ORDER BY Price) AS PriceGroup
    FROM Products;

13. -- Moving average of OrderAmount using AVG()
    SELECT OrderID, OrderAmount,
           AVG(OrderAmount) OVER (ORDER BY OrderDate ROWS 
14. -- Rank employees by Salary within each department using ROW_NUMBER()
    SELECT EmployeeID, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
    FROM Employees;

15. -- Number of orders per customer using COUNT()
    SELECT CustomerID, COUNT(OrderID) AS OrderCount
    FROM Orders
    GROUP BY CustomerID;

16. -- Identify top 3 products by SalesAmount considering ties using RANK()
    SELECT ProductID, ProductName, SalesAmount
    FROM (
        SELECT ProductID, ProductName, SalesAmount, 
               RANK() OVER (ORDER BY SalesAmount DESC) AS Rank
        FROM Sales
    ) Ranked
    WHERE Rank <= 3;

17. -- Cumulative sales total for each employee and product
    SELECT EmployeeID, ProductID, SaleDate, SalesAmount,
           SUM(SalesAmount) OVER (PARTITION BY EmployeeID, ProductID ORDER BY SaleDate) AS CumulativeSales
    FROM Sales;

18. -- Identify employees with highest sales in each department using DENSE_RANK()
    SELECT EmployeeID, DepartmentID, SalesAmount,
           DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY SalesAmount DESC) AS SalesRank
    FROM Sales;

19. -- Cumulative total of SalesAmount partitioned by StoreID
    SELECT StoreID, SaleDate, SalesAmount,
           SUM(SalesAmount) OVER (PARTITION BY StoreID ORDER BY SaleDate) AS CumulativeSales
    FROM Sales;

20. -- Difference in SalesAmount for each product between previous and current sale using LAG()
    SELECT ProductID, SaleDate, SalesAmount,
           SalesAmount - LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS DifferenceFromPrevious
    FROM Sales;