-- 1. Difference between LEN and DATALENGTH
-- LEN() returns the number of characters in a string (excluding trailing spaces).
-- DATALENGTH() returns the number of bytes used to store a string (includes trailing spaces in VARCHAR but not in CHAR).
SELECT LEN('Hello '), DATALENGTH('Hello ');

-- 2. CHARINDEX function for string searching
-- Finds the position of a substring within a string.

SELECT CHARINDEX('SQL', 'Learning SQL Server');

-- 3. CONCAT function vs. + operator
-- CONCAT() handles NULL values better than the + operator.
SELECT CONCAT('Hello', ' ', 'World');
SELECT 'Hello' + ' ' + 'World';

-- 4. REPLACE function usage
-- Used to replace occurrences of a substring in a string.
SELECT REPLACE('SQL Server is great', 'great', 'awesome');

-- 5. SUBSTRING function for extracting parts of a string
SELECT SUBSTRING('Hello World', 7, 5);


-- Mathematical Functions in SQL Server

-- 1. ROUND function for mathematical rounding
SELECT ROUND(12.3456, 2);

-- 2. ABS function for absolute values
SELECT ABS(-10);

-- 3. POWER vs. EXP for exponentiation
SELECT POWER(2, 3); -- 2^3
SELECT EXP(1); -- e^1

-- 4. CEILING and FLOOR functions
SELECT CEILING(4.2), FLOOR(4.2);

-- Date and Time Functions in SQL Server

-- 1. GETDATE function for current date/time
SELECT GETDATE();

-- 2. DATEDIFF function for date differences
SELECT DATEDIFF(DAY, '2023-01-01', GETDATE());

-- 3. DATEADD function example
SELECT DATEADD(MONTH, 3, GETDATE());

-- 4. FORMAT function for date formatting
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd');

-- Date and Time Functions in SQL Server

-- 1. GETDATE function for current date/time
SELECT GETDATE();

-- 2. DATEDIFF function for date differences
SELECT DATEDIFF(DAY, '2023-01-01', GETDATE());

-- 3. DATEADD function example
SELECT DATEADD(MONTH, 3, GETDATE());

-- 4. FORMAT function for date formatting
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd');

-- Query Examples

-- String functions query
SELECT UPPER('hello world'), LOWER('HELLO WORLD');

-- Mathematical functions query
SELECT SQRT(16), LOG(10);

-- Date/time functions query
SELECT YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE());

-- Performance considerations when using functions
-- we need to avoid using functions on indexed columns in WHERE clauses to maintain performance.

-- Functions helping in query optimization
-- Using DATEPART() instead of manipulating dates with string functions.

-- Avoiding certain functions
-- FORMAT() should be avoided in large datasets as it is performance-intensive.

-- Puzzle 1: Count spaces in a string
SELECT texts, LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount FROM CountSpaces;

-- Puzzle 2: Count different character types
SELECT
LEN(@) - LEN(REPLACE(@, ' ', '')) AS Spaces,
LEN(@) - LEN(REPLACE(@, 'A', '')) AS Uppercase,
LEN(@) - LEN(REPLACE(@, 'a', '')) AS Lowercase;

-- Puzzle 3: Generate date sequence using CTE
WITH DateSequence AS (
SELECT @fromdate AS DateValue
UNION ALL
SELECT DATEADD(DAY, 1, DateValue) FROM DateSequence WHERE DateValue < @todate
)
SELECT * FROM DateSequence;

-- Puzzle 4: Split column into two columns
SELECT Id, LEFT(Name, CHARINDEX(',', Name) - 1) AS FirstName, RIGHT(Name, LEN(Name) - CHARINDEX(',', Name)) AS LastName FROM TestMultipleColumns;