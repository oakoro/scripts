/****** Object:  StoredProcedure [BPC].[aasp_create_new_partition_BPASessionlog_master]    Script Date: 11/17/2023 4:17:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Description: Master stored procedure that calls one of the aasp_create_new_<BPASessionLog Tablename>_partition SPs
-- Checks for: 
--		NULL Data in table
--		If one of the BPASessionLog tables are already partitioned
--		Which BPASessionLog table has been designated in use by the BP Application
-- Script execution Example: EXECUTE BPC.aasp_create_new_partition_BPASessionlog_master
-- =============================================
CREATE PROCEDURE [BPC].[aasp_create_new_partition_BPASessionlog_master]

AS
BEGIN

/*** Test If sessionlog table is partitioned and either partition the table based upon the unicodelogging data in the BPASysConfig table or end if the table is already partitioned ***/
IF (SELECT TOP (1) ps.name AS [Partition Scheme] FROM sys.tables t INNER JOIN sys.indexes i ON t.object_id = i.object_id AND i.type IN (0,1) INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')) IS NULL AND 
(SELECT SUM(p.Rows) AS [Row Count] FROM sys.objects AS o WITH (NOLOCK) INNER JOIN sys.partitions AS p WITH (NOLOCK) ON p.object_id = o.object_id INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK) ON p.object_id = ps.object_id
WHERE ps.index_id < 2  AND p.index_id < 2 AND o.type_desc = N'USER_TABLE' and OBJECT_NAME(p.object_id) like 'BPASessionLog_NonUnicode' GROUP BY OBJECT_NAME(p.object_id)) > 2 AND (SELECT unicodeLogging FROM BPASysConfig) = 0

BEGIN

EXECUTE [BPC].[aasp_create_new_NonUnicode_partition]

END

ELSE IF (SELECT TOP (1) ps.name AS [Partition Scheme] FROM sys.tables t INNER JOIN sys.indexes i ON t.object_id = i.object_id AND i.type IN (0,1) INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')) IS NULL AND 
(SELECT SUM(p.Rows) AS [Row Count] FROM sys.objects AS o WITH (NOLOCK) INNER JOIN sys.partitions AS p WITH (NOLOCK) ON p.object_id = o.object_id INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK) ON p.object_id = ps.object_id
WHERE ps.index_id < 2  AND p.index_id < 2 AND o.type_desc = N'USER_TABLE' and OBJECT_NAME(p.object_id) like 'BPASessionLog_Unicode' GROUP BY OBJECT_NAME(p.object_id)) > 2 AND (SELECT unicodeLogging FROM BPASysConfig) = 1

BEGIN

EXECUTE [BPC].[aasp_create_new_Unicode_partition]

END
  
ELSE IF  (SELECT TOP (1) ps.name AS [Partition Scheme] FROM sys.tables t INNER JOIN sys.indexes i ON t.object_id = i.object_id AND i.type IN (0,1) INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')) IS NOT NULL
BEGIN
SELECT 'Already Partitioned' as Results;
END

ELSE IF (SELECT SUM(p.Rows) AS [Row Count] FROM sys.objects AS o WITH (NOLOCK) INNER JOIN sys.partitions AS p WITH (NOLOCK) ON p.object_id = o.object_id INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK) ON p.object_id = ps.object_id
WHERE ps.index_id < 2  AND p.index_id < 2 AND o.type_desc = N'USER_TABLE' and OBJECT_NAME(p.object_id) = 'BPASessionLog_NonUnicode' GROUP BY OBJECT_NAME(p.object_id)) < 3  AND (SELECT unicodeLogging FROM BPASysConfig) = 0

BEGIN
SELECT 'Not Enough Data in the BPASessionLog_NonUnicode Table to Partition' as Results;
END

ELSE IF (SELECT SUM(p.Rows) AS [Row Count] FROM sys.objects AS o WITH (NOLOCK) INNER JOIN sys.partitions AS p WITH (NOLOCK) ON p.object_id = o.object_id INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK) ON p.object_id = ps.object_id
WHERE ps.index_id < 2  AND p.index_id < 2 AND o.type_desc = N'USER_TABLE' and OBJECT_NAME(p.object_id) = 'BPASessionLog_Unicode' GROUP BY OBJECT_NAME(p.object_id)) < 3 AND (SELECT unicodeLogging FROM BPASysConfig) = 1

BEGIN
SELECT 'Not Enough Data in the BPASessionLog_Unicode Table to Partition' as Results;
END

END
GO

