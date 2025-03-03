-- Easy Tasks (20)

-- 1. Select all staff members from the vwStaff view
SELECT * FROM vwStaff;

-- 2. Create a view vwItemPrices to display items and their prices
CREATE VIEW vwItemPrices AS
SELECT ItemID, ItemName, Price FROM Items;

-- 3. Create a temporary table #TempPurchases and insert sample data
CREATE TABLE #TempPurchases (
    PurchaseID INT PRIMARY KEY,
    ItemID INT,
    Quantity INT,
    TotalPrice DECIMAL(10,2)
);
INSERT INTO #TempPurchases VALUES (1, 101, 2, 50.00), (2, 102, 1, 30.00);

-- 4. Declare a temporary variable @currentRevenue to store total revenue for current month
DECLARE @currentRevenue DECIMAL(10,2);
SELECT @currentRevenue = SUM(TotalPrice) FROM Purchases WHERE MONTH(PurchaseDate) = MONTH(GETDATE());

-- 5. Create a scalar function fnSquare to return square of a number
CREATE FUNCTION fnSquare(@num INT) RETURNS INT AS
BEGIN
    RETURN @num * @num;
END;

-- 6. Create a stored procedure spGetClients to return list of all clients
CREATE PROCEDURE spGetClients AS
BEGIN
    SELECT * FROM Clients;
END;

-- 7. MERGE Purchases and Clients data
MERGE INTO Purchases AS T
USING Clients AS S
ON T.ClientID = S.ClientID
WHEN MATCHED THEN UPDATE SET T.ClientName = S.ClientName
WHEN NOT MATCHED THEN INSERT (ClientID, ClientName) VALUES (S.ClientID, S.ClientName);

-- 8. Create a temporary table #StaffInfo and insert sample data
CREATE TABLE #StaffInfo (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(100)
);
INSERT INTO #StaffInfo VALUES (1, 'John Doe', 'HR'), (2, 'Jane Smith', 'IT');

-- 9. Function fnEvenOdd to check if a number is even or odd
CREATE FUNCTION fnEvenOdd(@num INT) RETURNS VARCHAR(10) AS
BEGIN
    RETURN CASE WHEN @num % 2 = 0 THEN 'Even' ELSE 'Odd' END;
END;

-- 10. Stored procedure spMonthlyRevenue to calculate total revenue for a given month and year
CREATE PROCEDURE spMonthlyRevenue (@year INT, @month INT) AS
BEGIN
    SELECT SUM(TotalPrice) AS MonthlyRevenue FROM Purchases WHERE YEAR(PurchaseDate) = @year AND MONTH(PurchaseDate) = @month;
END;

-- 11. Create a view vwRecentItemSales showing total sales per item for last month
CREATE VIEW vwRecentItemSales AS
SELECT ItemID, SUM(Quantity) AS TotalSold FROM Purchases WHERE PurchaseDate >= DATEADD(MONTH, -1, GETDATE()) GROUP BY ItemID;

-- 12. Declare a temporary variable @currentDate and print it
DECLARE @currentDate DATE = GETDATE();
PRINT @currentDate;

-- 13. Create a view vwHighQuantityItems listing items with quantity > 100
CREATE VIEW vwHighQuantityItems AS
SELECT * FROM Items WHERE Quantity > 100;

-- 14. Create a temporary table #ClientOrders and join with Purchases
CREATE TABLE #ClientOrders (
    OrderID INT PRIMARY KEY,
    ClientID INT,
    OrderDate DATE
);
INSERT INTO #ClientOrders VALUES (1, 1, '2024-01-01');
SELECT * FROM #ClientOrders INNER JOIN Purchases ON #ClientOrders.ClientID = Purchases.ClientID;

-- 15. Stored procedure spStaffDetails to return staff name and department by StaffID
CREATE PROCEDURE spStaffDetails (@staffID INT) AS
BEGIN
    SELECT Name, Department FROM Staff WHERE StaffID = @staffID;
END;

-- 16. Function fnAddNumbers to return sum of two numbers
CREATE FUNCTION fnAddNumbers(@a INT, @b INT) RETURNS INT AS
BEGIN
    RETURN @a + @b;
END;

-- 17. MERGE statement to update Items table with pricing data from #NewItemPrices
MERGE INTO Items AS T
USING #NewItemPrices AS S
ON T.ItemID = S.ItemID
WHEN MATCHED THEN UPDATE SET T.Price = S.Price;

