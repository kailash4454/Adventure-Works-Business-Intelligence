USE adventure_works;

-- Query 1 – Top 10 Customers by Sales
-- Business Question
-- Which customers generate the highest revenue?

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

ROUND(SUM(f.SalesAmount),2) AS TotalSales

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey = c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

ORDER BY TotalSales DESC

LIMIT 10;

-- Business Insight
-- These customers contribute the largest share of revenue.


## Query 2 – Top 10 Customers by Profit

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

ROUND(SUM(f.Profit),2) AS TotalProfit

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

ORDER BY TotalProfit DESC

LIMIT 10;


## Query 3 – Customers with Highest Number of Orders

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

COUNT(DISTINCT f.SalesOrderNumber) AS Orders

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

ORDER BY Orders DESC

LIMIT 10;


## Query 4 – Highest Quantity Purchased

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

SUM(f.OrderQuantity) AS QuantityPurchased

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

ORDER BY QuantityPurchased DESC

LIMIT 10;


## Query 5 – Average Customer Spend

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

ROUND(AVG(f.SalesAmount),2) AS AverageSpend

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

ORDER BY AverageSpend DESC

LIMIT 20;


## Query 6 – Customer Lifetime Value (CLV)
-- One of the most popular customer analytics metrics.

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

ROUND(SUM(f.SalesAmount),2) AS CustomerLifetimeValue

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

ORDER BY CustomerLifetimeValue DESC;


## Query 7 – Repeat Customers
-- Customers who placed more than one order.

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

COUNT(DISTINCT f.SalesOrderNumber) AS Orders

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

HAVING Orders > 1

ORDER BY Orders DESC;


## Query 8 – One-Time Customers

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

COUNT(DISTINCT f.SalesOrderNumber) AS Orders

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

HAVING Orders = 1;


## Query 9 – Customer Sales by Gender
-- Adventure Works customer data contains gender information.

SELECT

c.Gender,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY c.Gender;


## Query 10 – Customer Sales by Marital Status

SELECT

c.MaritalStatus,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY c.MaritalStatus;


## Query 11 – Customer Sales by Occupation

SELECT

c.EnglishOccupation,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY c.EnglishOccupation

ORDER BY Sales DESC;


## Query 12 – Customer Sales by Education

SELECT

c.EnglishEducation,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY c.EnglishEducation

ORDER BY Sales DESC;


## Query 13 – Customer Sales by Geography
-- Adventure Works stores customer geography details.

SELECT

c.CountryRegionCode,

ROUND(SUM(f.SalesAmount),2) AS Sales,

COUNT(DISTINCT f.CustomerKey) AS Customers

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY c.CountryRegionCode

ORDER BY Sales DESC;


## Query 14 – Customer Segmentation
-- Classify customers based on Lifetime Value.

SELECT

CustomerName,

CustomerLifetimeValue,

CASE

WHEN CustomerLifetimeValue >= 10000 THEN 'High Value'

WHEN CustomerLifetimeValue >= 5000 THEN 'Medium Value'

ELSE 'Low Value'

END AS CustomerSegment

FROM
(
SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

SUM(f.SalesAmount) AS CustomerLifetimeValue

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
CustomerName

)t

ORDER BY CustomerLifetimeValue DESC;


## Query 15 – Complete Customer Dashboard Dataset

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

c.Gender,

c.MaritalStatus,

c.EnglishOccupation,

c.EnglishEducation,

COUNT(DISTINCT f.SalesOrderNumber) AS Orders,

SUM(f.OrderQuantity) AS Quantity,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.TotalProductCost),2) AS Cost,

ROUND(SUM(f.Profit),2) AS Profit,

ROUND(AVG(f.ProfitMargin),2) AS AvgProfitMargin

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY

c.CustomerKey,
CustomerName,

c.Gender,

c.MaritalStatus,

c.EnglishOccupation,

c.EnglishEducation

ORDER BY Sales DESC;