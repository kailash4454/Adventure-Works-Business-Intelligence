
-- Adventureworks import · SQL
-- ============================================================
-- AdventureWorks CSV Import Script for MySQL Workbench
-- Fixes applied:
--   - Handles UTF-8 BOM on first column of every file
--   - Handles Windows line endings (\r\n)
--   - Converts blank/space-only values to NULL in numeric columns
--   - Loads Excel serial-number dates as INT (convert later if needed)
-- ============================================================

 SELECT VERSION();
 
 SHOW GLOBAL VARIABLES LIKE 'local_infile';
 
-- If not already set for this session, uncomment:
-- SET GLOBAL local_infile = 1;
 
CREATE DATABASE IF NOT EXISTS Adventure_Works;
USE Adventure_Works;
 
-- ============================================================
-- 1. DimProductCategory
-- ============================================================
DROP TABLE IF EXISTS DimProductCategory;
CREATE TABLE DimProductCategory (
    ProductCategoryKey INT PRIMARY KEY,
    ProductCategoryAlternateKey INT,
    EnglishProductCategoryName VARCHAR(50),
    SpanishProductCategoryName VARCHAR(50),
    FrenchProductCategoryName VARCHAR(50)
);

 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/DimProductCategory.csv'
INTO TABLE DimProductCategory
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
ProductCategoryKey,
ProductCategoryAlternateKey,
EnglishProductCategoryName,
SpanishProductCategoryName,
FrenchProductCategoryName
);
 
 SELECT * FROM  DimProductCategory;
 
-- ============================================================
-- 2. DimProductSubCategory
-- ============================================================
DROP TABLE IF EXISTS DimProductSubCategory;
CREATE TABLE DimProductSubCategory (
    ProductSubcategoryKey INT PRIMARY KEY,
    ProductSubcategoryAlternateKey INT,
    EnglishProductSubcategoryName VARCHAR(50),
    SpanishProductSubcategoryName VARCHAR(50),
    FrenchProductSubcategoryName VARCHAR(50),
    ProductCategoryKey INT
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/DimProductSubCategory.csv'
INTO TABLE DimProductSubCategory
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductSubcategoryKey, ProductSubcategoryAlternateKey, EnglishProductSubcategoryName,
 SpanishProductSubcategoryName, FrenchProductSubcategoryName, ProductCategoryKey);
 
 SELECT * FROM  DimProductSubCategory;
 
-- ============================================================
-- 3. DimSalesTerritory
-- ============================================================
DROP TABLE IF EXISTS DimSalesTerritory;
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT PRIMARY KEY,
    SalesTerritoryAlternateKey INT,
    SalesTerritoryRegion VARCHAR(50),
    SalesTerritoryCountry VARCHAR(50),
    SalesTerritoryGroup VARCHAR(50)
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/DimSalesterritory.csv'
INTO TABLE DimSalesTerritory
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(SalesTerritoryKey, SalesTerritoryAlternateKey, SalesTerritoryRegion,
 SalesTerritoryCountry, SalesTerritoryGroup);
 
 SELECT * FROM  DimSalesTerritory;
 
