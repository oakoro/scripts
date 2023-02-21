declare @initboundary bigint, @nextboundary bigint
declare @tblRange table (rangevalue bigint)
				 
insert @tblRange(rangevalue)
SELECT top 2 convert(bigint,convert(nvarchar(max),prv.value))

            FROM sys.partition_functions AS pf

            JOIN sys.partition_range_values AS prv ON

                  prv.function_id = pf.function_id
			   WHERE

                  pf.name = 'pflogid2'
				order by prv.value 
--select * from @tblRange
select top  1 @initboundary = 
rangevalue from @tblRange order by rangevalue asc
select top  1 @nextboundary = 
rangevalue from @tblRange order by rangevalue desc
select @initboundary'initboundary', @nextboundary'nextboundary'
select count(*)'TotalRowsToCopy' from [BPASessionLog_NonUnicode] 
where logid between @initboundary and  @nextboundary

--select * from [BPASessionLog_NonUnicode_PartitionTest] order by logid --887877 - 950042

--select top 1 partition_number, rows from sys.partitions where OBJECT_NAME(object_id) = 'BPASessionLog_NonUnicode_PartitionTest' and rows <> 0 and index_id = 1

--logid >= 24377336 and logid < 2147483647
--logid >= 1 and logid < 4875468