-- 18. Create a view vwStaffSalaries displaying staff names and salaries
CREATE VIEW vwStaffSalaries AS
SELECT Name, Salary FROM Staff;

-- 19. Stored procedure spClientPurchases to return purchases for a given client
CREATE PROCEDURE spClientPurchases (@clientID INT) AS
BEGIN
    SELECT * FROM Purchases WHERE ClientID = @clientID;
END;

-- 20. Function fnStringLength to return length of a string
CREATE FUNCTION fnStringLength(@str VARCHAR(255)) RETURNS INT AS
BEGIN
    RETURN LEN(@str);
END;

-- 1. Create a view to show client order history
CREATE VIEW vwClientOrderHistory AS
SELECT c.ClientID, c.ClientName, p.PurchaseID, p.PurchaseDate, p.TotalAmount
FROM Clients c
JOIN Purchases p ON c.ClientID = p.ClientID;

-- 2. Create a temporary table for yearly item sales
CREATE TEMP TABLE #YearlyItemSales AS
SELECT ItemID, SUM(Quantity) AS TotalSold, SUM(TotalPrice) AS TotalRevenue
FROM Sales
WHERE YEAR(SaleDate) = YEAR(CURRENT_DATE)
GROUP BY ItemID;

-- 3. Stored procedure to update purchase status
CREATE PROCEDURE spUpdatePurchaseStatus(IN purchaseID INT, IN newStatus VARCHAR(50))
BEGIN
    UPDATE Purchases
    SET Status = newStatus
    WHERE PurchaseID = purchaseID;
END;

-- 4. MERGE statement to insert or update purchases
MERGE INTO Purchases AS target
USING NewPurchases AS source
ON target.PurchaseID = source.PurchaseID
WHEN MATCHED THEN
    UPDATE SET target.Status = source.Status, target.TotalAmount = source.TotalAmount
WHEN NOT MATCHED THEN
    INSERT (PurchaseID, ClientID, PurchaseDate, Status, TotalAmount)
    VALUES (source.PurchaseID, source.ClientID, source.PurchaseDate, source.Status, source.TotalAmount);

-- 5. Declare a temporary variable for average item sale
DECLARE @avgItemSale DECIMAL(10,2);
SET @avgItemSale = (SELECT AVG(TotalPrice) FROM Sales WHERE ItemID = 1);

-- 6. Create a view for item order details
CREATE VIEW vwItemOrderDetails AS
SELECT p.PurchaseID, i.ItemID, i.ItemName, p.Quantity
FROM Purchases p
JOIN Items i ON p.ItemID = i.ItemID;

-- 7. Function to calculate discount
CREATE FUNCTION fnCalcDiscount(@orderAmount DECIMAL(10,2), @discountRate DECIMAL(5,2)) RETURNS DECIMAL(10,2)
BEGIN
    RETURN @orderAmount * (@discountRate / 100);
END;

-- 8. Stored procedure to delete old purchases
CREATE PROCEDURE spDeleteOldPurchases(IN cutoffDate DATE)
BEGIN
    DELETE FROM Purchases WHERE PurchaseDate < cutoffDate;
END;

-- 9. MERGE statement to update staff salaries
MERGE INTO Staff AS target
USING #SalaryUpdates AS source
ON target.StaffID = source.StaffID
WHEN MATCHED THEN
    UPDATE SET target.Salary = source.NewSalary;

-- 10. Create a view for staff revenue
CREATE VIEW vwStaffRevenue AS
SELECT s.StaffID, s.StaffName, SUM(r.Revenue) AS TotalRevenue
FROM Staff s
JOIN Revenue r ON s.StaffID = r.StaffID
GROUP BY s.StaffID, s.StaffName;

-- 11. Function to return weekday name
CREATE FUNCTION fnWeekdayName(@inputDate DATE) RETURNS VARCHAR(20)
BEGIN
    RETURN DATENAME(WEEKDAY, @inputDate);
END;

-- 12. Temporary table for staff data
CREATE TEMP TABLE #TempStaff AS
SELECT * FROM Staff;

-- 13. Query to store and display a client's total number of purchases
DECLARE @totalPurchases INT;
SET @totalPurchases = (SELECT COUNT(*) FROM Purchases WHERE ClientID = 1);
SELECT @totalPurchases AS TotalPurchases;

