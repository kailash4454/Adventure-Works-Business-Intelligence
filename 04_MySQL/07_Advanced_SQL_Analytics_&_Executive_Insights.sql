USE adventure_works;

## Module 1 – Window Functions

-- Query 1 – Rank Products by Sales
-- Business Question:
-- Which products are ranked highest by sales?

SELECT
    p.EnglishProductName,
    ROUND(SUM(f.SalesAmount),2) AS Sales,
    RANK() OVER (
        ORDER BY SUM(f.SalesAmount) DESC
    ) AS SalesRank
FROM master_fact_internet_sales f
JOIN DimProduct p
ON f.ProductKey = p.ProductKey
GROUP BY
    p.ProductKey,
    p.EnglishProductName;
    

## Query 2 – Dense Rank Customers by Profit

SELECT

CONCAT(c.FirstName,' ',c.LastName) AS Customer,

ROUND(SUM(f.Profit),2) AS Profit,

DENSE_RANK() OVER(

ORDER BY SUM(f.Profit) DESC

) AS CustomerRank

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
c.CustomerKey,
Customer;


## Query 3 – Top 5 Products in Each Category

WITH ProductSales AS
(
SELECT

pc.EnglishProductCategoryName AS Category,

p.EnglishProductName AS Product,

SUM(f.SalesAmount) AS Sales

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

JOIN DimProductCategory pc
ON ps.ProductCategoryKey=pc.ProductCategoryKey

GROUP BY

Category,
Product
)

SELECT *

FROM
(
SELECT

*,

ROW_NUMBER()

OVER(
PARTITION BY Category
ORDER BY Sales DESC
) AS rn

FROM ProductSales
)t

WHERE rn<=5;


## Module 2 – Running Totals

-- Query 4 – Running Sales

WITH MonthlySales AS
(
SELECT

d.CalendarYear,

d.MonthNumberOfYear,

SUM(f.SalesAmount) AS Sales

FROM master_fact_internet_sales f

JOIN DimDate d
ON f.OrderDateKey=d.DateKey

GROUP BY
d.CalendarYear,
d.MonthNumberOfYear
)

SELECT

*,

SUM(Sales)

OVER(
ORDER BY CalendarYear,
MonthNumberOfYear
) AS RunningSales

FROM MonthlySales;


## Module 3 – Moving Average

-- Query 5 – Rolling 3-Month Average

WITH MonthlySales AS
(
SELECT

d.CalendarYear,

d.MonthNumberOfYear,

SUM(f.SalesAmount) AS Sales

FROM master_fact_internet_sales f

JOIN DimDate d
ON f.OrderDateKey=d.DateKey

GROUP BY
d.CalendarYear,
d.MonthNumberOfYear
)

SELECT

*,

ROUND(

AVG(Sales)

OVER(

ORDER BY CalendarYear,
MonthNumberOfYear

ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW

),

2

) AS MovingAverage

FROM MonthlySales;


## Module 4 – Month-over-Month Growth

WITH MonthlySales AS
(
SELECT

d.CalendarYear,

d.MonthNumberOfYear,

SUM(f.SalesAmount) AS Sales

FROM master_fact_internet_sales f

JOIN DimDate d
ON f.OrderDateKey=d.DateKey

GROUP BY
d.CalendarYear,
d.MonthNumberOfYear
)

SELECT

*,

ROUND(

(

Sales -

LAG(Sales)

OVER(

ORDER BY CalendarYear,
MonthNumberOfYear

)

)

/

LAG(Sales)

OVER(

ORDER BY CalendarYear,
MonthNumberOfYear

)

*100,

2

) AS GrowthPercent

FROM MonthlySales;


## Module 5 – Pareto Analysis (80/20 Rule)
-- Identify products contributing most to revenue.

WITH ProductSales AS
(
SELECT

p.EnglishProductName,

SUM(f.SalesAmount) AS Sales

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

GROUP BY
p.EnglishProductName
)

SELECT

EnglishProductName,

ROUND(Sales,2) AS Sales,

ROUND(

SUM(Sales)

OVER(

ORDER BY Sales DESC

)

/

SUM(Sales)

OVER()

*100,

2

) AS CumulativePercent

FROM ProductSales

ORDER BY Sales DESC;

-- Products that bring the cumulative percentage close to 80% are your high-impact products.


## Module 6 – Customer Segmentation

SELECT

CustomerName,

LifetimeSales,

CASE

WHEN LifetimeSales>=10000 THEN 'VIP'

WHEN LifetimeSales>=5000 THEN 'Premium'

WHEN LifetimeSales>=2000 THEN 'Regular'

ELSE 'Low Value'

END AS Segment

FROM
(
SELECT

CONCAT(c.FirstName,' ',c.LastName) CustomerName,

SUM(f.SalesAmount) LifetimeSales

FROM master_fact_internet_sales f

JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey

GROUP BY
CustomerName

)t;


## Module 7 – Sales Contribution by Category

SELECT

pc.EnglishProductCategoryName,

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

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

JOIN DimProductCategory pc
ON ps.ProductCategoryKey=pc.ProductCategoryKey

GROUP BY
pc.EnglishProductCategoryName;



## Module 8 – Executive KPI View
-- Instead of repeatedly writing the same KPI query, create a reusable view.

CREATE VIEW vw_ExecutiveKPIs AS

SELECT

ROUND(SUM(SalesAmount),2) AS TotalSales,

ROUND(SUM(TotalProductCost),2) AS TotalCost,

ROUND(SUM(Profit),2) AS TotalProfit,

ROUND(AVG(ProfitMargin),2) AS AvgProfitMargin,

COUNT(DISTINCT SalesOrderNumber) AS Orders,

COUNT(DISTINCT CustomerKey) AS Customers,

COUNT(DISTINCT ProductKey) AS Products,

SUM(OrderQuantity) AS QuantitySold

FROM master_fact_internet_sales;


-- Now retrieving executive KPIs is as simple as:

SELECT * FROM vw_ExecutiveKPIs;



## Module 9 – Territory Dashboard View

CREATE VIEW vw_TerritoryPerformance AS

SELECT

st.SalesTerritoryGroup,

st.SalesTerritoryCountry,

st.SalesTerritoryRegion,

SUM(f.SalesAmount) AS Sales,

SUM(f.Profit) AS Profit,

COUNT(DISTINCT f.CustomerKey) AS Customers

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY

st.SalesTerritoryGroup,

st.SalesTerritoryCountry,

st.SalesTerritoryRegion;


## Module 10 – Product Dashboard View

CREATE VIEW vw_ProductPerformance AS

SELECT

p.EnglishProductName,

pc.EnglishProductCategoryName,

SUM(f.SalesAmount) AS Sales,

SUM(f.Profit) AS Profit,

SUM(f.OrderQuantity) AS Quantity

FROM master_fact_internet_sales f

JOIN DimProduct p
ON f.ProductKey=p.ProductKey

JOIN DimProductSubCategory ps
ON p.ProductSubcategoryKey=ps.ProductSubcategoryKey

JOIN DimProductCategory pc
ON ps.ProductCategoryKey=pc.ProductCategoryKey

GROUP BY

p.EnglishProductName,

pc.EnglishProductCategoryName;