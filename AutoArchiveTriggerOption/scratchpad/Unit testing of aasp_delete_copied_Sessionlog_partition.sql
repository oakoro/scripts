/** Unit testing of aasp_delete_copied_Sessionlog_partition **/

DECLARE @nextpartitionboundarytodelete BIGINT -- Oldest Next partiton boundary to delete
DECLARE @truncatetablestr NVARCHAR(200) -- Partition truncate script
DECLARE @partitionnumber NVARCHAR(5) -- Partition number to delete
DECLARE @lastprocessedlogid BIGINT -- Last logid copied to data lake
DECLARE @partitionboundarycount TINYINT -- Existing table partitions
DECLARE @alterpartationstr NVARCHAR(200), -- Partition delete script
@tableschema NVARCHAR(20), @tablename NVARCHAR(400),@partitionfuntion NVARCHAR(50),@partitionsretained TINYINT

set @tablename = 'BPASessionLog_NonUnicode'
set @tableschema = 'dbo'
set @partitionsretained = 5
set @partitionfuntion = 'PF_Dynamic_NU'

SELECT @lastprocessedlogid = 
logid FROM [BPC].[adf_watermark_sessionlog]

SELECT @partitionboundarycount = COUNT(*) FROM sys.partition_range_values r JOIN sys.partition_functions f ON r.function_id = f.function_id
WHERE f.name = @partitionfuntion 

;
WITH cte_tablepartitioninfo
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


select @lastprocessedlogid'@lastprocessedlogid', @nextpartitionboundarytodelete '@nextpartitionboundarytodelete', 
@partitionnumber '@partitionnumber',@partitionsretained'@partitionsretained',
@partitionboundarycount'@partitionboundarycount'
IF @nextpartitionboundarytodelete IS NOT NULL AND @lastprocessedlogid >= @nextpartitionboundarytodelete  AND @partitionboundarycount > @partitionsretained
BEGIN
select 'purge'
SET @truncatetablestr = 'truncate table ' +@tableschema+'.' +@tablename + ' with (partitions ('+@partitionnumber+'))'
print (@truncatetablestr)

SET @alterpartationstr = 'alter partition function '+@partitionfuntion+'() merge range('+convert(NVARCHAR(5),@nextpartitionboundarytodelete)+')'
print (@alterpartationstr)
END

/*
select * FROM [BPC].[adf_watermark_sessionlog] --Original logid = 260
update  [BPC].[adf_watermark_sessionlog]
set logid = 310
where tablename = 'BPASessionLog_NonUnicode'

*/