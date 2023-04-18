-- =============================================
-- Author:      Oke Akoro
-- Create Date: <Create Date, , >
-- Description: Delete copied partition in BPASessionLog_NonUnicode table
-- Script execution Example: BPC.aasp_delete_copied_Sessionlog_partition 'dbo','BPASessionLog_NonUnicode_PartitionTest_NCI','pflogid_test'
-- variable description: @tableschema - Table Schema, @tablename - Partitioned table name, @partitionfuntion - partition function
-- =============================================

create or alter procedure BPC.aasp_delete_copied_Sessionlog_partition
@tableschema nvarchar(20), @tablename nvarchar(400),@partitionfuntion nvarchar(50)

as

declare @nextpartitionboundarytodelete bigint -- Oldest Next partiton boundary to delete
declare @truncatetablestr nvarchar(200) -- Partition truncate script
declare @partitionnumber nvarchar(5) -- Partition number to delete
declare @lastprocessedlogid bigint -- Last logid copied to data lake
declare @partitionboundarycount tinyint -- Existing table partitions
declare @alterpartationstr nvarchar(200) -- Partition delete script

select @lastprocessedlogid = logid from [BPC].[adf_watermark_sessionlog] where tablename = @tablename;

select @partitionboundarycount = count(*) from sys.partition_range_values r join sys.partition_functions f on r.function_id = f.function_id
where f.name = @partitionfuntion 

;with cte_tablepartitioninfo
as
(
SELECT 
     p.partition_number,
     convert(int,r.value) AS [Boundary_Value] ,
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
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE i.type <= 1 AND t.name = @tablename
)
select top 1 @nextpartitionboundarytodelete =  Boundary_Value, @partitionnumber = partition_number  from cte_tablepartitioninfo where rows <> 0 order by partition_number 
--select @nextpartitionboundarytodelete'nextpartitionboundarytodelete',@partitionnumber'partitionnumber',@lastprocessedid'lastprocessedid',@partitionboundarycount'partitionboundarycount'

if @nextpartitionboundarytodelete is not null and @nextpartitionboundarytodelete < @lastprocessedlogid and @partitionboundarycount > 6
begin
set @truncatetablestr = 'truncate table ' +@tableschema+'.' +@tablename + ' with (partitions ('+@partitionnumber+'))'
print (@truncatetablestr)

set @alterpartationstr = 'alter partition function '+@partitionfuntion+'() merge range('+convert(nvarchar(5),@nextpartitionboundarytodelete)+')'
print (@alterpartationstr)

--execute sp_executesql @truncatetablestr
--execute sp_executesql @alterpartationstr

end 



