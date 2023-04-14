declare @tablename varchar(400),@nextpartitionboundarytodelete int,@partitionfuntion nvarchar(50)
declare @truncatetablestr nvarchar(200), @partitionnumber varchar(2), @tableschema nvarchar(20)
declare @lastprocessedid int, @partitionboundarycount tinyint, @alterpartationstr nvarchar(200)
set @tablename = 'sessionlog_partitioned'
set @tableschema = 'dbo'
set @partitionfuntion = 'sessionlog_partition_function1'

select @lastprocessedid = lastprocessedid from sessionlog_watermark where tablename = @tablename;
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
select @nextpartitionboundarytodelete'nextpartitionboundarytodelete',@partitionnumber'partitionnumber',@lastprocessedid'lastprocessedid',@partitionboundarycount'partitionboundarycount'

if @nextpartitionboundarytodelete is not null and @nextpartitionboundarytodelete < @lastprocessedid and @partitionboundarycount > 5
begin
set @truncatetablestr = 'truncate table ' +@tableschema+'.' +@tablename + ' with (partitions ('+@partitionnumber+'))'
print (@truncatetablestr)

set @alterpartationstr = 'alter partition function '+@partitionfuntion+'() merge range('+convert(nvarchar(5),@nextpartitionboundarytodelete)+')'
print (@alterpartationstr)

execute sp_executesql @truncatetablestr
execute sp_executesql @alterpartationstr

end 
--ALTER PARTITION FUNCTION PF_TransactionHistory ()  
--SPLIT RANGE ('2013-12-31 00:00:00.000'); 
