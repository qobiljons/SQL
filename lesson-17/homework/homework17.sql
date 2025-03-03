-- 1. List all items in the Items table where the price is greater than the average price of all items
SELECT * FROM Items WHERE price > (SELECT AVG(price) FROM Items);

-- 2. Create a query using an independent subquery to find staff members who have worked in a division that employs more than 10 people
SELECT * FROM Staff WHERE division_id IN (SELECT division_id FROM Staff GROUP BY division_id HAVING COUNT(*) > 10);

-- 3. Write a query that uses a correlated subquery to list all staff members whose salary exceeds the average salary in their respective division
SELECT * FROM Staff S WHERE salary > (SELECT AVG(salary) FROM Staff WHERE division_id = S.division_id);

-- 4. Use a subquery to find all clients who have made a purchase in the Purchases table
SELECT * FROM Clients WHERE client_id IN (SELECT DISTINCT client_id FROM Purchases);

-- 5. Write a query that uses the EXISTS operator to retrieve all purchases that include at least one detail in the PurchaseDetails table
SELECT * FROM Purchases WHERE EXISTS (SELECT 1 FROM PurchaseDetails WHERE PurchaseDetails.purchase_id = Purchases.purchase_id);

-- 6. Create a subquery to list all items that have been sold more than 100 times according to the PurchaseDetails table
SELECT * FROM Items WHERE item_id IN (SELECT item_id FROM PurchaseDetails GROUP BY item_id HAVING SUM(quantity) > 100);

-- 7. Use a subquery to list all staff members who earn more than the overall company’s average salary
SELECT * FROM Staff WHERE salary > (SELECT AVG(salary) FROM Staff);

-- 8. Write a subquery to find all vendors that supply items with a price below $50
SELECT * FROM Vendors WHERE vendor_id IN (SELECT vendor_id FROM Items WHERE price < 50);

-- 9. Use a subquery to determine the maximum item price in the Items table
SELECT MAX(price) FROM Items;

-- 10. Write a query using an independent subquery to find the highest total purchase value in the Purchases table
SELECT MAX(total_value) FROM (SELECT purchase_id, SUM(price * quantity) AS total_value FROM PurchaseDetails GROUP BY purchase_id) AS purchase_totals;

-- 11. Write a subquery to list clients who have never made a purchase
SELECT * FROM Clients WHERE client_id NOT IN (SELECT DISTINCT client_id FROM Purchases);

-- 12. Use a subquery to list all items that belong to the category "Electronics."
SELECT * FROM Items WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Electronics');

-- 13. Write a subquery to list all purchases that were made after a specified date
SELECT * FROM Purchases WHERE purchase_date > '2023-01-01';

-- 14. Create a subquery to calculate the total number of items sold in a particular purchase
SELECT purchase_id, SUM(quantity) AS total_items FROM PurchaseDetails WHERE purchase_id = 1 GROUP BY purchase_id;

-- 15. Write a query to list staff members who have been employed for more than 5 years
SELECT * FROM Staff WHERE hire_date < NOW() - INTERVAL '5 years';

-- 16. Use a correlated subquery to list staff members who earn more than the average salary in their division
SELECT * FROM Staff S WHERE salary > (SELECT AVG(salary) FROM Staff WHERE division_id = S.division_id);

-- 17. Write a query using the EXISTS operator to list purchases that include an item from the Items table
SELECT * FROM Purchases WHERE EXISTS (SELECT 1 FROM PurchaseDetails WHERE PurchaseDetails.purchase_id = Purchases.purchase_id);

-- 18. Create a subquery to find clients who have made a purchase within the last 30 days
SELECT * FROM Clients WHERE client_id IN (SELECT DISTINCT client_id FROM Purchases WHERE purchase_date >= NOW() - INTERVAL '30 days');

-- 19. Write a query using a subquery to identify the oldest item in the Items table
SELECT * FROM Items WHERE added_date = (SELECT MIN(added_date) FROM Items);

-- 20. Write a query to list staff members who are not assigned to any division
SELECT * FROM Staff WHERE division_id IS NULL;

--Medium Questions

-- 1. Find all staff who work in the same division as any staff member earning over $100,000.
SELECT * FROM staff s1
WHERE EXISTS (
    SELECT 1 FROM staff s2
    WHERE s2.salary > 100000 AND s2.division_id = s1.division_id
);

-- 2. List all staff members who have the highest salary in their division.
SELECT * FROM staff s1
WHERE salary = (
    SELECT MAX(salary) FROM staff s2
    WHERE s2.division_id = s1.division_id
);

-- 3. List all clients who have made purchases but never bought an item priced above $200.
SELECT DISTINCT client_id FROM purchases
WHERE client_id NOT IN (
    SELECT DISTINCT client_id FROM purchases p
    JOIN items i ON p.item_id = i.item_id
    WHERE i.price > 200
);

