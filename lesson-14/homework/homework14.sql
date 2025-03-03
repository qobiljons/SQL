-- 1. Find the total sales per employee using a derived table
SELECT e.employee_id, e.employee_name, t.total_sales
FROM employees e
JOIN (
    SELECT employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY employee_id
) t ON e.employee_id = t.employee_id;

-- 2. Create a CTE to find the average salary of employees
WITH AvgSalary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT * FROM AvgSalary;

-- 3. Find the highest sales for each product using a derived table
SELECT p.product_id, p.product_name, t.highest_sales
FROM products p
JOIN (
    SELECT product_id, MAX(sale_amount) AS highest_sales
    FROM sales
    GROUP BY product_id
) t ON p.product_id = t.product_id;

-- 4. Use a CTE to get the names of employees who have made more than 5 sales
WITH EmployeeSales AS (
    SELECT employee_id, COUNT(*) AS total_sales
    FROM sales
    GROUP BY employee_id
)
SELECT e.employee_name
FROM employees e
JOIN EmployeeSales es ON e.employee_id = es.employee_id
WHERE es.total_sales > 5;

-- 5. Create a derived table that lists the top 5 customers by total purchase amount
SELECT c.customer_id, c.customer_name, t.total_purchase
FROM customers c
JOIN (
    SELECT customer_id, SUM(purchase_amount) AS total_purchase
    FROM purchases
    GROUP BY customer_id
    ORDER BY total_purchase DESC
    LIMIT 5
) t ON c.customer_id = t.customer_id;

-- 6. Use a CTE to find all products with sales greater than $500
WITH ProductSales AS (
    SELECT product_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY product_id
)
SELECT p.product_name
FROM products p
JOIN ProductSales ps ON p.product_id = ps.product_id
WHERE ps.total_sales > 500;

-- 7. Use a derived table to get the total number of orders for each customer
SELECT c.customer_id, c.customer_name, t.total_orders
FROM customers c
JOIN (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
) t ON c.customer_id = t.customer_id;

-- 8. Create a CTE to find employees with salaries above the average salary
WITH AvgSalary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT avg_salary FROM AvgSalary);

-- 9. Write a query to find the total number of products sold using a derived table
SELECT SUM(total_products) AS total_products_sold
FROM (
    SELECT product_id, SUM(quantity_sold) AS total_products
    FROM sales
    GROUP BY product_id
) t;

-- 10. Use a CTE to find the names of employees who have not made any sales
WITH EmployeeSales AS (
    SELECT DISTINCT employee_id
    FROM sales
)
SELECT employee_name
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM EmployeeSales);

-- 11. Write a query using a derived table to calculate the total revenue for each region
SELECT r.region_name, t.total_revenue
FROM regions r
JOIN (
    SELECT region_id, SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY region_id
) t ON r.region_id = t.region_id;

-- 12. Use a CTE to get the employees who worked for more than 5 years
WITH EmployeeTenure AS (
    SELECT employee_id, DATEDIFF(CURRENT_DATE, hire_date) / 365 AS years_worked
    FROM employees
)
SELECT employee_name
FROM employees e
JOIN EmployeeTenure et ON e.employee_id = et.employee_id
WHERE et.years_worked > 5;

-- 13. Create a query using a derived table to find customers who made more than 3 orders
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
    HAVING order_count > 3
) t ON c.customer_id = t.customer_id;

-- 14. Write a query using a CTE to find employees with the highest sales in a specific department
WITH DepartmentSales AS (
    SELECT department_id, employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY department_id, employee_id
)
SELECT e.employee_name, ds.total_sales
FROM employees e
JOIN DepartmentSales ds ON e.employee_id = ds.employee_id
WHERE ds.department_id = ?
  AND ds.total_sales = (SELECT MAX(total_sales) FROM DepartmentSales WHERE department_id = ?);

-- 15. Use a derived table to calculate the average order value for each customer
SELECT c.customer_id, c.customer_name, t.avg_order_value
FROM customers c
JOIN (
    SELECT customer_id, AVG(order_value) AS avg_order_value
    FROM orders
    GROUP BY customer_id
) t ON c.customer_id = t.customer_id;

