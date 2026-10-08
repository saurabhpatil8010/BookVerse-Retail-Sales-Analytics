create database BookVerse_DB;

use BookVerse_DB;

show databases;

USE BookVerse_DB;

-- Books Table 

CREATE TABLE Books
(
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(150),
    Genre VARCHAR(100),
    Published_Year INT,
    Price DECIMAL(10,2),
    Stock INT
);

desc Books;

-- Customers Table 

CREATE TABLE Customers
(
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(120),
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    City VARCHAR(100),
    Country VARCHAR(100)
);

desc Customers;

-- Orders Table 

CREATE TABLE Orders
(
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),

    FOREIGN KEY (Book_ID)
        REFERENCES Books(Book_ID)
);

desc Orders;

DROP TABLE Orders;

SELECT COUNT(*) AS Total_Books
FROM Books;

SELECT * FROM Books
LIMIT 10;

show tables;

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT *
FROM Customers
LIMIT 10;

show tables;

desc Orders;

SELECT COUNT(*) AS Total_Orders
FROM Orders;

SELECT *
FROM Orders
LIMIT 10;

-- ******************************************************************************************************
-- Total Orders 
SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- Null values Check 
SELECT
    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Book_ID IS NULL) AS Missing_Book_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Total_Amount IS NULL) AS Missing_Total_Amount
FROM Orders;

-- Duplicate Oredr_ID Check 
SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Custoner ID Match check table
SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Book ID Match check
SELECT o.Book_ID
FROM Orders o
LEFT JOIN Books b
    ON o.Book_ID = b.Book_ID
WHERE b.Book_ID IS NULL;

-- Invalid Quantit check 
SELECT *
FROM Orders
WHERE Quantity <= 0;

-- Invalid Total Amount Check 
SELECT *
FROM Orders
WHERE Total_Amount < 0;

-- *******************************************************************************************************
-- Q1. Total number of books 

SELECT COUNT(*) AS Total_Books
FROM Books;

-- Q2. Total number of customers 

SELECT COUNT(*) AS Total_Customers
FROM Customers;

-- Q3. Total number of orders

SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- Q4. What are the different genres available

SELECT DISTINCT Genre
FROM Books;

-- Q5. What are the different countries represented in the customer data

SELECT DISTINCT Country
FROM Customers;

-- Q6. What is the total quantity of books sold

SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM Orders;

-- Q7. What is the total revenue generated

SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- Q8. What is the average order value

SELECT AVG(Total_Amount) AS Average_Order_Value
FROM Orders;

-- *******************************************************************************************************

-- Understand Sales Performance
-- The Sales team wants to understand overall sales performance and 
-- identify the books, authors, and genres that contribute most to revenue.

USE BookVerse_DB;

-- 1. Overall Order Volume
SELECT COUNT(*) AS Total_Orders
FROM Orders;


-- 2. Total Quantity Sold
SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM Orders;


-- 3. Total Revenue
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;


-- 4. Sales by Book
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Revenue DESC;


-- 5. Sales by Author
SELECT
    b.Author,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Author
ORDER BY Total_Revenue DESC;


-- 6. Sales by Genre
SELECT
    b.Genre,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Genre
ORDER BY Total_Revenue DESC;


-- 7. Monthly Sales Trends
SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    SUM(Total_Amount) AS Monthly_Revenue
FROM Orders
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month;


-- 8. Yearly Sales Trends
SELECT
    YEAR(Order_Date) AS Sales_Year,
    SUM(Total_Amount) AS Yearly_Revenue
FROM Orders
GROUP BY
    YEAR(Order_Date)
ORDER BY
    Sales_Year;


-- 9. High-Value Books
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Revenue DESC
LIMIT 10;


-- 10. High-Volume Books
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- *******************************************************************************************************

-- Understand Customer Purchasing Behaviour
-- The Marketing team wants to understand how customers interact with BookVerse and identify valuable and highly active customers.

USE BookVerse_DB;

-- 1. Number of Orders per Customer
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Orders DESC;


-- 2. Total Purchase Amount
SELECT
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Purchase_Amount
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Purchase_Amount DESC;


-- 3. Average Customer Spending
SELECT
    c.Customer_ID,
    c.Name,
    AVG(o.Total_Amount) AS Average_Spending
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Average_Spending DESC;


-- 4. Repeat Customers
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(o.Order_ID) > 1
ORDER BY Total_Orders DESC;


-- 5. Customer Activity by Country
SELECT
    c.Country,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Country
ORDER BY Total_Orders DESC;


-- 6. Geographic Business Patterns
SELECT
    c.Country,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Country
ORDER BY Total_Revenue DESC;


-- 7. Customers Purchasing Across Multiple Genres
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(DISTINCT b.Genre) AS Different_Genres
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(DISTINCT b.Genre) > 1
ORDER BY Different_Genres DESC;


