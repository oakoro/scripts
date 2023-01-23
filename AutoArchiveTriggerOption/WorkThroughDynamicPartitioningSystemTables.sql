select * from [dbo].[MyPartitionedTable]
select * from [dbo].[MyPartitionedTable_Staging]
SELECT $PARTITION.PF_MyPartitionFunction(PartitionColumnDateTime) AS PartitionNumber, *
FROM [dbo].MyPartitionedTable
select * from sys.partition_range_values where function_id = 65545
select * from sys.partition_functions where name = 'PF_MyPartitionFunction'
select * from sys.partition_schemes where name = 'PS_MyPartitionScheme'
select * from sys.partitions

select f.name 'PFName',s.name 'PSName',v.value,v.boundary_id
from sys.partition_functions f join sys.partition_schemes s on f.function_id = s.function_id
join sys.partition_range_values v on v.function_id = f.function_id
where f.name = 'PF_MyPartitionFunction'

--alter partition scheme PS_MyPartitionScheme next used [primary]
--alter partition function PF_MyPartitionFunction() split range

select * from sys.partitions
WHERE object_id = OBJECT_ID(N'dbo.MyPartitionedTable')   --AND partition_number = 1
--AND index_id IN(0, 1);