-- 4. Find items that have been ordered more frequently than the average item.
SELECT item_id FROM orders o1
WHERE (SELECT COUNT(*) FROM orders o2 WHERE o2.item_id = o1.item_id) > 
    (SELECT AVG(order_count) FROM (
        SELECT COUNT(*) AS order_count FROM orders GROUP BY item_id
    ) subquery);

-- 5. List clients who have placed more than 3 purchases.
SELECT client_id FROM purchases
GROUP BY client_id
HAVING COUNT(*) > 3;

-- 6. Calculate the number of items ordered in the last 30 days by each client.
SELECT client_id, SUM(quantity) AS total_items FROM purchases
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY client_id;

-- 7. List staff whose salary exceeds the average salary of all staff in their division.
SELECT * FROM staff s1
WHERE salary > (
    SELECT AVG(salary) FROM staff s2
    WHERE s2.division_id = s1.division_id
);

-- 8. List items that have never been ordered.
SELECT * FROM items
WHERE item_id NOT IN (SELECT DISTINCT item_id FROM orders);

-- 9. List all vendors who supply items priced above the average price of items.
SELECT DISTINCT vendor_id FROM items
WHERE price > (SELECT AVG(price) FROM items);

-- 10. Compute the total sales for each item in the past year.
SELECT item_id, SUM(quantity * price) AS total_sales FROM purchases
WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY item_id;

-- 11. List staff members older than the overall average age of the company.
SELECT * FROM staff
WHERE age > (SELECT AVG(age) FROM staff);

-- 12. List items with a price greater than the average price in the Items table.
SELECT * FROM items
WHERE price > (SELECT AVG(price) FROM items);

-- 13. Find clients who have purchased items from a specific category.
SELECT DISTINCT client_id FROM purchases p
JOIN items i ON p.item_id = i.item_id
WHERE i.category = 'specific_category';

-- 14. List all items with a quantity available greater than the average stock level.
SELECT * FROM items
WHERE quantity_available > (SELECT AVG(quantity_available) FROM items);

-- 15. List all staff who work in the same division as those who have received a bonus.
SELECT * FROM staff s1
WHERE EXISTS (
    SELECT 1 FROM staff s2
    WHERE s2.bonus > 0 AND s2.division_id = s1.division_id
);

-- 16. List staff members with salaries in the top 10% of all staff.
SELECT * FROM staff
WHERE salary >= (
    SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salary) FROM staff
);

-- 17. Identify the division that employs the most staff.
SELECT division_id FROM staff
GROUP BY division_id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 18. Find the purchase with the highest total value.
SELECT * FROM purchases
WHERE quantity * price = (
    SELECT MAX(quantity * price) FROM purchases
);

-- 19. List staff who earn more than the average salary of their division and have more than 5 years of service.
SELECT * FROM staff s1
WHERE salary > (
    SELECT AVG(salary) FROM staff s2 WHERE s2.division_id = s1.division_id
) AND years_of_service > 5;

-- 20. List clients who have never purchased an item with a price higher than $100.
SELECT DISTINCT client_id FROM purchases
WHERE client_id NOT IN (
    SELECT DISTINCT client_id FROM purchases p
    JOIN items i ON p.item_id = i.item_id
    WHERE i.price > 100
);

--Hard questions

-- 1. List all staff who earn more than the average salary in their division, excluding the staff member with the highest salary in that division.
SELECT staff_id, name, salary, division_id 
FROM staff s1
WHERE salary > (SELECT AVG(salary) FROM staff s2 WHERE s1.division_id = s2.division_id)
AND salary < (SELECT MAX(salary) FROM staff s3 WHERE s1.division_id = s3.division_id);

-- 2. List items that have been purchased by clients who have placed more than 5 orders.
SELECT DISTINCT item_id, item_name 
FROM items 
WHERE item_id IN (
    SELECT item_id 
    FROM orders 
    WHERE client_id IN (
        SELECT client_id 
        FROM orders 
        GROUP BY client_id 
        HAVING COUNT(order_id) > 5
    )
);

-- 3. List all staff who are older than the overall average age and earn more than the average company salary.
SELECT staff_id, name, age, salary 
FROM staff 
WHERE age > (SELECT AVG(age) FROM staff) 
AND salary > (SELECT AVG(salary) FROM staff);

-- 4. List staff who work in a division that has more than 5 staff members earning over $100,000.
SELECT staff_id, name, division_id 
FROM staff s1 
WHERE division_id IN (
    SELECT division_id 
    FROM staff s2 
    WHERE salary > 100000
    GROUP BY division_id 
    HAVING COUNT(staff_id) > 5
);

-- 5. List all items that have not been purchased by any client in the past year.
SELECT item_id, item_name 
FROM items 
WHERE item_id NOT IN (
    SELECT DISTINCT item_id 
    FROM orders 
    WHERE order_date >= NOW() - INTERVAL '1 year'
);

