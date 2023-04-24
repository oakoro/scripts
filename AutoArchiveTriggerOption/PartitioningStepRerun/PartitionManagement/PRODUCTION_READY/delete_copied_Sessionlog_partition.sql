/****** Object:  StoredProcedure [BPC].[aasp_delete_copied_Sessionlog_partition]    Script Date: 20/04/2023 16:17:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:      Oke Akoro
-- Description: Delete copied partition in BPASessionLog_NonUnicode table
-- Script execution Example: BPC.aasp_delete_copied_Sessionlog_partition 'ARCH','BPASessionLog_NonUnicodeOATest','PF_dynamicBPASessionLogPartition',2
-- variable description: 
--	@tableschema - Table Schema, @tablename - Partitioned table name, 
--  @partitionfuntion - partition function, @partitionsretained - No of retained partitions
-- =============================================

CREATE PROCEDURE [BPC].[aasp_delete_copied_Sessionlog_partition]
@tableschema NVARCHAR(20), @tablename NVARCHAR(400),@partitionfuntion NVARCHAR(50),@partitionsretained TINYINT

AS

DECLARE @nextpartitionboundarytodelete BIGINT -- Oldest Next partiton boundary to delete
DECLARE @truncatetablestr NVARCHAR(200) -- Partition truncate script
DECLARE @partitionnumber NVARCHAR(5) -- Partition number to delete
DECLARE @lastprocessedlogid BIGINT -- Last logid copied to data lake
DECLARE @partitionboundarycount TINYINT -- Existing table partitions
DECLARE @alterpartationstr NVARCHAR(200) -- Partition delete script

SELECT @lastprocessedlogid = logid FROM [BPC].[adf_watermark_sessionlog] WHERE tablename = @tablename;

SELECT @partitionboundarycount = COUNT(*) FROM sys.partition_range_values r JOIN sys.partition_functions f ON r.function_id = f.function_id
WHERE f.name = @partitionfuntion 

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
SELECT TOP 1 @nextpartitionboundarytodelete =  Boundary_Value, @partitionnumber = partition_number FROM cte_tablepartitioninfo --where rows <> 0 
ORDER BY partition_number 
--SELECT @nextpartitionboundarytodelete'nextpartitionboundarytodelete',@partitionnumber'partitionnumber',@lastprocessedlogid'lastprocessedlogid',@partitionboundarycount'partitionboundarycount'

IF @nextpartitionboundarytodelete IS NOT NULL AND @nextpartitionboundarytodelete < @lastprocessedlogid AND @partitionboundarycount > @partitionsretained
BEGIN
SET @truncatetablestr = 'truncate table ' +@tableschema+'.' +@tablename + ' with (partitions ('+@partitionnumber+'))'
--print (@truncatetablestr)

SET @alterpartationstr = 'alter partition function '+@partitionfuntion+'() merge range('+convert(NVARCHAR(5),@nextpartitionboundarytodelete)+')'
--print (@alterpartationstr)

EXECUTE sp_executesql @truncatetablestr
EXECUTE sp_executesql @alterpartationstr

END 



GO


