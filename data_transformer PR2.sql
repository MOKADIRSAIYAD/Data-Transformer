-- =====================================================
-- Project : Data Transformer
-- Database: MySQL 8.0 (MySQL Workbench)
-- Run     : Open in Workbench -> Ctrl+Shift+Enter (run all)
-- =====================================================

DROP DATABASE IF EXISTS data_transformer;
CREATE DATABASE data_transformer;
USE data_transformer;

-- -----------------------------------------------------
-- 1. TABLE CREATION
-- -----------------------------------------------------
CREATE TABLE Customers (
    CustomerID       INT PRIMARY KEY,
    FirstName        VARCHAR(50)  NOT NULL,
    LastName         VARCHAR(50)  NOT NULL,
    Email            VARCHAR(100),
    RegistrationDate DATE
);

CREATE TABLE Orders (
    OrderID     INT PRIMARY KEY,
    CustomerID  INT,
    OrderDate   DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50) NOT NULL,
    LastName   VARCHAR(50) NOT NULL,
    Department VARCHAR(50),
    HireDate   DATE,
    Salary     DECIMAL(10,2)
);

-- -----------------------------------------------------
-- 2. SAMPLE DATA
-- (first 2 rows of each table are from the assignment;
--  extra rows added for better demo of joins/functions)
-- -----------------------------------------------------
INSERT INTO Customers VALUES
(1, 'John',  'Doe',    'john.doe@email.com',        '2022-03-15'),
(2, 'Jane',  'Smith',  'jane.smith@email.com',      '2021-11-02'),
(3, 'Rahul', 'Sharma', '  rahul.sharma@email.com ', '2023-01-10'),  -- extra spaces for TRIM demo
(4, 'Priya', 'Patel',  'priya.patel@email.com',     '2023-05-21');  -- no orders (LEFT JOIN demo)

INSERT INTO Orders VALUES
(101, 1, '2023-07-01',  150.50),
(102, 2, '2023-07-03',  200.75),
(103, 1, '2023-07-10', 1200.00),
(104, 3, '2023-08-05',  650.25),
(105, 2, '2023-08-15',  480.00);

INSERT INTO Employees VALUES
(1, 'Mark',  'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee',     'HR',    '2021-03-20', 55000.00),
(3, 'Amit',  'Verma',   'IT',    '2019-06-01', 85000.00),
(4, 'Neha',  'Joshi',   'IT',    '2022-09-12', 30000.00);

-- -----------------------------------------------------
-- 3. QUERIES
-- -----------------------------------------------------

-- Q1. INNER JOIN: orders with customer details
SELECT o.OrderID, o.OrderDate, o.TotalAmount,
       c.CustomerID, c.FirstName, c.LastName, c.Email
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Q2. LEFT JOIN: all customers and their orders (if any)
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Q3. RIGHT JOIN: all orders and their customers (if any)
SELECT o.OrderID, o.TotalAmount, c.CustomerID, c.FirstName, c.LastName
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Q4. FULL OUTER JOIN (MySQL has no FULL JOIN -> LEFT UNION RIGHT)
SELECT c.CustomerID, c.FirstName, o.OrderID, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.CustomerID, c.FirstName, o.OrderID, o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Q5. Subquery: customers who placed orders worth more than the average amount
SELECT CustomerID, FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- Q6. Subquery: employees with salary above the average salary
SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- Q7. Extract year and month from OrderDate
SELECT OrderID, OrderDate,
       YEAR(OrderDate)  AS OrderYear,
       MONTH(OrderDate) AS OrderMonth
FROM Orders;

-- Q8. Difference in days between OrderDate and current date
SELECT OrderID, OrderDate, CURDATE() AS Today,
       DATEDIFF(CURDATE(), OrderDate) AS DaysDifference
FROM Orders;

-- Q9. Format OrderDate (DD-MMM-YYYY)
SELECT OrderID, OrderDate,
       DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders;

-- Q10. Concatenate FirstName and LastName -> full name
SELECT CustomerID,
       CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- Q11. Replace part of a string ('John' -> 'Jonathan')
SELECT CustomerID, FirstName,
       REPLACE(FirstName, 'John', 'Jonathan') AS ReplacedName
FROM Customers;

-- Q12. FirstName in UPPERCASE, LastName in lowercase
SELECT CustomerID,
       UPPER(FirstName) AS FirstNameUpper,
       LOWER(LastName)  AS LastNameLower
FROM Customers;

-- Q13. Trim extra spaces from Email
SELECT CustomerID, Email AS OriginalEmail,
       TRIM(Email)       AS TrimmedEmail
FROM Customers;

-- Q14. Running total of TotalAmount (ordered by order date / id)
SELECT OrderID, CustomerID, OrderDate, TotalAmount,
       SUM(TotalAmount) OVER (ORDER BY OrderDate, OrderID) AS RunningTotal
FROM Orders;

-- Q15. Rank orders by TotalAmount using RANK()
SELECT OrderID, CustomerID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM Orders;

-- Q16. Discount based on TotalAmount (>1000: 10%, >500: 5%, else 0%)
SELECT OrderID, TotalAmount,
       CASE
           WHEN TotalAmount > 1000 THEN '10% off'
           WHEN TotalAmount > 500  THEN '5% off'
           ELSE 'No discount'
       END AS Discount,
       CASE
           WHEN TotalAmount > 1000 THEN TotalAmount * 0.90
           WHEN TotalAmount > 500  THEN TotalAmount * 0.95
           ELSE TotalAmount
       END AS FinalAmount
FROM Orders;

-- Q17. Categorize employees' salaries as High / Medium / Low
-- (assumption: >= 70000 High, >= 40000 Medium, else Low)
SELECT EmployeeID, FirstName, LastName, Salary,
       CASE
           WHEN Salary >= 70000 THEN 'High'
           WHEN Salary >= 40000 THEN 'Medium'
           ELSE 'Low'
       END AS SalaryCategory
FROM Employees;