-- 16. Write a query using a CTE to find the number of employees in each department
WITH DepartmentEmployeeCount AS (
    SELECT department_id, COUNT(*) AS employee_count
    FROM employees
    GROUP BY department_id
)
SELECT d.department_name, dec.employee_count
FROM departments d
JOIN DepartmentEmployeeCount dec ON d.department_id = dec.department_id;

-- 17. Use a derived table to find the top-selling products in the last quarter
SELECT p.product_id, p.product_name, t.total_sales
FROM products p
JOIN (
    SELECT product_id, SUM(sale_amount) AS total_sales
    FROM sales
    WHERE sale_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
    GROUP BY product_id
    ORDER BY total_sales DESC
    LIMIT 5
) t ON p.product_id = t.product_id;

-- 18. Write a query using a CTE to list employees who have sales higher than $1000
WITH EmployeeHighSales AS (
    SELECT employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY employee_id
    HAVING total_sales > 1000
)
SELECT e.employee_name, e.total_sales
FROM employees e
JOIN EmployeeHighSales eh ON e.employee_id = eh.employee_id;

-- 19. Create a derived table to find the number of orders made by each customer
SELECT c.customer_id, c.customer_name, t.order_count
FROM customers c
JOIN (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) t ON c.customer_id = t.customer_id;

-- 20. Write a query using a CTE to find the total sales per employee for the last month
WITH LastMonthSales AS (
    SELECT employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    WHERE sale_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
    GROUP BY employee_id
)
SELECT e.employee_name, lms.total_sales
FROM employees e
JOIN LastMonthSales lms ON e.employee_id = lms.employee_id;

--medium questions

-- 1. Write a query using a CTE to calculate the running total of sales for each employee.
WITH RunningSales AS (
    SELECT employee_id, sale_amount,
           SUM(sale_amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS running_total
    FROM sales
)
SELECT * FROM RunningSales;

-- 2. Use a recursive CTE to generate a sequence of numbers from 1 to 10.
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 10
)
SELECT * FROM Numbers;

-- 3. Write a query using a derived table to calculate the average sales per region.
SELECT region, AVG(total_sales) AS avg_sales
FROM (
    SELECT region, SUM(sale_amount) AS total_sales FROM sales GROUP BY region
) AS SalesByRegion
GROUP BY region;

-- 4. Create a CTE to rank employees based on their total sales.
WITH EmployeeRank AS (
    SELECT employee_id, SUM(sale_amount) AS total_sales,
           RANK() OVER (ORDER BY SUM(sale_amount) DESC) AS rank
    FROM sales
    GROUP BY employee_id
)
SELECT * FROM EmployeeRank;

-- 5. Use a derived table to find the top 5 employees by the number of orders made.
SELECT employee_id, order_count
FROM (
    SELECT employee_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY employee_id
    ORDER BY order_count DESC
    LIMIT 5
) AS TopEmployees;

-- 6. Write a query using a recursive CTE to list all employees reporting to a specific manager.
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, manager_id
    FROM employees
    WHERE manager_id = 'specific_manager_id'
    UNION ALL
    SELECT e.employee_id, e.manager_id
    FROM employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM EmployeeHierarchy;

-- 7. Use a CTE to calculate the sales difference between the current month and the previous month.
WITH SalesComparison AS (
    SELECT employee_id, sale_date,
           sale_amount,
           LAG(sale_amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS previous_month_sales
    FROM sales
)
SELECT employee_id, sale_date, sale_amount, previous_month_sales,
       (sale_amount - previous_month_sales) AS sales_difference
FROM SalesComparison;

-- 8. Create a derived table to find the employees who have made the highest sales in each department.
SELECT department_id, employee_id, total_sales
FROM (
    SELECT department_id, employee_id, SUM(sale_amount) AS total_sales,
           RANK() OVER (PARTITION BY department_id ORDER BY SUM(sale_amount) DESC) AS rank
    FROM sales
    GROUP BY department_id, employee_id
) AS RankedEmployees
WHERE rank = 1;

-- 9. Write a recursive CTE to find all the ancestors of an employee in a hierarchical organization.
WITH RECURSIVE EmployeeAncestors AS (
    SELECT employee_id, manager_id
    FROM employees
    WHERE employee_id = 'specific_employee_id'
    UNION ALL
    SELECT e.employee_id, e.manager_id
    FROM employees e
    JOIN EmployeeAncestors ea ON e.employee_id = ea.manager_id
)
SELECT * FROM EmployeeAncestors;

-- 10. Use a CTE to find employees who have not sold anything in the last year.
WITH LastYearSales AS (
    SELECT DISTINCT employee_id FROM sales WHERE sale_date >= NOW() - INTERVAL '1 year'
)
SELECT employee_id FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM LastYearSales);

