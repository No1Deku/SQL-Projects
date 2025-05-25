

WITH ProductSales AS (
    SELECT 
        Product_Name,
        SUM(Sales) AS TotalSales,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS Sales_Rank
    FROM Retail_Details
    GROUP BY Product_Name
)
SELECT 
    Product_Name,
    TotalSales
FROM 
    ProductSales
WHERE 
    Sales_Rank <= 10
ORDER BY 
    TotalSales DESC;



Update Retail_Details
set Order_Date=Replace(Order_Date,'/','-')

Update Retail_Details
set Ship_Date=Replace(Order_Date,'/','-')

Update Retail_Details
set Order_Date = CONVERT(DATE, Order_Date, 105)

Update Retail_Details
set Ship_Date= CONVERT(DATE,Ship_Date,105)

SELECT 
  DATEPART(YEAR, Order_Date) AS SaleYear,
  DATEPART(QUARTER, Order_Date) AS SaleQuarter,
  DATEPART(MONTH, Order_Date) AS SaleMonth,
  ROUND(SUM(Sales), 2) AS Total_Sales
FROM Retail_Details
GROUP BY 
  DATEPART(YEAR, Order_Date),
  DATEPART(QUARTER, Order_Date),
  DATEPART(MONTH, Order_Date)
ORDER BY 
  SaleYear,
  SaleQuarter,
  SaleMonth;


SELECT Segment, ROUND(SUM(Sales), 2) AS Revenue
FROM Retail_Details
GROUP BY Segment
ORDER BY Revenue DESC;



WITH RankedSales AS (
    SELECT 
        state,
        Region,
        SUM(Sales) AS TotalSales,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS Revenue_Rankings
    FROM Retail_Details
    GROUP BY state, Region
)
SELECT 
    state,
    Region,
    TotalSales
FROM RankedSales
WHERE Revenue_Rankings <= 4
ORDER BY Revenue_Rankings;


SELECT TOP 10 Customer_ID, COUNT(Order_ID) AS No_Customer_Orders
FROM Retail_Details
GROUP BY Customer_ID
ORDER BY No_Customer_Orders DESC;

SELECT 
    AVG(DATEDIFF(day, Order_Date, Ship_Date)) AS Avg_Shipping_Time_Days
FROM Retail_Details
WHERE Ship_Date IS NOT NULL AND Order_Date IS NOT NULL;


SELECT  
  Category,  
  DATEPART(YEAR, Order_Date) AS SaleYear,
  DATEPART(QUARTER, Order_Date) AS SaleQuarter,
  ROUND(SUM(Sales), 2) AS Total_Sales
FROM Retail_Details
GROUP BY 
  Category,
  DATEPART(YEAR, Order_Date),
  DATEPART(QUARTER, Order_Date)
ORDER BY 
  Category,
  SaleYear,
  SaleQuarter;



WITH RankedSales AS (
    SELECT 
        city,
        SUM(Sales) AS TotalSales,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS Revenue_Rankings
    FROM Retail_Details
    GROUP BY city
)
SELECT 
    city,
    TotalSales
FROM RankedSales
WHERE Revenue_Rankings <= 5
ORDER BY Revenue_Rankings;



SELECT 
    Customer_ID,
    ROUND(SUM(Sales), 2) AS Total_Customer_Revenue
FROM Retail_Details
GROUP BY Customer_ID
ORDER BY Total_Customer_Revenue DESC;

SELECT 
    Order_ID,
    AVG(Sales) AS Average_Sales
FROM Retail_Details 
GROUP BY Order_ID;

SELECT 
    Order_ID,
    Segment,
    ROUND(AVG(Sales),2) AS Average_Sales
FROM Retail_Details
GROUP BY Order_ID, Segment;