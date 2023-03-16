--select * FROM sys.partition_functions AS pf

--            JOIN sys.partition_range_values AS prv ON

--                  prv.function_id = pf.function_id
--			   WHERE

--                  pf.name = 'pflogid2'
--				order by prv.value 
--select * from sys.partitions where OBJECT_NAME(object_id) = 'BPASessionLog_NonUnicode' and index_id <= 1 
--select * from sys.dm_db_partition_stats where OBJECT_NAME(object_id) = 'BPASessionLog_NonUnicode' and index_id <= 1 
--select top 2* from sys.indexes
--select * from sys.data_spaces
--select * from sys.destination_data_spaces--destination_id = partition no
--select * from sys.partition_schemes
--select top 2* from sys.partition_range_values

select pstats.partition_id
,object_name(pstats.object_id) 'TableName'
,pstats.partition_number,pstats.row_count
,ps.name 'PartitionScheme'
, pf.name 'PartitionFunction'
, prv.value 'LowerBoundary' --lag(value) over (order by pstats.partition_number), 
,lead(value) over (order by pstats.partition_number) 'UpperBoundary'
FROM sys.dm_db_partition_stats AS pstats 
join sys.destination_data_spaces dds on pstats.partition_number = dds.destination_id
join sys.partition_schemes ps on ps.data_space_id = dds.partition_scheme_id
join sys.partition_functions pf on pf.function_id = ps.function_id
join sys.partition_range_values prv on prv.function_id = pf.function_id and pstats.partition_number = (CASE pf.boundary_value_on_right WHEN 0 THEN prv.boundary_id ELSE (prv.boundary_id+1) END)
where object_name(pstats.object_id) = 'BPASessionLog_NonUnicode_PartitionTest' and pstats.index_id <= 1 and ps.name = 'pslogid'  and pf.name = 'pflogid' --and pstats.row_count > 0

--select * from sys.partition_range_values prv join sys.partition_functions pf on prv.function_id = pf.function_id
--where pf.name = 'pflogid2'

select count(*) from BPASessionLog_NonUnicode where logid < 4875468
select count(*) from BPASessionLog_NonUnicode where logid < 4875468

--truncate table BPASessionLog_NonUnicode_PartitionTest