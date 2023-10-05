/****** Create [BPC].[aasp_delete_copied_Sessionlog_partition] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[aasp_delete_copied_Sessionlog_partition]',N'P')) IS NULL
BEGIN
DECLARE @aasp_delete_copied_Sessionlog_partition NVARCHAR(MAX) = '

-- =============================================
-- Description: Delete copied partition in BPASessionLog_NonUnicode table
-- Script execution Example: BPC.aasp_delete_copied_Sessionlog_partition ''dbo'',''BPASessionLog_NonUnicode'',''PF_Dynamic_NU'',2
-- variable description: 
--	@tableschema - Table Schema, @tablename - Partitioned table name, 
--  @partitionfunction - partition function, @partitionsretained - No of retained partitions
-- =============================================

CREATE PROCEDURE [BPC].[aasp_delete_copied_Sessionlog_partition]
@tableschema NVARCHAR(20), @tablename NVARCHAR(400),@partitionfunction NVARCHAR(50),@partitionsretained TINYINT

AS

DECLARE @nextpartitionboundarytodelete BIGINT -- Oldest Next partiton boundary to delete
DECLARE @truncatetablestr NVARCHAR(200) -- Partition truncate script
DECLARE @partitionnumber NVARCHAR(5) -- Partition number to delete
DECLARE @lastprocessedlogid BIGINT -- Last logid copied to data lake
DECLARE @partitionboundarycount TINYINT -- Existing table partitions
DECLARE @alterpartationstr NVARCHAR(200) -- Partition delete script

SELECT @lastprocessedlogid = logid FROM [BPC].[adf_watermark] WHERE tablename = @tablename;

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
WHERE i.type <= 1 AND SCHEMA_NAME(t.schema_id) = @tableschema AND t.name = @tablename 
)
SELECT TOP 1 @nextpartitionboundarytodelete =  Boundary_Value, @partitionnumber = partition_number FROM cte_tablepartitioninfo 
ORDER BY partition_number 


IF @nextpartitionboundarytodelete IS NOT NULL AND @lastprocessedlogid >= @nextpartitionboundarytodelete AND @partitionboundarycount > @partitionsretained
BEGIN
SET @truncatetablestr = ''truncate table '' +@tableschema+''.'' +@tablename + '' with (partitions (''+@partitionnumber+''))''


SET @alterpartationstr = ''alter partition function ''+@partitionfunction+''() merge range(''+convert(NVARCHAR(5),@nextpartitionboundarytodelete)+'')''


EXECUTE sp_executesql @truncatetablestr
EXECUTE sp_executesql @alterpartationstr

END' 

EXECUTE SP_EXECUTESQL @aasp_delete_copied_Sessionlog_partition
END


