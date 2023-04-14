SELECT 
    t.name AS [Table], 
    i.name AS [Index], 
    p.partition_number,
    f.name,
    r.boundary_id, 
    r.value AS [Boundary Value] ,
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
WHERE i.type = 1 AND t.name = 'sessionlog_partitioned' 
ORDER BY p.partition_number ASC;

--alter partition function sessionlog_partition_function1() split range (1400)
   --ALTER PARTITION SCHEME [sessionlog_partition_scheme2] NEXT USED [PRIMARY];


   --    ON s.function_id = f.function_id  
--LEFT JOIN sys.partition_range_values AS r   
--    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
--WHERE i.type <= 1 AND t.name = @tablename
--declare @partition_fn nvarchar(100), @partitionboundarycount tinyint, @lastprocessedid int
--declare @tablename varchar(20)
--set @tablename = 'sessionlog_partitioned'

--set @partition_fn = 'sessionlog_partition_function1'
--select * from sys.partition_range_values r join sys.partition_functions f on r.function_id = f.function_id 
--where f.name = @partition_fn 
--select @partitionboundarycount = count(*) from sys.partition_range_values r join sys.partition_functions f on r.function_id = f.function_id
--where f.name = @partition_fn 
--if @partitionboundarycount < 7
--begin
--select lastprocessedid from sessionlog_watermark where tablename = 'sessionlog_partitioned'
--end
--select * from sys.partition_functions where name = @partition_fn
--select @partitionboundarycount

--select * from sessionlog_partitioned where id < 200

--create table sessionlog_watermark(tablename varchar(50), deltacolumn varchar(50), lastprocessedid int)

--insert sessionlog_watermark
--values ('sessionlog_partitioned','id',200)