-- 14. Stored procedure to get client details and purchase history
CREATE PROCEDURE spClientDetails(IN clientID INT)
BEGIN
    SELECT * FROM Clients WHERE ClientID = clientID;
    SELECT * FROM Purchases WHERE ClientID = clientID;
END;

-- 15. MERGE statement to update stock quantities
MERGE INTO Items AS target
USING Delivery AS source
ON target.ItemID = source.ItemID
WHEN MATCHED THEN
    UPDATE SET target.StockQuantity = target.StockQuantity + source.DeliveredQuantity;

-- 16. Stored procedure to multiply two numbers
CREATE PROCEDURE spMultiply(IN num1 DECIMAL(10,2), IN num2 DECIMAL(10,2), OUT result DECIMAL(10,2))
BEGIN
    SET result = num1 * num2;
END;

-- 17. Function to calculate tax
CREATE FUNCTION fnCalcTax(@amount DECIMAL(10,2), @taxRate DECIMAL(5,2)) RETURNS DECIMAL(10,2)
BEGIN
    RETURN @amount * (@taxRate / 100);
END;

-- 18. View for top-performing staff
CREATE VIEW vwTopPerformingStaff AS
SELECT s.StaffID, s.StaffName, COUNT(p.PurchaseID) AS OrdersFulfilled
FROM Staff s
JOIN Purchases p ON s.StaffID = p.StaffID
GROUP BY s.StaffID, s.StaffName;

-- 19. MERGE statement to sync Clients table
MERGE INTO Clients AS target
USING #ClientDataTemp AS source
ON target.ClientID = source.ClientID
WHEN MATCHED THEN
    UPDATE SET target.ClientName = source.ClientName, target.Email = source.Email
WHEN NOT MATCHED THEN
    INSERT (ClientID, ClientName, Email)
    VALUES (source.ClientID, source.ClientName, source.Email);

-- 20. Stored procedure to get top 5 best-selling items
CREATE PROCEDURE spTopItems()
BEGIN
    SELECT ItemID, SUM(Quantity) AS TotalSold
    FROM Sales
    GROUP BY ItemID
    ORDER BY TotalSold DESC
    LIMIT 5;
END;

-- 1. Stored Procedure: spTopSalesStaff
CREATE PROCEDURE spTopSalesStaff(@year INT)
AS
BEGIN
    SELECT TOP 1 staff_id, SUM(total_revenue) AS total_sales
    FROM Sales
    WHERE YEAR(sale_date) = @year
    GROUP BY staff_id
    ORDER BY total_sales DESC;
END;
GO

-- 2. View: vwClientOrderStats
CREATE VIEW vwClientOrderStats AS
SELECT client_id, COUNT(order_id) AS purchase_count, SUM(total_price) AS total_spent
FROM Orders
GROUP BY client_id;
GO

-- 3. MERGE Statement: Purchases and Items
MERGE INTO Items AS target
USING Purchases AS source
ON target.item_id = source.item_id
WHEN MATCHED THEN
    UPDATE SET target.quantity = target.quantity + source.quantity
WHEN NOT MATCHED THEN
    INSERT (item_id, name, quantity)
    VALUES (source.item_id, source.name, source.quantity);
GO

-- 4. Function: fnMonthlyRevenue
CREATE FUNCTION fnMonthlyRevenue(@year INT, @month INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);
    SELECT @total = SUM(total_price)
    FROM Sales
    WHERE YEAR(sale_date) = @year AND MONTH(sale_date) = @month;
    RETURN @total;
END;
GO

-- 5. Stored Procedure: spProcessOrderTotals
CREATE PROCEDURE spProcessOrderTotals(@order_id INT, @discount DECIMAL(5,2), @status VARCHAR(50))
AS
BEGIN
    DECLARE @total DECIMAL(10,2);
    SELECT @total = SUM(price * quantity) FROM OrderDetails WHERE order_id = @order_id;
    SET @total = @total - (@total * @discount / 100);
    UPDATE Orders SET total_price = @total, order_status = @status WHERE order_id = @order_id;
END;
GO

-- 6. Temporary Table: #StaffSalesData
CREATE TABLE #StaffSalesData (
    staff_id INT,
    name VARCHAR(100),
    total_sales DECIMAL(10,2)
);
INSERT INTO #StaffSalesData
SELECT s.staff_id, s.name, SUM(o.total_price)
FROM Staff s
JOIN Orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.name;
GO

