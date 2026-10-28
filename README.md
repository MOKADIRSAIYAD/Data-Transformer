# Data Transformer – SQL Project

A MySQL project simulating a **Corporate Data Analysis System** (Customers, Sales Orders, Employees). It demonstrates Joins, Subqueries, Date and String functions, Window Functions and the CASE expression.

## Tech Stack
- MySQL 8.0 (window functions require 8.0+)
- MySQL Workbench

## Project Structure
```
data-transformer/
├── data_transformer.sql   # DB + tables + sample data + all 17 queries
└── README.md
```

## How to Run
1. Open **MySQL Workbench** and connect to your local server.
2. `File → Open SQL Script…` and select `data_transformer.sql`.
3. Run the whole script with **Ctrl + Shift + Enter** (or the ⚡ icon).
4. To see a single query's output, select it and press **Ctrl + Enter**.

The script creates the database `data_transformer`, so it is safe to re-run (it drops and recreates it).

## Database Schema

**Customers**: `CustomerID` (PK), `FirstName`, `LastName`, `Email`, `RegistrationDate`

**Orders**: `OrderID` (PK), `CustomerID` (FK → Customers), `OrderDate`, `TotalAmount`

**Employees**: `EmployeeID` (PK), `FirstName`, `LastName`, `Department`, `HireDate`, `Salary`

## Queries Implemented

| # | Task | Technique |
|---|------|-----------|
| 1 | Orders with customer details | INNER JOIN |
| 2 | All customers and their orders | LEFT JOIN |
| 3 | All orders and their customers | RIGHT JOIN |
| 4 | All customers and all orders | FULL OUTER JOIN (LEFT JOIN `UNION` RIGHT JOIN) |
| 5 | Customers with orders above average amount | Subquery |
| 6 | Employees with salary above average | Subquery |
| 7 | Year and month from OrderDate | `YEAR()`, `MONTH()` |
| 8 | Days between OrderDate and today | `DATEDIFF()`, `CURDATE()` |
| 9 | Readable date format (DD-MMM-YYYY) | `DATE_FORMAT()` |
| 10 | Full name | `CONCAT()` |
| 11 | Replace part of a string | `REPLACE()` |
| 12 | Uppercase first name, lowercase last name | `UPPER()`, `LOWER()` |
| 13 | Remove extra spaces from Email | `TRIM()` |
| 14 | Running total of TotalAmount | `SUM() OVER (ORDER BY …)` |
| 15 | Rank orders by TotalAmount | `RANK() OVER (…)` |
| 16 | Discount by TotalAmount | `CASE` |
| 17 | Salary category (High / Medium / Low) | `CASE` |

## Assumptions
- The first two rows of each table come from the assignment; extra sample rows were added so joins and functions give meaningful output (e.g. a customer with no orders, an email with extra spaces).
- MySQL has no `FULL OUTER JOIN`, so it is emulated with `LEFT JOIN UNION RIGHT JOIN`.
- Because `Orders.CustomerID` is a foreign key, every order must have a customer, so the RIGHT JOIN returns the same rows as the INNER JOIN with this data.
- Running total (Q14) is calculated across all orders, ordered by `OrderDate` then `OrderID`.
- Discount (Q16): `TotalAmount > 1000` → 10% off, `> 500` → 5% off, otherwise no discount.
- Salary categories (Q17): `>= 70000` High, `>= 40000` Medium, otherwise Low.
- Q11 uses `'John'` → `'Jonathan'` as in the example; only rows containing "John" change.

## Notes
All code in this project is original and written for learning purposes.