-- 11. Write a query using a derived table to calculate the total sales per region and year.
SELECT region, sale_year, SUM(sale_amount) AS total_sales
FROM (
    SELECT region, EXTRACT(YEAR FROM sale_date) AS sale_year, sale_amount FROM sales
) AS SalesByYearRegion
GROUP BY region, sale_year;

-- 12. Use a recursive CTE to calculate the factorial of a number.
WITH RECURSIVE Factorial AS (
    SELECT 1 AS n, 1 AS fact
    UNION ALL
    SELECT n + 1, (n + 1) * fact FROM Factorial WHERE n < 10
)
SELECT * FROM Factorial;

-- 13. Write a query using a derived table to find customers with more than 10 orders.
SELECT customer_id, order_count
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 10
) AS FrequentCustomers;

-- 14. Create a recursive CTE to traverse a product category hierarchy.
WITH RECURSIVE ProductHierarchy AS (
    SELECT product_id, category_id, parent_category_id
    FROM product_categories
    WHERE parent_category_id IS NULL
    UNION ALL
    SELECT p.product_id, p.category_id, p.parent_category_id
    FROM product_categories p
    JOIN ProductHierarchy ph ON p.parent_category_id = ph.category_id
)
SELECT * FROM ProductHierarchy;

-- 15. Use a CTE to rank products based on total sales in the last year.
WITH ProductRank AS (
    SELECT product_id, SUM(sale_amount) AS total_sales,
           RANK() OVER (ORDER BY SUM(sale_amount) DESC) AS rank
    FROM sales
    WHERE sale_date >= NOW() - INTERVAL '1 year'
    GROUP BY product_id
)
SELECT * FROM ProductRank;

-- 16. Write a query using a derived table to find the sales per product category.
SELECT category_id, SUM(sale_amount) AS total_sales
FROM (
    SELECT product_id, category_id, sale_amount FROM sales
    JOIN products USING (product_id)
) AS SalesByCategory
GROUP BY category_id;

-- 17. Use a CTE to find the employees who achieved the highest sales growth compared to last year.
WITH SalesGrowth AS (
    SELECT employee_id,
           SUM(CASE WHEN EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM NOW()) THEN sale_amount ELSE 0 END) AS current_year_sales,
           SUM(CASE WHEN EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM NOW()) - 1 THEN sale_amount ELSE 0 END) AS last_year_sales
    FROM sales
    GROUP BY employee_id
)
SELECT employee_id, (current_year_sales - last_year_sales) AS sales_growth
FROM SalesGrowth
ORDER BY sales_growth DESC;

-- 18. Create a derived table to find employees with sales over $5000 in each quarter.
SELECT employee_id, quarter, total_sales
FROM (
    SELECT employee_id, EXTRACT(QUARTER FROM sale_date) AS quarter, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY employee_id, quarter
    HAVING SUM(sale_amount) > 5000
) AS SalesByQuarter;

-- 19. Write a recursive CTE to list all descendants of a product in a product category tree.
WITH RECURSIVE ProductDescendants AS (
    SELECT product_id, parent_category_id FROM product_categories WHERE product_id = 'specific_product_id'
    UNION ALL
    SELECT p.product_id, p.parent_category_id
    FROM product_categories p
    JOIN ProductDescendants pd ON p.parent_category_id = pd.product_id
)
SELECT * FROM ProductDescendants;

