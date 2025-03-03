-- Creating sample tables for demonstration
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL
);


INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'Javohir Karimov', NULL),
(2, 'Olimjon Akramov', 1),
(3, 'Sanjarbek Rustamov', 1),
(4, 'Dilnoza Tursunova', 2),
(5, 'Shoxrux Nazarov', 2),
(6, 'Gulnora Yuldasheva', 3),
(7, 'Jasurbek Alimov', 3),
(8, 'Muhammad Aliyev', 4),
(9, 'Feruza Mahmudova', 4),
(10, 'Diyorbek Usmonov', 5),
(11, 'Kamronbek Saidov', 5),
(12, 'Ziyoda Raximova', 6),
(13, 'Madina Tohirova', 6),
(14, 'Ulugbek Ergashev', 7),
(15, 'Zuhra To‘laganova', 7),
(16, 'Jahongir Murodov', 8),
(17, 'Muslima Anvarova', 8),
(18, 'Sardorbek Ismoilov', 9),
(19, 'Nozima Hamidova', 9),
(20, 'Behruz Qosimov', 10);


-- Task 1: Use a Derived Table to Find Employees with Managers
SELECT e.EmployeeID, e.EmployeeName, m.EmployeeName AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- Task 2: Use a CTE to Find Employees with Managers
WITH EmployeeManagers AS (
    SELECT e.EmployeeID, e.EmployeeName, m.EmployeeName AS ManagerName
    FROM Employees e
    LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
)
SELECT * FROM EmployeeManagers;

-- Task 3: Compare Results of Derived Table and CTE
-- The results from Task 1 and Task 2 should be identical, as both queries retrieve employees with their managers.

-- Task 4: Find Direct Reports for a Given Manager Using CTE
WITH DirectReports AS (
    SELECT EmployeeID, EmployeeName, ManagerID
    FROM Employees
    WHERE ManagerID = 2  -- Change the ManagerID as needed
)
SELECT * FROM DirectReports;

-- Task 5: Create a Recursive CTE to Find All Levels of Employees
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, EmployeeID;

-- Task 6: Count Number of Employees at Each Level Using Recursive CTE
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT Level, COUNT(*) AS EmployeeCount FROM EmployeeHierarchy GROUP BY Level ORDER BY Level;

-- Task 7: Retrieve Employees Without Managers Using Derived Table
SELECT EmployeeID, EmployeeName FROM Employees WHERE ManagerID IS NULL;

-- Task 8: Retrieve Employees Without Managers Using CTE
WITH NoManager AS (
    SELECT EmployeeID, EmployeeName FROM Employees WHERE ManagerID IS NULL
)
SELECT * FROM NoManager;

-- Task 9: Find Employees Reporting to a Specific Manager Using Recursive CTE
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID = 1  -- Change the ManagerID as needed
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, EmployeeID;

-- Task 10: Find the Maximum Depth of Management Hierarchy
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT MAX(Level) AS MaxHierarchyDepth FROM EmployeeHierarchy;