-- ============================================================
-- 4. DimCustomer
-- ============================================================
DROP TABLE IF EXISTS DimCustomer;
CREATE TABLE DimCustomer (
    CustomerKey INT PRIMARY KEY,
    GeographyKey INT,
    CustomerAlternateKey VARCHAR(20),
    Title VARCHAR(10),
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    NameStyle VARCHAR(10),
    BirthDate INT,              -- Excel serial number; convert later if needed
    MaritalStatus VARCHAR(5),
    Suffix VARCHAR(10),
    Gender VARCHAR(5),
    EmailAddress VARCHAR(100),
    YearlyIncome DECIMAL(12,2),
    TotalChildren INT,
    NumberChildrenAtHome INT,
    EnglishEducation VARCHAR(50),
    SpanishEducation VARCHAR(50),
    FrenchEducation VARCHAR(50),
    EnglishOccupation VARCHAR(50),
    SpanishOccupation VARCHAR(50),
    FrenchOccupation VARCHAR(50),
    HouseOwnerFlag VARCHAR(5),
    NumberCarsOwned INT,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    Phone VARCHAR(30),
    DateFirstPurchase INT,      -- Excel serial number; convert later if needed
    CommuteDistance VARCHAR(20)
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/Dimcustomer.csv'
INTO TABLE DimCustomer
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(CustomerKey, GeographyKey, CustomerAlternateKey, Title, FirstName, MiddleName,
 LastName, NameStyle, @BirthDate, MaritalStatus, Suffix, Gender, EmailAddress,
 @YearlyIncome, @TotalChildren, @NumberChildrenAtHome, EnglishEducation,
 SpanishEducation, FrenchEducation, EnglishOccupation, SpanishOccupation,
 FrenchOccupation, HouseOwnerFlag, @NumberCarsOwned, AddressLine1, AddressLine2,
 Phone, @DateFirstPurchase, CommuteDistance)
SET
 BirthDate = NULLIF(TRIM(@BirthDate), ''),
 YearlyIncome = NULLIF(TRIM(@YearlyIncome), ''),
 TotalChildren = NULLIF(TRIM(@TotalChildren), ''),
 NumberChildrenAtHome = NULLIF(TRIM(@NumberChildrenAtHome), ''),
 NumberCarsOwned = NULLIF(TRIM(@NumberCarsOwned), ''),
 DateFirstPurchase = NULLIF(TRIM(@DateFirstPurchase), '');
 
 SELECT * FROM  DimCustomer;
 
-- ============================================================
-- 5. DimProduct  (has blank/space-only numeric values -- this is
--    the file most likely to have silently failed before)
-- ============================================================
DROP TABLE IF EXISTS DimProduct;
CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    UnitPrice DECIMAL(10,4) NULL,
    ProductAlternateKey VARCHAR(20),
    ProductSubcategoryKey INT NULL,
    WeightUnitMeasureCode VARCHAR(10),
    SizeUnitMeasureCode VARCHAR(10),
    EnglishProductName VARCHAR(100),
    SpanishProductName VARCHAR(100),
    FrenchProductName VARCHAR(100),
    StandardCost DECIMAL(10,4) NULL,
    FinishedGoodsFlag VARCHAR(10),
    Color VARCHAR(20),
    SafetyStockLevel INT NULL,
    ReorderPoint INT NULL,
    ListPrice DECIMAL(10,4) NULL,
    Size VARCHAR(20),
    SizeRange VARCHAR(20),
    Weight DECIMAL(10,2) NULL,
    DaysToManufacture INT NULL,
    ProductLine VARCHAR(10),
    DealerPrice DECIMAL(10,4) NULL,
    Class VARCHAR(10),
    Style VARCHAR(10),
    ModelName VARCHAR(100),
    EnglishDescription VARCHAR(500),
    FrenchDescription VARCHAR(500),
    ChineseDescription VARCHAR(500),
    ArabicDescription VARCHAR(500),
    HebrewDescription VARCHAR(500),
    ThaiDescription VARCHAR(500),
    GermanDescription VARCHAR(500),
    JapaneseDescription VARCHAR(500),
    TurkishDescription VARCHAR(500),
    StartDate INT NULL,
    EndDate INT NULL,
    Status VARCHAR(20)
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/DimProduct.csv'
INTO TABLE DimProduct
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductKey, @UnitPrice, ProductAlternateKey, @ProductSubcategoryKey,
 WeightUnitMeasureCode, SizeUnitMeasureCode, EnglishProductName,
 SpanishProductName, FrenchProductName, @StandardCost, FinishedGoodsFlag,
 Color, @SafetyStockLevel, @ReorderPoint, @ListPrice, Size, SizeRange,
 @Weight, @DaysToManufacture, ProductLine, @DealerPrice, Class, Style,
 ModelName, EnglishDescription, FrenchDescription, ChineseDescription,
 ArabicDescription, HebrewDescription, ThaiDescription, GermanDescription,
 JapaneseDescription, TurkishDescription, @StartDate, @EndDate, Status)
SET
 UnitPrice = NULLIF(TRIM(@UnitPrice), ''),
 ProductSubcategoryKey = NULLIF(TRIM(@ProductSubcategoryKey), ''),
 StandardCost = NULLIF(TRIM(@StandardCost), ''),
 SafetyStockLevel = NULLIF(TRIM(@SafetyStockLevel), ''),
 ReorderPoint = NULLIF(TRIM(@ReorderPoint), ''),
 ListPrice = NULLIF(TRIM(@ListPrice), ''),
 Weight = NULLIF(TRIM(@Weight), ''),
 DaysToManufacture = NULLIF(TRIM(@DaysToManufacture), ''),
 DealerPrice = NULLIF(TRIM(@DealerPrice), ''),
 StartDate = NULLIF(TRIM(@StartDate), ''),
 EndDate = NULLIF(TRIM(@EndDate), '');
 
 SELECT * FROM DimProduct;
 
-- ============================================================
-- 6. DimDate
-- ============================================================
DROP TABLE IF EXISTS DimDate;
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDateAlternateKey VARCHAR(20),   -- text format dd-mm-yyyy; convert later if needed
    DayNumberOfWeek INT,
    EnglishDayNameOfWeek VARCHAR(20),
    SpanishDayNameOfWeek VARCHAR(20),
    FrenchDayNameOfWeek VARCHAR(20),
    DayNumberOfMonth INT,
    DayNumberOfYear INT,
    WeekNumberOfYear INT,
    EnglishMonthName VARCHAR(20),
    SpanishMonthName VARCHAR(20),
    FrenchMonthName VARCHAR(20),
    MonthNumberOfYear INT,
    CalendarQuarter INT,
    CalendarYear INT,
    CalendarSemester INT,
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalSemester INT
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/DimDate.csv'
INTO TABLE DimDate
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DateKey, FullDateAlternateKey, DayNumberOfWeek, EnglishDayNameOfWeek,
 SpanishDayNameOfWeek, FrenchDayNameOfWeek, DayNumberOfMonth, DayNumberOfYear,
 WeekNumberOfYear, EnglishMonthName, SpanishMonthName, FrenchMonthName,
 MonthNumberOfYear, CalendarQuarter, CalendarYear, CalendarSemester,
 FiscalQuarter, FiscalYear, FiscalSemester);
 
