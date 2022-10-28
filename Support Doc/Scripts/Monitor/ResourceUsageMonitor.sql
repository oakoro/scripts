/*
Collection of database resource usage
*/
IF OBJECT_ID('DBA_dm_db_resource_stats_Hist') IS NULL
BEGIN
select * INTO DBA_dm_db_resource_stats_Hist
FROM [sys].[dm_db_resource_stats]
ORDER BY end_time DESC;
END
ELSE
BEGIN
INSERT DBA_dm_db_resource_stats_Hist
SELECT * FROM [sys].[dm_db_resource_stats]
WHERE end_time NOT IN (SELECT DISTINCT end_time FROM DBA_dm_db_resource_stats_Hist)
END
WAITFOR DELAY '00:00:15' -- Adjust as applicable
GO 1920 -- Adjust as applicable


