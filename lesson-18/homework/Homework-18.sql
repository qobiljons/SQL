
-- ===========================
-- Level 1: Basic Subqueries
-- ===========================

-- Create employees table
CREATE TABLE employees (
    id INT PRIMARY KEY, 
    name VARCHAR(100), 
    salary DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO employees (id, name, salary) VALUES 
(1, 'Alice', 50000), 
(2, 'Bob', 60000), 
(3, 'Charlie', 50000);

-- Find Employees with Minimum Salary
SELECT * 
FROM employees 
WHERE salary = (SELECT MIN(salary) FROM employees);


-- Create products table
CREATE TABLE products (
    id INT PRIMARY KEY, 
    product_name VARCHAR(100), 
    price DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO products (id, product_name, price) VALUES 
(1, 'Laptop', 1200), 
(2, 'Tablet', 400), 
(3, 'Smartphone', 800), 
(4, 'Monitor', 300);

-- Find Products Above Average Price
SELECT * 
FROM products 
WHERE price > (SELECT AVG(price) FROM products);


-- ==============================
-- Level 2: Nested Subqueries with Conditions
-- ==============================

-- Create departments table
CREATE TABLE departments (
    id INT PRIMARY KEY, 
    department_name VARCHAR(100)
);

-- Create employees table with department_id
CREATE TABLE employees (
    id INT PRIMARY KEY, 
    name VARCHAR(100), 
    department_id INT, 
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Insert sample data
INSERT INTO departments (id, department_name) VALUES 
(1, 'Sales'), 
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES 
(1, 'David', 1), 
(2, 'Eve', 2), 
(3, 'Frank', 1);

-- Find Employees in Sales Department
SELECT * 
FROM employees 
WHERE department_id = (SELECT id FROM departments WHERE department_name = 'Sales');


-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY, 
    name VARCHAR(100)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY, 
    customer_id INT, 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert sample data
INSERT INTO customers (customer_id, name) VALUES 
(1, 'Grace'), 
(2, 'Heidi'), 
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES 
(1, 1), 
(2, 1);

-- Find Customers with No Orders
SELECT * 
FROM customers 
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);


-- ==============================
-- Level 3: Aggregation and Grouping in Subqueries
-- ==============================

-- Create products table with category_id
CREATE TABLE products (
    id INT PRIMARY KEY, 
    product_name VARCHAR(100), 
    price DECIMAL(10,2), 
    category_id INT
);

-- Insert sample data
INSERT INTO products (id, product_name, price, category_id) VALUES 
(1, 'Tablet', 400, 1), 
(2, 'Laptop', 1500, 1), 
(3, 'Headphones', 200, 2), 
(4, 'Speakers', 300, 2);

-- Find Products with Max Price in Each Category
SELECT * 
FROM products p
WHERE price = (SELECT MAX(price) FROM products WHERE category_id = p.category_id);


-- Create employees table with department_id and salary
CREATE TABLE employees (
    id INT PRIMARY KEY, 
    name VARCHAR(100), 
    salary DECIMAL(10,2), 
    department_id INT, 
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Insert sample data
INSERT INTO departments (id, department_name) VALUES 
(1, 'IT'), 
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES 
(1, 'Jack', 80000, 1), 
(2, 'Karen', 70000, 1), 
(3, 'Leo', 60000, 2);

-- Find Employees in Department with Highest Average Salary
SELECT * 
FROM employees 
WHERE department_id = (
    SELECT TOP 1 department_id 
    FROM employees 
    GROUP BY department_id 
    ORDER BY AVG(salary) DESC
);


-- ==============================
-- Level 4: Correlated Subqueries
-- ==============================

-- Find Employees Earning Above Department Average
SELECT * 
FROM employees e1
WHERE salary > (SELECT AVG(salary) 
                FROM employees e2 
                WHERE e2.department_id = e1.department_id);


-- Create students and grades tables
CREATE TABLE students (
    student_id INT PRIMARY KEY, 
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT, 
    course_id INT, 
    grade DECIMAL(4,2), 
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert sample data
INSERT INTO students (student_id, name) VALUES 
(1, 'Sarah'), 
(2, 'Tom'), 
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES 
(1, 101, 95), 
(2, 101, 85), 
(3, 102, 90), 
(1, 102, 80);

-- Find Students with Highest Grade per Course
SELECT * 
FROM grades g1
WHERE grade = (SELECT MAX(grade) 
               FROM grades g2 
               WHERE g2.course_id = g1.course_id);


-- ==============================
-- Level 5: Subqueries with Ranking and Complex Conditions
-- ==============================

-- Insert more data for ranking
INSERT INTO products (id, product_name, price, category_id) VALUES 
(5, 'Phone', 800, 1), 
(6, 'Laptop', 1500, 1), 
(7, 'Tablet', 600, 1), 
(8, 'Smartwatch', 300, 1), 
(9, 'Headphones', 200, 2), 
(10, 'Speakers', 300, 2), 
(11, 'Earbuds', 100, 2);

-- Find Third-Highest Price per Category
WITH RankedProducts AS (
    SELECT *, 
           DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM products
)
SELECT * 
FROM RankedProducts 
WHERE rank = 3;


-- Create employees table with salary conditions
CREATE TABLE employees (
    id INT PRIMARY KEY, 
    name VARCHAR(100), 
    salary DECIMAL(10,2), 
    department_id INT
);

-- Insert sample data
INSERT INTO employees (id, name, salary, department_id) VALUES 
(1, 'Alex', 70000, 1), 
(2, 'Blake', 90000, 1), 
(3, 'Casey', 50000, 2), 
(4, 'Dana', 60000, 2), 
(5, 'Evan', 75000, 1);

-- Find Employees Between Company Average and Department Max Salary
SELECT * 
FROM employees e1
WHERE salary > (SELECT AVG(salary) FROM employees)
AND salary < (SELECT MAX(salary) 
              FROM employees e2 
              WHERE e2.department_id = e1.department_id);
