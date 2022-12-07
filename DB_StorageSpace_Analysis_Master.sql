/*
Run on master DB to collect DB space usage
*/
DECLARE @DB VARCHAR(50),@Total bigint  
SET @Total = (SELECT DISTINCT elastic_pool_storage_limit_mb FROM [sys].[elastic_pool_resource_stats])
DECLARE @TBL TABLE (
database_name VARCHAR(50),
allocated_storage_in_megabytes INT,
storage_USED_in_megabytes INT,
PercentStorageUsageInElasticPool FLOAT,
DatabaseDataSpaceAllocatedUnusedInMB INT,
PercentageFreeSpace FLOAT
)
DECLARE Database_Storage_Usage_Cursor CURSOR
FOR
SELECT DISTINCT database_name FROM sys.resource_stats

OPEN Database_Storage_Usage_Cursor

FETCH NEXT FROM Database_Storage_Usage_Cursor INTO @DB

WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @TBL
SELECT TOP (1) database_name,allocated_storage_in_megabytes,storage_in_megabytes,
(allocated_storage_in_megabytes/@Total)*100'PercentStorageUsageInElasticPool',
(allocated_storage_in_megabytes-storage_in_megabytes)'DatabaseDataSpaceAllocatedUnusedInMB',
((allocated_storage_in_megabytes-storage_in_megabytes)/allocated_storage_in_megabytes)*100 'PercentageFreeSpace'
FROM sys.resource_stats
WHERE database_name = @DB
ORDER BY end_time DESC

FETCH NEXT FROM Database_Storage_Usage_Cursor INTO @DB
END
CLOSE Database_Storage_Usage_Cursor
DEALLOCATE Database_Storage_Usage_Cursor
SELECT * FROM @TBL ORDER BY allocated_storage_in_megabytes desc
--SELECT end_time,sku, database_name,allocated_storage_in_megabytes,storage_in_megabytes,
--(allocated_storage_in_megabytes-storage_in_megabytes)'DatabaseDataSpaceAllocatedUnusedInMB',
--((allocated_storage_in_megabytes-storage_in_megabytes)/allocated_storage_in_megabytes)*100 'PercentageFreeSpace'
--FROM sys.resource_stats