-- 8. Customer Purchasing Behaviour Over Time
SELECT
    YEAR(o.Order_Date) AS Sales_Year,
    MONTH(o.Order_Date) AS Sales_Month,
    COUNT(o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Active_Customers,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Orders o
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month;

-- *******************************************************************************************************

-- Understand Product and Genre Performance
-- The management team wants to understand how different books, authors, and genres are performing in the marketplace.

USE BookVerse_DB;


-- 1. Books with the Highest Quantity Sold
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Quantity_Sold DESC;


-- 2. Books Generating the Highest Revenue
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Revenue DESC;


-- 3. Genre-wise Sales
SELECT
    b.Genre,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Genre
ORDER BY Total_Quantity_Sold DESC;


-- 4. Genre-wise Revenue
SELECT
    b.Genre,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Genre
ORDER BY Total_Revenue DESC;


-- 5. Author-wise Performance
SELECT
    b.Author,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Author
ORDER BY Total_Revenue DESC;


-- 6. High-Priced Books
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Price
FROM Books
ORDER BY Price DESC
LIMIT 10;


-- 7. Books with Low Sales
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Quantity_Sold ASC;


-- 8. Books That Have Never Been Ordered
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL;


-- 9. Relationship Between Product Price and Sales
SELECT
    b.Book_ID,
    b.Title,
    b.Price,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Price
ORDER BY b.Price DESC;

-- *******************************************************************************************************

-- Understand Inventory Position
-- The Operations team wants to understand the current inventory position and identify products that may 
-- require attention before the next procurement cycle.

USE BookVerse_DB;


-- 1. Current Stock Levels
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Stock
FROM Books
ORDER BY Stock DESC;


-- 2. Low-Stock Books
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Stock
FROM Books
WHERE Stock < 10
ORDER BY Stock ASC;


-- 3. Stock by Genre
SELECT
    Genre,
    SUM(Stock) AS Total_Stock
FROM Books
GROUP BY Genre
ORDER BY Total_Stock DESC;


-- 4. Inventory Value by Genre
SELECT
    Genre,
    SUM(Price * Stock) AS Inventory_Value
FROM Books
GROUP BY Genre
ORDER BY Inventory_Value DESC;


-- 5. Inventory Value by Author
SELECT
    Author,
    SUM(Price * Stock) AS Inventory_Value
FROM Books
GROUP BY Author
ORDER BY Inventory_Value DESC;


-- 6. High-Value Inventory
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Price,
    Stock,
    (Price * Stock) AS Inventory_Value
FROM Books
ORDER BY Inventory_Value DESC
LIMIT 10;


-- 7. High Stock but Low Sales
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Total_Quantity_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING
    b.Stock > 50
    AND COALESCE(SUM(o.Quantity), 0) < 10
ORDER BY
    b.Stock DESC;


-- 8. Low Stock but High Sales
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Total_Quantity_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING
    b.Stock < 10
    AND COALESCE(SUM(o.Quantity), 0) > 20
ORDER BY
    Total_Quantity_Sold DESC;


-- 9. Books That Have Never Been Ordered
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL;

-- *******************************************************************************************************

-- Identify Sales and Inventory Opportunities
-- Management wants to identify potential business opportunities by combining sales performance, customer behaviour, 
-- and current inventory information.

USE BookVerse_DB;

-- 1. High-Selling Books with Low Stock
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING
    b.Stock < 10
    AND SUM(o.Quantity) > 20
ORDER BY Total_Quantity_Sold DESC;


-- 2. High-Stock Books with Low Sales
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Total_Quantity_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING
    b.Stock > 50
    AND COALESCE(SUM(o.Quantity), 0) < 10
ORDER BY b.Stock DESC;


-- 3. Popular Genres with Limited Inventory
SELECT
    b.Genre,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(b.Stock) AS Total_Stock
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Genre
HAVING
    SUM(o.Quantity) > 20
    AND SUM(b.Stock) < 100
ORDER BY Total_Quantity_Sold DESC;


-- 4. High-Value Customers
SELECT
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Purchase_Amount
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Purchase_Amount DESC
LIMIT 10;


-- 5. Books with Strong Demand
SELECT
    b.Book_ID,
    b.Title,
    b.Genre,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Genre
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;


-- 6. Books That Have Never Been Ordered
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL;


-- 7. Customers Purchasing Across Multiple Genres
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(DISTINCT b.Genre) AS Different_Genres
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(DISTINCT b.Genre) > 1
ORDER BY Different_Genres DESC;


-- 8. Products Requiring Promotional Attention
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL
  AND b.Stock > 0
ORDER BY b.Stock DESC;


-- 9. Products Requiring Replenishment
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING
    b.Stock < 10
    AND SUM(o.Quantity) > 20
ORDER BY Total_Quantity_Sold DESC;

-- *******************************************************************************************************