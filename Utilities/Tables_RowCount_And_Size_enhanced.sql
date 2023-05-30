with cte_1
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
,cte_2
as
(
select distinct SchemaName,name, partition_number,rows,
CAST(ROUND((SUM(used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(total_pages) - SUM(used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
 from cte_1
group by SchemaName,name,partition_number,rows
)
select distinct SchemaName, name, sum(rows) 'RowCount',sum(Used_MB)'Used_MB',
sum(Unused_MB)'Unused_MB',sum(Total_MB)'Total_MB'
from cte_2
group by SchemaName, name
ORDER BY sum(rows) desc

