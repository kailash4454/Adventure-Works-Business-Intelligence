USE adventure_works;

-- Query 1 – Sales by Country
-- Business Question
-- Which countries generate the highest revenue?

SELECT

st.SalesTerritoryCountry,

ROUND(SUM(f.SalesAmount),2) AS TotalSales

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey = st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY TotalSales DESC;


## Query 2 – Profit by Country

SELECT

st.SalesTerritoryCountry,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY Profit DESC;


## Query 3 – Sales by Region

SELECT

st.SalesTerritoryRegion,

ROUND(SUM(f.SalesAmount),2) AS Sales

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryRegion

ORDER BY Sales DESC;


## Query 4 – Sales by Territory Group
-- Adventure Works classifies territories into groups such as:
-- North America
-- Europe
-- Pacific

SELECT

st.SalesTerritoryGroup,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.Profit),2) AS Profit

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryGroup

ORDER BY Sales DESC;


## Query 5 – Number of Customers by Country

SELECT

st.SalesTerritoryCountry,

COUNT(DISTINCT f.CustomerKey) AS Customers

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY Customers DESC;


## Query 6 – Orders by Country

SELECT

st.SalesTerritoryCountry,

COUNT(DISTINCT f.SalesOrderNumber) AS Orders

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY Orders DESC;


## Query 7 – Average Order Value by Country

SELECT

st.SalesTerritoryCountry,

ROUND(
SUM(f.SalesAmount)
/COUNT(DISTINCT f.SalesOrderNumber),
2
) AS AverageOrderValue

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY AverageOrderValue DESC;


## Query 8 – Average Profit Margin by Country

SELECT

st.SalesTerritoryCountry,

ROUND(
AVG(f.ProfitMargin),
2
) AS ProfitMargin

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY ProfitMargin DESC;


## Query 9 – Territory Performance Dashboard

SELECT

st.SalesTerritoryGroup,

st.SalesTerritoryCountry,

st.SalesTerritoryRegion,

COUNT(DISTINCT f.CustomerKey) AS Customers,

COUNT(DISTINCT f.SalesOrderNumber) AS Orders,

SUM(f.OrderQuantity) AS Quantity,

ROUND(SUM(f.SalesAmount),2) AS Sales,

ROUND(SUM(f.TotalProductCost),2) AS Cost,

ROUND(SUM(f.Profit),2) AS Profit,

ROUND(AVG(f.ProfitMargin),2) AS AvgProfitMargin

FROM master_fact_internet_sales f

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY

st.SalesTerritoryGroup,

st.SalesTerritoryCountry,

st.SalesTerritoryRegion

ORDER BY Sales DESC;

-- This query is ideal for building a regional performance dashboard.


## Query 10 – Territory Contribution %

SELECT

st.SalesTerritoryCountry,

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

JOIN DimSalesTerritory st
ON f.SalesTerritoryKey=st.SalesTerritoryKey

GROUP BY st.SalesTerritoryCountry

ORDER BY Sales DESC;

-- This identifies the contribution of each country to total sales.


## Advanced Regional Analysis (Portfolio-Level)
-- These queries will elevate your project beyond a standard assignment.

-- 11. Rank Countries by Sales

SELECT
    st.SalesTerritoryCountry,
    ROUND(SUM(f.SalesAmount),2) AS Sales,
    DENSE_RANK() OVER (ORDER BY SUM(f.SalesAmount) DESC) AS CountryRank
FROM master_fact_internet_sales f
JOIN DimSalesTerritory st
ON f.SalesTerritoryKey = st.SalesTerritoryKey
GROUP BY st.SalesTerritoryCountry;