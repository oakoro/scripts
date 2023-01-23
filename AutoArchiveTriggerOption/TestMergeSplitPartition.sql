--CREATE PARTITION FUNCTION myRangePF1 (datetime2(0))  
--    AS RANGE RIGHT FOR VALUES ('2022-04-01', '2022-05-01', '2022-06-01') ;  
--GO  

--CREATE PARTITION SCHEME myRangePS1  
--    AS PARTITION myRangePF1  
--    ALL TO ('PRIMARY') ;  
--GO  

--CREATE TABLE dbo.PartitionTable (col1 datetime2(0) PRIMARY KEY, col2 char(10))  
--    ON myRangePS1 (col1) ;  
--GO

SELECT $PARTITION.myRangePF1(col1) AS PartitionNumber, *
FROM [dbo].PartitionTable
select * from sys.partition_range_values where function_id = 65545
select * from sys.partition_functions where name = 'myRangePF1'
select * from sys.partition_schemes where name = 'PS_MyPartitionScheme'
select * from sys.partitions
WHERE object_id = OBJECT_ID(N'dbo.PartitionTable') 
select * from sys.partition_range_values
select f.name 'PFName',s.name 'PSName',v.value,v.boundary_id
from sys.partition_functions f join sys.partition_schemes s on f.function_id = s.function_id
join sys.partition_range_values v on v.function_id = f.function_id
where f.name = 'myRangePF1'
--alter partition function myRangePF1()
--split range ('2022-03-01') 

--alter partition function myRangePF1()
--merge range ('2022-05-01') 