declare @tablename varchar(400),@nextpartitionboundarytodelete sysname
declare @truncatetable nvarchar(200), @partitionnumber varchar(2), @tableschema nvarchar(20)
set @tablename = 'TransactionHistoryOke'
set @tableschema = 'Production'
;with cte_tablepartitioninfo
as
(
SELECT 
    t.name AS [Table], 
    i.name AS [Index], 
    --convert(tinyint,p.partition_number) as partition_number,
	p.partition_number,
    f.name,
    r.boundary_id, 
    convert(date,r.value) AS [Boundary_Value] ,
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
--ORDER BY p.partition_number ASC;
)
select top 1 @nextpartitionboundarytodelete =  Boundary_Value, @partitionnumber = partition_number  from cte_tablepartitioninfo where rows <> 0 order by partition_number 
select @nextpartitionboundarytodelete,@partitionnumber

if @nextpartitionboundarytodelete is not null
begin
set @truncatetable = 'truncate table ' +@tableschema+'.' +@tablename + ' with (partitions ('+@partitionnumber+'))'
print (@truncatetable)
execute sp_executesql @truncatetable

alter partition function PF_TransactionHistory()
merge range(@nextpartitionboundarytodelete)
end 
--ALTER PARTITION FUNCTION PF_TransactionHistory ()  
--SPLIT RANGE ('2013-12-31 00:00:00.000'); 
