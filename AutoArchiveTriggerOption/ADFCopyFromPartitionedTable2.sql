declare @initboundary bigint, @nextboundary bigint
declare @tbl table (col1 bigint)
				 
insert @tbl(col1)
SELECT top 2 convert(bigint,convert(nvarchar(max),prv.value))

            FROM sys.partition_functions AS pf

            JOIN sys.partition_range_values AS prv ON

                  prv.function_id = pf.function_id
			   WHERE

                  pf.name = 'pflogid'
				order by prv.value desc
select * from @tbl
select top  1 @initboundary = 
col1 from @tbl order by col1 asc
select top  1 @nextboundary = 
col1 from @tbl order by col1 desc
select @initboundary, @nextboundary
select count(*) from [BPASessionLog_NonUnicode_PartitionTest] 
where logid between @initboundary and  @nextboundary

--select * from [BPASessionLog_NonUnicode_PartitionTest] order by logid --887877 - 950042

select top 1 partition_number, rows from sys.partitions where OBJECT_NAME(object_id) = 'BPASessionLog_NonUnicode_PartitionTest' and rows <> 0 and index_id = 1

