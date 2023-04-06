/*
	Name:			CleanupInBatches - BPAWorkQueueItem - Information.sql
	Author:			Blue Prism
	Date:			20220330
	Description:	This script is to be used to give information about how many records and the approximate size of the data that the 
					"CleanupInBatches - BPAWorkQueueItem.sql" script will remove
					It can be used to guage the impact on the transaction log as all the deleted data will be logged here for recovery during the execution of the scripts
	BP Version(s):	This script has been tested against Version 6.4+ of Blue Prism
	Usage:			The "Blue Prism Database Name Here" needs replacing with the name of your Blue Prism database
					The @DaysToKeep variable is to be updated to match the value you are planning to use in the "CleanupInBatches - BPAWorkQueueItem.sql" script

	*** The script is to be tested in lower route to live environments (Development / Test / UAT / SIT) and the results verified before being run against a Production environment ***

	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
*/
-- Set database context
--USE [Blue Prism Database Name Here];
--GO

-- Set transaction isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declare variables
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;
DECLARE @TableName sysname;
DECLARE @TotalRowCount DECIMAL(38, 2);
DECLARE @ToDeleteRowCount DECIMAL(38, 2);
DECLARE @TableSizeInMB DECIMAL(38, 2);

-- Set the variables
SET @DaysToKeep = 14;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);
SET @TableName = 'BPAWorkQueueItem';

-- Get a count of all rows
SELECT @TotalRowCount = SUM(row_count)
FROM sys.dm_db_partition_stats
WHERE [object_id] = OBJECT_ID(@TableName)
      AND index_id  2;

-- Get a count of rows to delete
SELECT @ToDeleteRowCount = COUNT(1)
FROM BPAWorkQueueItem AS i 
LEFT JOIN BPAWorkQueueItem AS inext
    ON i.id = inext.id
       AND inext.attempt = i.attempt + 1
WHERE inext.id IS NULL
      AND i.finished  @threshold;

-- Get Table Size
;WITH cte
AS (
	SELECT t.[name] AS TableName,
		SUM(s.used_page_count) AS used_pages_count,
		SUM(CASE 
				WHEN (i.index_id  2)
					THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
				ELSE lob_used_page_count + row_overflow_used_page_count
				END) AS pages
	FROM sys.dm_db_partition_stats AS s
	INNER JOIN sys.tables AS t ON s.[object_id] = t.[object_id]
	INNER JOIN sys.indexes AS i ON i.[object_id] = t.[object_id]
		AND s.index_id = i.index_id
	WHERE t.[name] = @TableName
	GROUP BY t.[name]
	)
SELECT @TableSizeInMB = CAST((cte.pages * 8.) / 1024 AS DECIMAL(10, 2))
FROM cte;

-- Return Counts and Sizes
SELECT @TableName AS TableName,
	@TableSizeInMB AS TableSizeInMB,
	@TotalRowCount AS TotalRowCount,
	@ToDeleteRowCount AS ToDeleteRowCount,
	CAST((@ToDeleteRowCount / @TotalRowCount) * 100 AS DECIMAL(10, 2)) AS PercentageOfDataToDelete,
	CAST((@TableSizeInMB / 100) * CAST((@ToDeleteRowCount / @TotalRowCount) * 100 AS DECIMAL(10, 2)) AS DECIMAL(10, 2)) AS ApproxSizeOfDataToDeleteInMB;
GO