-- 20. Use a derived table to find the top 3 employees by total sales amount in the last month.
SELECT employee_id, total_sales
FROM (
    SELECT employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    WHERE sale_date >= NOW() - INTERVAL '1 month'
    GROUP BY employee_id
    ORDER BY total_sales DESC
    LIMIT 3
) AS TopEmployees;

-- hard questions 

-- 1. Recursive CTE to generate the Fibonacci sequence up to the 20th term
WITH RECURSIVE Fibonacci(n, value) AS (
    SELECT 1, 0  -- First term
    UNION ALL
    SELECT 2, 1  -- Second term
    UNION ALL
    SELECT n + 1, value + (SELECT value FROM Fibonacci WHERE n = Fibonacci.n - 1)
    FROM Fibonacci
    WHERE n < 20
)
SELECT * FROM Fibonacci;

-- 2. CTE to calculate cumulative sales of employees over the past year
WITH EmployeeSales AS (
    SELECT employee_id, SUM(sales_amount) AS total_sales
    FROM sales
    WHERE sale_date >= NOW() - INTERVAL '1 year'
    GROUP BY employee_id
)
SELECT * FROM EmployeeSales;

-- 3. Recursive CTE to find all subordinates of a manager
WITH RECURSIVE Subordinates AS (
    SELECT employee_id, manager_id FROM employees WHERE manager_id = ? -- Replace ? with manager_id
    UNION ALL
    SELECT e.employee_id, e.manager_id FROM employees e
    INNER JOIN Subordinates s ON e.manager_id = s.employee_id
)
SELECT * FROM Subordinates;

-- 4. Derived table to find employees with sales above the company average for each region
SELECT e.employee_id, e.region, e.sales
FROM (
    SELECT region, AVG(sales_amount) AS avg_sales
    FROM sales
    GROUP BY region
) AS RegionSales
JOIN sales e ON e.region = RegionSales.region
WHERE e.sales_amount > RegionSales.avg_sales;

-- 5. Recursive CTE to calculate product depth in a hierarchy
WITH RECURSIVE ProductDepth AS (
    SELECT product_id, parent_product_id, 1 AS depth FROM products WHERE parent_product_id IS NULL
    UNION ALL
    SELECT p.product_id, p.parent_product_id, d.depth + 1
    FROM products p
    JOIN ProductDepth d ON p.parent_product_id = d.product_id
)
SELECT * FROM ProductDepth;

-- 6. Complex query using both a CTE and a derived table to calculate sales totals by department and product
WITH SalesData AS (
    SELECT department_id, product_id, SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY department_id, product_id
)
SELECT d.department_name, s.product_id, s.total_sales
FROM departments d
JOIN (
    SELECT * FROM SalesData
) s ON d.department_id = s.department_id;

-- 7. Recursive CTE to list all direct and indirect reports of a manager
WITH RECURSIVE Reports AS (
    SELECT employee_id, manager_id FROM employees WHERE manager_id = ?
    UNION ALL
    SELECT e.employee_id, e.manager_id FROM employees e
    JOIN Reports r ON e.manager_id = r.employee_id
)
SELECT * FROM Reports;

-- 8. Derived table to find employees with the highest sales in the last 6 months
SELECT employee_id, sales_amount
FROM (
    SELECT employee_id, SUM(sales_amount) AS sales_amount
    FROM sales
    WHERE sale_date >= NOW() - INTERVAL '6 months'
    GROUP BY employee_id
) AS EmployeeSales
ORDER BY sales_amount DESC LIMIT 10;

-- 9. Recursive CTE to calculate total cost of an order, including taxes and discounts
WITH RECURSIVE OrderCost AS (
    SELECT order_id, base_price, tax, discount, base_price + tax - discount AS total_cost FROM orders
)
SELECT * FROM OrderCost;