-- ============================================================
-- 7. FactInternetSales
-- ============================================================
DROP TABLE IF EXISTS FactInternetSales;
CREATE TABLE FactInternetSales (
    ProductKey INT,
    OrderDateKey INT,
    DueDateKey INT,
    ShipDateKey INT,
    CustomerKey INT,
    PromotionKey INT,
    CurrencyKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(20),
    SalesOrderLineNumber INT,
    RevisionNumber INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(10,4),
    ExtendedAmount DECIMAL(10,4),
    UnitPriceDiscountPct DECIMAL(6,4),
    DiscountAmount DECIMAL(10,2),
    ProductStandardCost DECIMAL(10,4),
    TotalProductCost DECIMAL(10,4),
    SalesAmount DECIMAL(10,4),
    TaxAmt DECIMAL(10,4),
    Freight DECIMAL(10,4),
    CarrierTrackingNumber VARCHAR(10),
    CustomerPONumber VARCHAR(10),
    OrderDate INT,
    DueDate INT,
    ShipDate INT
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/FactInternetSales.csv'
INTO TABLE FactInternetSales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductKey, OrderDateKey, DueDateKey, ShipDateKey, CustomerKey, PromotionKey,
 CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber,
 RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct,
 DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt,
 Freight, @CarrierTrackingNumber, @CustomerPONumber, OrderDate, DueDate, ShipDate)
SET
 CarrierTrackingNumber = NULLIF(TRIM(@CarrierTrackingNumber), ''),
 CustomerPONumber = NULLIF(TRIM(@CustomerPONumber), '');
 
-- ============================================================
-- 8. Fact_Internet_Sales_New  (same structure as FactInternetSales)
-- ============================================================
DROP TABLE IF EXISTS Fact_Internet_Sales_New;
CREATE TABLE Fact_Internet_Sales_New (
    ProductKey INT,
    OrderDateKey INT,
    DueDateKey INT,
    ShipDateKey INT,
    CustomerKey INT,
    PromotionKey INT,
    CurrencyKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(20),
    SalesOrderLineNumber INT,
    RevisionNumber INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(10,4),
    ExtendedAmount DECIMAL(10,4),
    UnitPriceDiscountPct DECIMAL(6,4),
    DiscountAmount DECIMAL(10,2),
    ProductStandardCost DECIMAL(10,4),
    TotalProductCost DECIMAL(10,4),
    SalesAmount DECIMAL(10,4),
    TaxAmt DECIMAL(10,4),
    Freight DECIMAL(10,4),
    CarrierTrackingNumber VARCHAR(30),
    CustomerPONumber VARCHAR(30),
    OrderDate INT,
    DueDate INT,
    ShipDate INT
);
 
LOAD DATA LOCAL INFILE 'C:/Users/narpa/Downloads/AdventureWorks Datasets1/AdventureWorks Datasets/Fact_Internet_Sales_New.csv'
INTO TABLE Fact_Internet_Sales_New
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductKey, OrderDateKey, DueDateKey, ShipDateKey, CustomerKey, PromotionKey,
 CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber,
 RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct,
 DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt,
 Freight, @CarrierTrackingNumber, @CustomerPONumber, OrderDate, DueDate, ShipDate)
SET
 CarrierTrackingNumber = NULLIF(TRIM(@CarrierTrackingNumber), ''),
 CustomerPONumber = NULLIF(TRIM(@CustomerPONumber), '');
 
-- ============================================================
-- Quick sanity check after running everything above
-- ============================================================
SELECT 'DimProductCategory' AS TableName, COUNT(*)  FROM DimProductCategory
UNION ALL SELECT 'DimProductSubCategory', COUNT(*) FROM DimProductSubCategory
UNION ALL SELECT 'DimSalesTerritory', COUNT(*) FROM DimSalesTerritory
UNION ALL SELECT 'DimCustomer', COUNT(*) FROM DimCustomer
UNION ALL SELECT 'DimProduct', COUNT(*) FROM DimProduct
UNION ALL SELECT 'DimDate', COUNT(*) FROM DimDate
UNION ALL SELECT 'FactInternetSales', COUNT(*) FROM FactInternetSales
UNION ALL SELECT 'Fact_Internet_Sales_New', COUNT(*) FROM Fact_Internet_Sales_New;

# ----------------------------------------------------------------------------------------------------------------

-- Blended Fact_Internet table
select * from factinternetsales;
select * from fact_internet_sales_new;

describe factinternetsales;
describe fact_internet_sales_new;

SELECT 
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_NAME = 'FactInternetSales') AS Table1Cols,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_NAME = 'Fact_Internet_Sales_New') AS Table2Cols;
 
create table master_fact_internet_sales AS(
select * from FactInternetSales 
UNION ALL
select * from Fact_Internet_Sales_New);

select * from master_fact_internet_sales;

