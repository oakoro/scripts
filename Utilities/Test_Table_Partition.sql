declare @nextPartitionID bigint,@str1 nvarchar(max), @str2 nvarchar(max)
select @nextPartitionID = IDENT_CURRENT('dbo.BPASessionLog_NonUnicode') -- Get last identity number in the table
select top 1 logid as 'Maxlogid' from BPASessionLog_NonUnicode with (nolock) order by logid desc
---Test if partitiopn already exist and create the next partiton
if not exists(
select prv.value
from sys.partition_functions as pf
join sys.partition_range_values as prv on pf.function_id = prv.function_id
where pf.name = 'PF_Dynamic_NU' and prv.value = @nextPartitionID
)
begin
select @nextPartitionID 'nextPartitionID'
set @str1 ='alter partition scheme PS_dynamicPartition next used [primary];'
set @str2 = 'alter partition function PF_dynamicPartition() split range('+convert(nvarchar(20),@nextPartitionID)+');'
select @str1
select @str2
end
ELSE
PRINT 'Partition already exists'


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
WHERE i.type <= 1 AND t.name = 'BPASessionLog_NonUnicode' 
ORDER BY p.partition_number ASC;

