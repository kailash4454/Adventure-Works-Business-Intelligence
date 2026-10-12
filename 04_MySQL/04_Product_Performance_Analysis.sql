
## Query 1 – Top 10 Products by Sales Revenue
-- Business Question:
-- Which products generate the highest sales?

SELECT
    p.EnglishProductName,
    ROUND(SUM(f.SalesAmount),2) AS TotalSales
FROM master_fact_internet_sales f
JOIN DimProduct p
ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY TotalSales DESC
LIMIT 10;

-- Business Insight
-- Identifies your best-selling products by revenue.
-- Useful for promotions and inventory planning.

## Query 2 – Bottom 10 Products by Sales

SELECT
    p.EnglishProductName,
    ROUND(SUM(f.SalesAmount),2) AS TotalSales
FROM master_fact_internet_sales f
JOIN DimProduct p
ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY TotalSales ASC
LIMIT 10;

-- Insight
-- Candidates for discontinuation or marketing improvements.


## Query 3 – Top 10 Products by Profit

SELECT

p.EnglishProductName,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

GROUP BY p.EnglishProductName

ORDER BY Profit DESC

LIMIT 10;


## Query 5 – Most Sold Products (Quantity)
-- Revenue and quantity are different KPIs.

SELECT
p.EnglishProductName,
SUM(f.OrderQuantity) AS QuantitySold
FROM master_fact_internet_sales f
JOIN DimProduct p
ON f.ProductKey=p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY QuantitySold DESC
LIMIT 10;


## Query 6 – Product-wise Average Selling Price

SELECT
p.EnglishProductName,
ROUND(AVG(f.UnitPrice),2) AS AveragePrice
FROM master_fact_internet_sales f
JOIN DimProduct p
ON f.ProductKey=p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY AveragePrice DESC;


## Query 7 – Sales by Product Category

SELECT

pc.EnglishProductCategoryName AS Category,

ROUND(SUM(f.SalesAmount),2) AS Sales

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

JOIN DimProductCategory pc
ON ps.ProductCategoryKey=pc.ProductCategoryKey

GROUP BY pc.EnglishProductCategoryName

ORDER BY Sales DESC;


## Query 8 – Profit by Category

SELECT

pc.EnglishProductCategoryName,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

JOIN DimProductCategory pc
ON ps.ProductCategoryKey=pc.ProductCategoryKey

GROUP BY pc.EnglishProductCategoryName

ORDER BY Profit DESC;


## Query 9 – Sales by Subcategory

SELECT

ps.EnglishProductSubcategoryName,

ROUND(SUM(f.SalesAmount),2) AS Sales

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

GROUP BY ps.EnglishProductSubcategoryName

ORDER BY Sales DESC;


## Query 10 – Product Profit Margin

SELECT

p.EnglishProductName,

ROUND(AVG(f.ProfitMargin),2) AS ProfitMargin

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

GROUP BY p.EnglishProductName

ORDER BY ProfitMargin DESC

LIMIT 20;


## Query 11 – Product Contribution to Total Sales (Pareto Analysis)
-- This identifies which products contribute the most revenue.

SELECT

p.EnglishProductName,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(
SUM(f.SalesAmount)
/
(
SELECT SUM(SalesAmount)
FROM master_fact_internet_sales
)
*100,
2
) AS ContributionPercent

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

GROUP BY p.EnglishProductName

ORDER BY Sales DESC;

-- This is the first step toward an 80/20 (Pareto) analysis.



## Query 12 – Complete Product Performance Dashboard Dataset

SELECT

p.EnglishProductName,

pc.EnglishProductCategoryName,

ps.EnglishProductSubcategoryName,

SUM(f.OrderQuantity) AS Quantity,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.TotalProductCost),2) AS Cost,

ROUND(SUM(f.Profit),2) AS Profit,

ROUND(AVG(f.ProfitMargin),2) AS ProfitMargin,

ROUND(AVG(f.UnitPrice),2) AS AvgPrice

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

JOIN DimProductCategory pc
ON ps.ProductCategoryKey=pc.ProductCategoryKey

GROUP BY

p.EnglishProductName,

pc.EnglishProductCategoryName,

ps.EnglishProductSubcategoryName

ORDER BY Sales DESC;

-- This query can directly feed a Power BI or Tableau dashboard with product-level KPIs.


## Product Color-wise Sales

SELECT
    p.Color,
    ROUND(SUM(f.SalesAmount),2) AS Sales
FROM master_fact_internet_sales f
JOIN DimProduct p
ON f.ProductKey = p.ProductKey
GROUP BY p.Color
ORDER BY Sales DESC;