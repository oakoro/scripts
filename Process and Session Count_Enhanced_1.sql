declare @LoggingType bit, @sessionlogtable nvarchar(50)
SELECT @LoggingType = unicodeLogging FROM BPASysConfig
if @LoggingType = 0 
set @sessionlogtable = 'BPASessionLog_NonUnicode'
else set @sessionlogtable = 'BPASessionLog_Unicode'
exec ('
declare @totalSession numeric, @totalSize numeric
with cte_sessionlogsize1
as
(select 
s.Name AS SchemaName,
t.name,
p.partition_number,
p.rows,
a.used_pages,
a.total_pages
from
sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
)
,cte_sessionlogsize2
as
(
select distinct SchemaName,name, partition_number,rows,
CAST(ROUND((SUM(used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB--,
--CAST(ROUND((SUM(total_pages) - SUM(used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
--CAST(ROUND((SUM(total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
 from cte_sessionlogsize1 
group by SchemaName,name,partition_number,rows
)
,cte_sessionlogsize3
as
(
select distinct SchemaName, name, sum(rows) ''RowCount'',sum(Used_MB)''Used_MB''--,
--sum(Unused_MB)''Unused_MB'',sum(Total_MB)''Total_MB''
from cte_sessionlogsize2 where name = ''BPASessionLog_NonUnicode''
group by SchemaName, name
)
select @totalSession = [RowCount], @totalSize = Used_MB from cte_sessionlogsize3

;with cte_process
as
(
select p.name AS ''ProcessName'', count(s.sessionnumber) AS ''SessionCount'' from BPAProcess p with (nolock) 
join BPASession s with (nolock) on p.processid = s.processid
group by p.name
)

, cte_session
as
(
select p.name AS ''ProcessName'', COUNT(l.sessionnumber) AS ''SessionLogCount'' from BPASession s with (nolock) 
	join BPASessionLog_NonUnicode l with (nolock) on s.sessionnumber = l.sessionnumber
	join BPAProcess p ON s.processid = p.processid
	group by p.name
)
select top 10 p.ProcessName,p.SessionCount,s.SessionLogCount, 
convert(numeric(20,2),(s.SessionLogCount/@totalSession*@totalSize)) ''SizeInMB_Approx''
from cte_process p join cte_session s on p.ProcessName = s.ProcessName
order by p.SessionCount desc'
)