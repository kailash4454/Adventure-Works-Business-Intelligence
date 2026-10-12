## Phase 2 – Data Preparation

USE adventure_works;

-- Step 1 – Backup
-- Always create a backup before altering a production table.

CREATE TABLE master_fact_backup AS
SELECT *
FROM master_fact_internet_sales;

-- Step 2 – Convert Integer Dates to Proper DATE
-- 2.1 Add new DATE columns

ALTER TABLE master_fact_internet_sales
ADD COLUMN Order_Date DATE,
ADD COLUMN Due_Date DATE,
ADD COLUMN Ship_Date DATE;

-- 2.2 Populate the DATE columns
-- If your integer values are in the format 20131231:

SET SQL_SAFE_UPDATES = 0;

UPDATE master_fact_internet_sales
SET
    Order_Date = DATE_ADD('1899-12-30', INTERVAL OrderDate DAY),
    Due_Date   = DATE_ADD('1899-12-30', INTERVAL DueDate DAY),
    Ship_Date  = DATE_ADD('1899-12-30', INTERVAL ShipDate DAY);

SET SQL_SAFE_UPDATES = 1;

-- Verify the conversion

SELECT
    OrderDate,
    Order_Date,
    DueDate,
    Due_Date,
    ShipDate,
    Ship_Date
FROM master_fact_internet_sales
LIMIT 10;

## Profit Column

ALTER TABLE master_fact_internet_sales
ADD COLUMN Profit DECIMAL(12,2);

UPDATE master_fact_internet_sales
SET Profit = SalesAmount-TotalProductCost;

SELECT Profit from master_fact_internet_sales;

## Profit Margin %

ALTER TABLE master_fact_internet_sales
ADD COLUMN ProfitMargin DECIMAL(8,2);

UPDATE master_fact_internet_sales
SET ProfitMargin =
ROUND(
(Profit/SalesAmount)*100,
2
);

## Order Processing Days

ALTER TABLE master_fact_internet_sales
ADD COLUMN ShippingDays INT;

UPDATE master_fact_internet_sales
SET ShippingDays =
DATEDIFF(Ship_Date,Order_Date);

-- Validation

SELECT
MIN(Order_Date),
MAX(Order_Date)
FROM master_fact_internet_sales;