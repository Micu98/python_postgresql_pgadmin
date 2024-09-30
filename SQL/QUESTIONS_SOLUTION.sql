# Select statements: 
(WHERE, DISTINCT, ORDER BY DESC / ASC, GROUP BY, HAVING COUNT, CAST, LIMIT, OFFSET, )


1. What are the details of all customers whose country is 'Spain'?

SELECT * 
FROM Customers
WHERE Country = 'Spain';

# Also possible:
SELECT *
FROM Customers
WHERE Country in (‘Spain’);

1.1 List all movies that were released on even number years

SELECT 
    title, 
    year
FROM movies
WHERE year % 2 = 0;

1.2 What are the distinct cities of customers from Germany with a city containing the letter 'B'?

SELECT DISTINCT City #(from what is distinct searched?)
FROM Customers 
WHERE Country = 'Germany' 
AND City LIKE '%B%';

# Note: Distinct function is there to show different city that contains letter ‘B’.
# also to give result without duplicates

1.3 List all directors of Pixar movies (alphabetically), without duplicates

SELECT DISTINCT director FROM movies
ORDER BY director ASC;

1.4 Find the list of all buildings that have employees

SELECT DISTINCT building FROM employees;

1.5 Find the movies not released in the years between 2000 and 2010.

SELECT 
    title, 
    year 
FROM movies
WHERE year < 2000 OR year > 2010;

1.6 Find all the Toy Story movies

SELECT 
title, 
director 
FROM movies 
WHERE title LIKE "Toy Story%";

1.7 Find all the WALL-* movies

SELECT * FROM movies 
WHERE title LIKE "WALL-_";


2. What are the distinct cities of customers from Germany with a city containing the letter 'B'?

SELECT DISTINCT City 
FROM Customers 
WHERE Country = 'Germany' 
AND City LIKE '%B%';

3. What are the number of orders placed by each customer? Sort the result by the number of orders in descending order.

SELECT 
    CustomerID, 
    COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID
ORDER BY OrderCount DESC;

4. What are the customers who have placed more than 3 orders?

SELECT 
    CustomerID, 
    COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 3;

5. What are the top 5 most expensive products? Round the price to 2 decimal places.

SELECT 
    ProductName, 
    ROUND(CAST(Price AS NUMERIC), 2) AS Price
FROM Products
ORDER BY Price DESC
LIMIT 5;

5.1 List the next five Pixar movies sorted alphabetically

SELECT title FROM movies
ORDER BY title ASC
LIMIT 5 OFFSET 5;

5.2 List the third and fourth largest cities (by population) in the United States and their population

SELECT city, population FROM north_american_cities
WHERE country LIKE "United States"
ORDER BY population DESC
limit 2 offset 2;

6. What are the order details (ProductID, Quantity) for customers from France?

SELECT 
	o.OrderID, 
	c.CustomerName, 
	c.Country, 
	od.ProductID, 
	od.Quantity
FROM Orders o #(execute with which table join)
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE c.Country = 'France';

("""SELECT Clause: Specifies the columns you want to retrieve:
•	    o.OrderID: The unique ID of each order.
•	    c.CustomerName: The name of the customer.
•	    c.Country: The customer's country (filtered to France).
•	    od.ProductID: The unique ID of the product in the order.
•	    od.Quantity: The quantity of the product ordered.
•  FROM Orders o: Specifies the Orders table as the primary table (o is an alias for Orders).
•  JOIN Customers c ON o.CustomerID = c.CustomerID:
•	    Performs an inner join between the Orders table and the Customers table.
•	    The join condition matches the CustomerID from Orders with CustomerID in Customers to retrieve details about the customer who placed each order.
•  JOIN OrderDetails od ON o.OrderID = od.OrderID:
•	    Another inner join, this time between the Orders table and the OrderDetails table.
•	    The join condition matches the OrderID from Orders with OrderID in OrderDetails, retrieving information about the products in each order.
•  WHERE c.Country = 'France': This filters the results to include only those orders where the customer is located in France.""")


7. Area there products without a category assigned?

SELECT 
    ProductID, 
    ProductName,
    CategoryID
FROM Products
WHERE CategoryID IS NULL;

8. What are all orders and their employees?

SELECT 
    o.OrderID, 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID;

9. What is the average, minimum, and maximum price of products? Round the values to 2 decimal places.

SELECT 
    ROUND(CAST(AVG(Price) AS NUMERIC), 2) AS AveragePrice, #(round + AVG/MIN/MAX -> type definition needed with CAST)
    ROUND(CAST(MIN(Price) AS NUMERIC), 2) AS MinimumPrice,
    ROUND(CAST(MAX(Price) AS NUMERIC), 2) AS MaximumPrice
FROM Products;

10. What are the products with prices between 10 and 50? Round the price to 2 decimal places and sort the result by price in descending order.

SELECT 
    ProductID, 
    ProductName, 
    ROUND(CAST(Price AS NUMERIC), 2) AS Price
FROM Products
WHERE Price BETWEEN 10 AND 50
ORDER BY Price DESC;

11. What are the shippers and the total number of orders shipped by each shipper, including those with no orders?

SELECT 
    s.ShipperName, 
    COUNT(o.OrderID) AS TotalOrders
FROM Shippers s
LEFT JOIN Orders o ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperName;

12. What are the employees who have processed > 5 orders? Sort the result by the number of orders in descending order.

SELECT 
	e.EmployeeID, 
	e.FirstName, 
	e.LastName, 
COUNT(o.OrderID) AS OrderCount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName #(have to group by all columns that are selected)
HAVING COUNT(o.OrderID) > 5
ORDER BY OrderCount DESC;

13. What is the total revenue for each product within each order, including the product name and ordered by order ID and total revenue in descending order?

SELECT 
	od.OrderID,
	p.ProductID,
	p.ProductName,
	ROUND(CAST(SUM(p.Price * od.Quantity) AS NUMERIC), 2) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.OrderID, p.ProductID, p.ProductName
ORDER BY od.OrderID, TotalRevenue DESC;

14. What are the customers, employees, and the total number of orders placed by each customer?

SELECT 
    c.CustomerID, 
    c.CustomerName, 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    COUNT(o.OrderID) AS TotalOrders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY c.CustomerID, c.CustomerName, e.EmployeeID, e.FirstName, e.LastName;


15. What are the products with an average price higher than the overall average product price? 
    Round the price to 2 decimal places and sort the result by price in descending order.

SELECT 
    ProductID, 
    ProductName, 
    ROUND(CAST(Price AS NUMERIC), 2) AS Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;