-- 6. List all clients who have made purchases that include items from at least two different categories.
SELECT client_id, name 
FROM clients 
WHERE client_id IN (
    SELECT client_id 
    FROM orders o
    JOIN items i ON o.item_id = i.item_id
    GROUP BY client_id 
    HAVING COUNT(DISTINCT i.category_id) >= 2
);

-- 7. List staff who earn more than the average salary of staff in the same job position.
SELECT staff_id, name, position, salary 
FROM staff s1 
WHERE salary > (
    SELECT AVG(salary) 
    FROM staff s2 
    WHERE s1.position = s2.position
);

-- 8. List items that are in the top 10% by price among all items.
SELECT item_id, item_name, price 
FROM items 
WHERE price >= (
    SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY price) FROM items
);

-- 9. List staff whose salary is in the top 10% within their division.
SELECT staff_id, name, salary, division_id 
FROM staff s1 
WHERE salary >= (
    SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salary) 
    FROM staff s2 
    WHERE s1.division_id = s2.division_id
);

-- 10. List all staff who have not received any bonus in the last 6 months.
SELECT staff_id, name 
FROM staff 
WHERE staff_id NOT IN (
    SELECT DISTINCT staff_id 
    FROM bonuses 
    WHERE bonus_date >= NOW() - INTERVAL '6 months'
);

-- 11. List items that have been ordered more frequently than the average number of orders per item.
SELECT item_id, item_name 
FROM items 
WHERE item_id IN (
    SELECT item_id 
    FROM orders 
    GROUP BY item_id 
    HAVING COUNT(order_id) > (
        SELECT AVG(order_count) FROM (
            SELECT COUNT(order_id) AS order_count FROM orders GROUP BY item_id
        ) AS avg_orders
    )
);

-- 12. List all clients who made purchases last year for items priced above the average price.
SELECT DISTINCT client_id, name 
FROM clients 
WHERE client_id IN (
    SELECT client_id 
    FROM orders o
    JOIN items i ON o.item_id = i.item_id
    WHERE o.order_date >= NOW() - INTERVAL '1 year' 
    AND i.price > (SELECT AVG(price) FROM items)
);

-- 13. Identify the division with the highest average salary.
SELECT division_id 
FROM staff s1 
WHERE AVG(salary) = (
    SELECT MAX(avg_salary) 
    FROM (
        SELECT division_id, AVG(salary) AS avg_salary FROM staff GROUP BY division_id
    ) AS salary_table
);

-- 14. List items that have been purchased by clients who have placed more than 10 orders.
SELECT DISTINCT item_id, item_name 
FROM items 
WHERE item_id IN (
    SELECT item_id 
    FROM orders 
    WHERE client_id IN (
        SELECT client_id 
        FROM orders 
        GROUP BY client_id 
        HAVING COUNT(order_id) > 10
    )
);

-- 15. List staff who work in the division with the highest total sales.
SELECT staff_id, name, division_id 
FROM staff 
WHERE division_id = (
    SELECT division_id 
    FROM orders o
    JOIN staff s ON o.staff_id = s.staff_id
    GROUP BY division_id 
    ORDER BY SUM(total_price) DESC 
    LIMIT 1
);

-- 16. List staff whose salary is in the top 5% of the entire company.
SELECT staff_id, name, salary 
FROM staff 
WHERE salary >= (
    SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY salary) FROM staff
);

-- 17. List items that have not been purchased by any client in the past month.
SELECT item_id, item_name 
FROM items 
WHERE item_id NOT IN (
    SELECT DISTINCT item_id 
    FROM orders 
    WHERE order_date >= NOW() - INTERVAL '1 month'
);

-- 18. List staff who work in the same division as staff members with the highest purchase totals.
SELECT staff_id, name, division_id 
FROM staff 
WHERE division_id IN (
    SELECT division_id 
    FROM orders 
    GROUP BY division_id 
    ORDER BY SUM(total_price) DESC 
    LIMIT 1
);

-- 19. List clients who have not made any purchases in the last 6 months and have spent less than $100.
SELECT client_id, name 
FROM clients 
WHERE client_id NOT IN (
    SELECT DISTINCT client_id 
    FROM orders 
    WHERE order_date >= NOW() - INTERVAL '6 months'
) AND client_id IN (
    SELECT client_id 
    FROM orders 
    GROUP BY client_id 
    HAVING SUM(total_price) < 100
);

-- 20. List all staff who have been employed for more than 10 years and have made purchases for items worth more than $1,000.
SELECT staff_id, name 
FROM staff 
WHERE hire_date <= NOW() - INTERVAL '10 years' 
AND staff_id IN (
    SELECT staff_id 
    FROM orders 
    WHERE total_price > 1000
);


