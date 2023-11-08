--WITH
--  L0   AS (SELECT 1 AS n UNION ALL SELECT 1),              -- 2 rows
--  L1   AS (SELECT 1 AS n FROM L0 AS a CROSS JOIN L0 AS b), -- 4 rows (2 x 2)
--  L2   AS (SELECT 1 AS n FROM L1 AS a CROSS JOIN L1 AS b), -- 16 rows (4 x 4)
--  L3   AS (SELECT 1 AS n FROM L2 AS a CROSS JOIN L2 AS b), -- 256 rows (16 x 16)
--  L4   AS (SELECT 1 AS n FROM L3 AS a CROSS JOIN L3 AS b), -- 65 536 rows (256 x 256)
--  L5   AS (SELECT 1 AS n FROM L4 AS a CROSS JOIN L4 AS b), -- 4 294 967 296 rows (65 536 x 65 536)
--  Nums AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM L5)
--SELECT TOP (1000) n FROM Nums ORDER BY n;

--IF OBJECT_ID('dbo.Numbers') IS NOT NULL
--  DROP TABLE dbo.Numbers;
--GO

--CREATE TABLE Numbers (
--    n BIGINT NOT NULL,
--    CONSTRAINT PK_Numbers PRIMARY KEY CLUSTERED (n) WITH FILLFACTOR = 100
--);
--GO

--WITH
--  L0   AS (SELECT 1 AS n UNION ALL SELECT 1),
--  L1   AS (SELECT 1 AS n FROM L0 AS a CROSS JOIN L0 AS b),
--  L2   AS (SELECT 1 AS n FROM L1 AS a CROSS JOIN L1 AS b),
--  L3   AS (SELECT 1 AS n FROM L2 AS a CROSS JOIN L2 AS b),
--  L4   AS (SELECT 1 AS n FROM L3 AS a CROSS JOIN L3 AS b),
--  L5   AS (SELECT 1 AS n FROM L4 AS a CROSS JOIN L4 AS b),
--  Nums AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM L5)
--INSERT INTO dbo.Numbers (n)
--SELECT TOP (100000) n FROM Nums ORDER BY n; /* Insert as many numbers as you need */
--GO

--SELECT n FROM dbo.Numbers WHERE n <= 1000;
--GO

IF OBJECT_ID('dbo.GetNums') IS NOT NULL
  DROP FUNCTION dbo.GetNums;
GO
 
CREATE FUNCTION dbo.GetNums(@n AS BIGINT) RETURNS TABLE AS RETURN
  WITH
  L0   AS (SELECT 1 AS n UNION ALL SELECT 1),
  L1   AS (SELECT 1 AS n FROM L0 AS a CROSS JOIN L0 AS b),
  L2   AS (SELECT 1 AS n FROM L1 AS a CROSS JOIN L1 AS b),
  L3   AS (SELECT 1 AS n FROM L2 AS a CROSS JOIN L2 AS b),
  L4   AS (SELECT 1 AS n FROM L3 AS a CROSS JOIN L3 AS b),
  L5   AS (SELECT 1 AS n FROM L4 AS a CROSS JOIN L4 AS b),
  Nums AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM L5)
  SELECT TOP (@n) n FROM Nums ORDER BY n;
GO

SELECT n FROM dbo.GetNums(1000);
GO


-- Drop objects if they already exist
--IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesSource')
--  DROP TABLE SalesSource;
--IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesTarget')
--  DROP TABLE SalesTarget;
--IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = N'psSales')
--  DROP PARTITION SCHEME psSales;
--IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = N'pfSales')
--  DROP PARTITION FUNCTION pfSales;

--CREATE PARTITION FUNCTION pfSales (DATE)
--AS RANGE RIGHT FOR VALUES 
--('2022-01-01', '2023-01-01', '2024-01-01');
 
---- Create the Partition Scheme
--CREATE PARTITION SCHEME psSales
--AS PARTITION pfSales 
--ALL TO ([Primary]);

---- Create the Non-Partitioned Source Table (Heap) on the [PRIMARY] filegroup
--CREATE TABLE SalesSource (
--  SalesDate DATE,
--  Quantity INT
--) ON [PRIMARY];

-- Insert test data
--INSERT INTO SalesSource(SalesDate, Quantity)
--SELECT DATEADD(DAY,dates.n-1,'2021-01-01') AS SalesDate, qty.n AS Quantity
--FROM GetNums(DATEDIFF(DD,'2021-01-01','2022-01-01')) dates
--CROSS JOIN GetNums(1000) AS qty;

---- Create the Partitioned Target Table (Heap) on the Partition Scheme
--CREATE TABLE SalesTarget (
--  SalesDate DATE,
--  Quantity INT
--) ON psSales(SalesDate);

---- Insert test data
INSERT INTO SalesTarget(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2022-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2016-01-01','2022-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;

-- Verify row count before switch
SELECT COUNT(*) FROM SalesSource; -- 365000 rows
SELECT 
    pstats.partition_number AS PartitionNumber
    ,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesTarget')
ORDER BY PartitionNumber; -- 0 rows in Partition 1, 365000 rows in Partitions 2-4

--SET STATISTICS TIME ON;

---- Is it really that fast...?
--ALTER TABLE SalesSource SWITCH TO SalesTarget PARTITION 1;

--select max(salesdate),min(salesdate) from SalesSource
select * from  SalesSource

-- Add constraints to the source table to ensure it only contains data with values 
-- that are allowed in partition 1 on the target table
-- Add constraints to the source table to ensure it only contains data with values 
-- that are allowed in partition 1 on the target table
--ALTER TABLE SalesSource
--WITH CHECK ADD CONSTRAINT ckMinSalesDate 
--CHECK (SalesDate IS NOT NULL AND SalesDate >= '2021-01-01');

--ALTER TABLE SalesSource
--WITH CHECK ADD CONSTRAINT ckMaxSalesDate 
--CHECK (SalesDate IS NOT NULL AND SalesDate < '2022-01-01');

-- Verify row count after switch
SELECT COUNT(*) FROM SalesSource; -- 0 rows
SELECT 
    pstats.partition_number AS PartitionNumber
    ,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesTarget')
ORDER BY PartitionNumber; 