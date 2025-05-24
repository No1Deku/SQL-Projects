Retail Sales Analysis SQL Project

Project Overview

Project Title: Retail Sales Analysis (Zero Analysts SQL Project)Level: Junior Data AnalystDatabase: SQL_PROJECTS_ZERO_ANALYSTS

This SQL project is designed as a beginner-friendly portfolio piece for aspiring data analysts. The main objective is to apply fundamental SQL skills to explore, clean, and analyze real-world retail sales data. This project showcases how junior data professionals can derive meaningful insights using SQL Server tools and syntax.

Objectives

Database Initialization: Create and set up a new database for retail sales data.

Data Cleaning: Detect and eliminate missing or incomplete records.

Exploratory Data Analysis (EDA): Understand the structure and trends in the data.

Business Insight Generation: Write SQL queries to solve key business problems.

Database Setup

Step 1: Create Database and Table

CREATE DATABASE SQL_PROJECTS_ZERO_ANALYSTS;
USE SQL_PROJECTS_ZERO_ANALYSTS;

CREATE TABLE Retail_Sales(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

Step 2: Load Data Using Bulk Insert

BULK INSERT [dbo].[Retail_Sales]
FROM 'D:\ZERO ANALYSTS SQL\Retail-Sales-Analysis-SQL-Project--P1-main\SQL - Retail Sales Analysis_utf .csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

Data Cleaning

Identify Missing Records

DECLARE @sql NVARCHAR(MAX);

SELECT @sql = STRING_AGG(QUOTENAME(COLUMN_NAME) + ' IS NULL', ' OR ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Sales';

SET @sql = 'SELECT * FROM Retail_Sales WHERE ' + @sql;
EXEC sp_executesql @sql;

Remove Null Entries

DELETE FROM Retail_Sales 
WHERE gender IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

Exploratory Data Analysis

Basic Stats

SELECT COUNT(*) AS Total_Records FROM Retail_Sales;

WITH CustomerCounts AS (
  SELECT 
    COUNT(customer_id) AS Total_Customers,
    COUNT(DISTINCT customer_id) AS Unique_Count
  FROM Retail_Sales
)
SELECT 
  Total_Customers,
  Unique_Count,
  Total_Customers - Unique_Count AS Number_Of_Repeat_Customers
FROM CustomerCounts;

SELECT DISTINCT category AS All_Categories FROM Retail_Sales;

Business Analysis Queries

1. Sales on Specific Day

SELECT * FROM Retail_Sales 
WHERE sale_date = '2022-11-05';

2. High Quantity Clothing Sales in November

SELECT * 
FROM Retail_Sales
WHERE category = 'Clothing'
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
  AND quantiy >= 4;

3. Total and Count by Category

SELECT 
    category, 
    '$' + FORMAT(SUM(total_sale), 'N2') AS Total_by_Category,
    COUNT(total_sale) AS Total_by_Orders
FROM Retail_Sales
GROUP BY category;

4. Average Age for Beauty Buyers

SELECT AVG(age) AS [Average Age of Customers] 
FROM Retail_Sales
WHERE category = 'Beauty';

5. High-Value Transactions

SELECT * FROM Retail_Sales
WHERE total_sale > 1000;

6. Transaction Count by Gender and Category

SELECT 
    category,
    gender,
    COUNT(*) AS Count_Transactions
FROM Retail_Sales
GROUP BY category, gender
ORDER BY category;

7. Best Performing Month Each Year

WITH Monthly_Avg AS (
    SELECT 
        YEAR(sale_date) AS Yearly,
        MONTH(sale_date) AS Montly,
        ROUND(AVG(total_sale), 2) AS AVG_MONTHLY
    FROM Retail_Sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
Monthly_Report AS (
    SELECT *,
           RANK() OVER (PARTITION BY Yearly ORDER BY AVG_MONTHLY DESC) AS Monthly_Rank
    FROM Monthly_Avg
)
SELECT 
    Yearly,
    Montly,
    AVG_MONTHLY,
    Monthly_Rank
FROM Monthly_Report
WHERE Monthly_Rank = 1
ORDER BY Yearly, Montly;

8. Top 5 Customers by Total Sales

SELECT TOP 5 
    customer_id, 
    SUM(total_sale) AS total_sale_sum
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sale_sum DESC;

9. Unique Customers by Category

SELECT 
    COUNT(DISTINCT customer_id) AS Unique_Customers,
    category
FROM Retail_Sales
GROUP BY category;

10. Sales by Shift (Time of Day)

SELECT 
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning Shift'
    WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) < 18 THEN 'Afternoon Shift'
    WHEN DATEPART(HOUR, sale_time) >= 18 THEN 'Evening Shift'
    ELSE 'Unknown Shift'
  END AS Shift,
  COUNT(transactions_id) AS Transactions_Count
FROM Retail_Sales
GROUP BY 
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning Shift'
    WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) < 18 THEN 'Afternoon Shift'
    WHEN DATEPART(HOUR, sale_time) >= 18 THEN 'Evening Shift'
    ELSE 'Unknown Shift'
  END;

Key Insights

There are notable spikes in sales on specific days and months, which can inform marketing strategies.

Clothing and Beauty were among the more active categories in terms of quantity and value.

Certain customers stand out with exceptionally high total purchase values.

Morning and Afternoon shifts appear to contribute most of the sales volume.

Conclusion

This project demonstrates how SQL Server can be used by entry-level data analysts to perform data validation, analysis, and business intelligence reporting. The use of common SQL clauses and window functions shows a developing competency in SQL-based data analytics.

Project Credit: Built as a beginner SQL project under the "Zero Analysts" brand for developing foundational skills.

Feedback or Collaboration: If you're a fellow junior analyst, student, or mentor, I’d love to connect and hear your thoughts!