-- 10. CTE to find employees with the largest sales growth rate over the past year
WITH SalesGrowth AS (
    SELECT employee_id, 
           SUM(CASE WHEN sale_date >= NOW() - INTERVAL '1 year' THEN sales_amount ELSE 0 END) AS current_year_sales,
           SUM(CASE WHEN sale_date BETWEEN NOW() - INTERVAL '2 years' AND NOW() - INTERVAL '1 year' THEN sales_amount ELSE 0 END) AS previous_year_sales
    FROM sales
    GROUP BY employee_id
)
SELECT employee_id, (current_year_sales - previous_year_sales) / NULLIF(previous_year_sales, 0) AS growth_rate
FROM SalesGrowth
ORDER BY growth_rate DESC;

-- 11. Recursive CTE to calculate total number of sales for each employee over all years
WITH RECURSIVE EmployeeSales AS (
    SELECT employee_id, COUNT(sale_id) AS total_sales FROM sales GROUP BY employee_id
)
SELECT * FROM EmployeeSales;

-- 12. Query using both a CTE and a derived table to find the highest-selling product and the employee who sold it
WITH ProductSales AS (
    SELECT product_id, employee_id, SUM(sales_amount) AS total_sales FROM sales GROUP BY product_id, employee_id
)
SELECT * FROM ProductSales ORDER BY total_sales DESC LIMIT 1;

-- 13. Recursive CTE to calculate generations in an organization’s hierarchy
WITH RECURSIVE OrganizationHierarchy AS (
    SELECT employee_id, manager_id, 1 AS generation FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.manager_id, h.generation + 1 FROM employees e
    JOIN OrganizationHierarchy h ON e.manager_id = h.employee_id
)
SELECT * FROM OrganizationHierarchy;

-- 14. CTE to find employees with sales greater than their department’s average sales
WITH DepartmentAvgSales AS (
    SELECT department_id, AVG(sales_amount) AS avg_sales FROM sales GROUP BY department_id
)
SELECT e.employee_id, e.sales_amount
FROM sales e
JOIN DepartmentAvgSales d ON e.department_id = d.department_id
WHERE e.sales_amount > d.avg_sales;

-- 15. Derived table to find average sales per employee by region
SELECT region, AVG(sales_amount) AS avg_sales_per_employee
FROM (
    SELECT employee_id, region, SUM(sales_amount) AS sales_amount
    FROM sales GROUP BY employee_id, region
) AS EmployeeSales
GROUP BY region;

-- 16. Recursive CTE to identify employees with direct or indirect reports to a specific manager
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, manager_id FROM employees WHERE manager_id = ?
    UNION ALL
    SELECT e.employee_id, e.manager_id FROM employees e
    JOIN EmployeeHierarchy h ON e.manager_id = h.employee_id
)
SELECT * FROM EmployeeHierarchy;

-- 17. CTE to calculate average number of products sold by each employee in the last year
WITH ProductSales AS (
    SELECT employee_id, COUNT(product_id) AS products_sold FROM sales
    WHERE sale_date >= NOW() - INTERVAL '1 year'
    GROUP BY employee_id
)
SELECT * FROM ProductSales;

-- 18. Query using both a derived table and a CTE to analyze sales performance by employee and product category
WITH SalesData AS (
    SELECT employee_id, category_id, SUM(sales_amount) AS total_sales FROM sales GROUP BY employee_id, category_id
)
SELECT * FROM SalesData;

-- 19. Recursive CTE to list all departments reporting to a parent department
WITH RECURSIVE DepartmentHierarchy AS (
    SELECT department_id, parent_department_id FROM departments WHERE parent_department_id = ?
    UNION ALL
    SELECT d.department_id, d.parent_department_id FROM departments d
    JOIN DepartmentHierarchy h ON d.parent_department_id = h.department_id
)
SELECT * FROM DepartmentHierarchy;

-- 20. Recursive CTE to calculate the number of levels in a product category hierarchy
WITH RECURSIVE CategoryDepth AS (
    SELECT category_id, parent_category_id, 1 AS depth FROM categories WHERE parent_category_id IS NULL
    UNION ALL
    SELECT c.category_id, c.parent_category_id, d.depth + 1 FROM categories c
    JOIN CategoryDepth d ON c.parent_category_id = d.category_id
)
SELECT * FROM CategoryDepth;
