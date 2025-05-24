Create Database SQL_PROJECTS_ZERO_ANALYSTS;

USE SQL_PROJECTS_ZERO_ANALYSTS;

--sql project p1

Create Table Retail_Sales(
	transactions_id int primary key,		
	sale_date date,
	sale_time time,
	customer_id int,	
	gender	varchar(15),
	age	int,	
	category varchar(15),	
	quantiy	int,
	price_per_unit float,
	cogs  float,
	total_sale float
);

BULK INSERT [dbo].[Retail_Sales]
From 'D:\ZERO ANALYSTS SQL\Retail-Sales-Analysis-SQL-Project--P1-main\SQL - Retail Sales Analysis_utf .csv'
WITH (
FIRSTROW =2,
FIELDTERMINATOR=',' ,
RowTerminator = '\n')

Select * from Retail_Sales

Select Count(*) as Total_Records from Retail_Sales





DECLARE @sql NVARCHAR(MAX);

SELECT @sql = STRING_AGG(QUOTENAME(COLUMN_NAME) + ' IS NULL', ' OR ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Sales';

SET @sql = 'SELECT * FROM Retail_Sales WHERE ' + @sql;

EXEC sp_executesql @sql;

Delete from Retail_Sales 
Where gender is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null

-- Key operation so far include evaluating data finding duplicates or missing data remove or filling in data



--EDA Operations

Select COUNT(*) as 'Total Completed Sales' from Retail_Sales

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



Select distinct(category) as All_Categories from Retail_Sales

--DATA ANALYSIS AND Business Key Problems and Answers

Select * from	Retail_Sales 
where sale_date = '2022-11-05';

SELECT * 
FROM Retail_Sales
WHERE category = 'Clothing'
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
  and quantiy > =4;

	

SELECT 
    category, 
    '$' + FORMAT(SUM(total_sale), 'N2') AS Total_by_Category,
	COUNT(total_sale) as Total_by_Orders	
FROM Retail_Sales
GROUP BY category;


Select avg(age) as 'Average Age of Customers' from Retail_Sales
where category = 'Beauty';


Select * from Retail_Sales
where total_sale > 1000



Select category,gender,count(*) as Count_Transactions from Retail_Sales
group by category,gender
ORDER BY 1



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

SELECT TOP 5 
    customer_id, 
    SUM(total_sale) AS total_sale_sum
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sale_sum DESC;



Select count(distinct(customer_id)) As Unique_Customers,category  from Retail_Sales
group by category


SELECT * FROM Retail_Sales


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