-- 7. MERGE Statement: #SalesTemp into Sales
MERGE INTO Sales AS target
USING #SalesTemp AS source
ON target.sale_id = source.sale_id
WHEN MATCHED THEN
    UPDATE SET target.total_price = source.total_price
WHEN NOT MATCHED THEN
    INSERT (sale_id, total_price)
    VALUES (source.sale_id, source.total_price);
GO

-- 8. Stored Procedure: spOrdersByDateRange
CREATE PROCEDURE spOrdersByDateRange(@start_date DATE, @end_date DATE)
AS
BEGIN
    SELECT * FROM Orders WHERE order_date BETWEEN @start_date AND @end_date;
END;
GO

-- 9. Function: fnCompoundInterest
CREATE FUNCTION fnCompoundInterest(@principal DECIMAL(10,2), @rate DECIMAL(5,2), @time INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @principal * POWER(1 + @rate / 100, @time);
END;
GO

-- 10. View: vwQuotaExceeders
CREATE VIEW vwQuotaExceeders AS
SELECT s.staff_id, s.name, SUM(o.total_price) AS total_sales
FROM Staff s
JOIN Orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.name
HAVING SUM(o.total_price) > s.sales_quota;
GO

-- 11. Stored Procedure: spSyncProductStock
CREATE PROCEDURE spSyncProductStock
AS
BEGIN
    MERGE INTO Stock AS target
    USING Products AS source
    ON target.product_id = source.product_id
    WHEN MATCHED THEN
        UPDATE SET target.stock_level = target.stock_level + source.stock_level;
END;
GO

-- 12. MERGE Statement: Update Staff Records
MERGE INTO Staff AS target
USING ExternalStaffData AS source
ON target.staff_id = source.staff_id
WHEN MATCHED THEN
    UPDATE SET target.name = source.name, target.salary = source.salary
WHEN NOT MATCHED THEN
    INSERT (staff_id, name, salary)
    VALUES (source.staff_id, source.name, source.salary);
GO

-- 13. Function: fnDateDiffDays
CREATE FUNCTION fnDateDiffDays(@date1 DATE, @date2 DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @date1, @date2);
END;
GO

-- 14. Stored Procedure: spUpdateItemPrices
CREATE PROCEDURE spUpdateItemPrices
AS
BEGIN
    UPDATE Items SET price = price * 1.1 WHERE sales_count > 100;
    SELECT * FROM Items;
END;
GO

-- 15. MERGE Statement: Synchronizing Clients Table
MERGE INTO Clients AS target
USING TempClients AS source
ON target.client_id = source.client_id
WHEN MATCHED THEN
    UPDATE SET target.name = source.name, target.email = source.email
WHEN NOT MATCHED THEN
    INSERT (client_id, name, email)
    VALUES (source.client_id, source.name, source.email);
GO

-- 16. Stored Procedure: spRegionalSalesReport
CREATE PROCEDURE spRegionalSalesReport
AS
BEGIN
    SELECT region, SUM(total_price) AS total_revenue, AVG(total_price) AS avg_sales, COUNT(DISTINCT staff_id) AS staff_count
    FROM Orders
    GROUP BY region;
END;
GO

-- 17. Function: fnProfitMargin
CREATE FUNCTION fnProfitMargin(@cost DECIMAL(10,2), @revenue DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (@revenue - @cost) / @revenue * 100;
END;
GO

-- 18. Temporary Table: #TempStaffMerge
CREATE TABLE #TempStaffMerge (
    staff_id INT,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);
MERGE INTO Staff AS target
USING #TempStaffMerge AS source
ON target.staff_id = source.staff_id
WHEN MATCHED THEN
    UPDATE SET target.salary = source.salary
WHEN NOT MATCHED THEN
    INSERT (staff_id, name, salary)
    VALUES (source.staff_id, source.name, source.salary);
GO

-- 19. Stored Procedure: spBackupData
CREATE PROCEDURE spBackupData
AS
BEGIN
    INSERT INTO BackupTable SELECT * FROM CriticalData;
END;
GO

-- 20. Stored Procedure: spTopSalesReport
CREATE PROCEDURE spTopSalesReport
AS
BEGIN
    SELECT TOP 10 staff_id, SUM(total_price) AS total_sales
    FROM Orders
    GROUP BY staff_id
    ORDER BY total_sales DESC;
END;
GO
