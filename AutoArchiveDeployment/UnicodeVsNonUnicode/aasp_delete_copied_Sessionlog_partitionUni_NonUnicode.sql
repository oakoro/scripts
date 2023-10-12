/****** Object:  StoredProcedure [BPC].[aasp_delete_copied_Sessionlog_partition]    Script Date: 11/10/2023 14:19:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Description: Delete copied partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_delete_copied_Sessionlog_partitionUni_NonUnicode] @partitionsretained = 1
-- variable description: 
--	@tableschema - Table Schema, @sessionlogtable - Partitioned table name, 
--  @partitionfunction - partition function, @partitionsretained - No of retained partitions
-- Automate for unicode and non-unicode
-- =============================================

ALTER PROCEDURE [BPC].[aasp_delete_copied_Sessionlog_partitionUni_NonUnicode] 
 @partitionsretained TINYINT

AS

DECLARE @nextpartitionboundarytodelete BIGINT -- Oldest Next partiton boundary to delete
DECLARE @truncatetablestr NVARCHAR(200) -- Partition truncate script
DECLARE @partitionnumber NVARCHAR(5) -- Partition number to delete
DECLARE @lastprocessedlogid BIGINT -- Last logid copied to data lake
DECLARE @partitionboundarycount TINYINT -- Existing table partitions
DECLARE @alterpartationstr NVARCHAR(200) -- Partition delete script
DECLARE @LoggingType BIT -- Session log table type
DECLARE @sessionlogtable NVARCHAR(50) -- Session log table name
DECLARE @partitionfunction NVARCHAR(50) -- Partition Function
DECLARE @tableschema NVARCHAR(20) = 'DBO' -- Table schema
 

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	SET @LoggingType = 1
	IF @LoggingType = 0
	BEGIN
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	SET @partitionfunction = 'PF_Dynamic_NU_New'
	END
	ELSE 
	BEGIN
	SET @sessionlogtable = 'BPASessionLog_UnicodeTest1'
	SET @partitionfunction = 'PF_Dynamic_NUTest'
	END



SELECT @lastprocessedlogid = logid FROM [BPC].[adf_watermark] WHERE tablename = @sessionlogtable;

SELECT @partitionboundarycount = COUNT(*) FROM sys.partition_range_values r JOIN sys.partition_functions f ON r.function_id = f.function_id
WHERE f.name = @partitionfunction 

;WITH cte_tablepartitioninfo
AS
(
SELECT 
     p.partition_number,
     CONVERT(BIGINT,r.value) AS [Boundary_Value] ,
	p.rows
	FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id AND r.boundary_id = p.partition_number  
WHERE i.type <= 1 AND SCHEMA_NAME(t.schema_id) = @tableschema AND t.name = @sessionlogtable 
)
SELECT TOP 1 @nextpartitionboundarytodelete =  Boundary_Value, @partitionnumber = partition_number FROM cte_tablepartitioninfo 
ORDER BY partition_number 


IF @nextpartitionboundarytodelete IS NOT NULL AND @lastprocessedlogid >= @nextpartitionboundarytodelete AND @partitionboundarycount > @partitionsretained
BEGIN
SET @truncatetablestr = 'TRUNCATE TABLE ' +@tableschema+'.' +@sessionlogtable + ' WITH (PARTITIONS ('+@partitionnumber+'))'


SET @alterpartationstr = 'ALTER PARTITION FUNCTION '+@partitionfunction+'() MERGE RANGE('+CONVERT(NVARCHAR(50),@nextpartitionboundarytodelete)+')'

--EXECUTE sp_executesql @truncatetablestr
--EXECUTE sp_executesql @alterpartationstr
PRINT @truncatetablestr
PRINT @alterpartationstr


END
GO


