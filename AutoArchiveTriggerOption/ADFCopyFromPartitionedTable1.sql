declare @initboundary bigint, @nextboundary bigint
declare @tbl table (col1 bigint)
				 
;with cte
as (
SELECT
    OBJECT_NAME(pstats.object_id) AS TableName
    ,ps.name AS PartitionSchemeName
    ,pf.name AS PartitionFunctionName
   ,prv.value AS PartitionBoundaryValue
    ,c.name AS PartitionKey
    ,pstats.partition_number AS PartitionNumber
    ,pstats.row_count AS PartitionRowCount
    
FROM sys.dm_db_partition_stats AS pstats
INNER JOIN sys.partitions AS p ON pstats.partition_id = p.partition_id
INNER JOIN sys.destination_data_spaces AS dds ON pstats.partition_number = dds.destination_id
INNER JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
INNER JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
INNER JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
INNER JOIN sys.indexes AS i ON pstats.object_id = i.object_id AND pstats.index_id = i.index_id AND dds.partition_scheme_id = i.data_space_id AND i.type <= 1 /* Heap or Clustered Index */
INNER JOIN sys.index_columns AS ic ON i.index_id = ic.index_id AND i.object_id = ic.object_id AND ic.partition_ordinal > 0
INNER JOIN sys.columns AS c ON pstats.object_id = c.object_id AND ic.column_id = c.column_id
LEFT JOIN sys.partition_range_values AS prv ON pf.function_id = prv.function_id AND pstats.partition_number = (CASE pf.boundary_value_on_right WHEN 0 THEN prv.boundary_id ELSE (prv.boundary_id+1) END)
WHERE pstats.object_id = OBJECT_ID('[dbo].[BPASessionLog_NonUnicode_PartitionTest]')
--ORDER BY TableName, PartitionNumber;
)
,
cte2
as
(
SELECT prv.value

            FROM sys.partition_functions AS pf

            JOIN sys.partition_range_values AS prv ON

                  prv.function_id = pf.function_id
			   WHERE

                  pf.name = 'pflogid'
				  )

insert @tbl(col1)
select top 2 convert(bigint,convert(nvarchar(20),cte2.value)) from cte join cte2 on cte.PartitionBoundaryValue = cte2.value where cte.PartitionRowCount > 0

--select * from @tbl
select top  1 @initboundary = 
col1 from @tbl order by col1 asc
select top  1 @nextboundary = 
col1-1 from @tbl order by col1 desc
select @initboundary, @nextboundary
select * from [BPASessionLog_NonUnicode_PartitionTest] 
where logid between @initboundary and  @nextboundary



--select top 5* from BPASessionLog_NonUnicode_PartitionTest 
--select count(*) from BPASessionLog_NonUnicode_PartitionTest where logid >= 887877