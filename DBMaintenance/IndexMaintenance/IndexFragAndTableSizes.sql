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
,cte_3
as
(
select distinct SchemaName, name, sum(rows) 'RowCount',sum(Used_MB)'Used_MB',
sum(Unused_MB)'Unused_MB',sum(Total_MB)'Total_MB'
from cte_2
group by SchemaName, name
)
,cte_4
as
(
select 	ObjectSchema = OBJECT_SCHEMA_NAME(idxs.object_id),ObjectName = object_name(idxs.object_id) 
		,IndexName = idxs.name,i.avg_fragmentation_in_percent,i.page_count
			,case when ps.data_space_id IS NULL then 0 else 1 end as IsPartitioned
			from sys.indexes idxs 
		left join sys.partition_schemes ps ON idxs.data_space_id = ps.data_space_id
		inner join sys.objects obj on idxs.object_id = obj.object_id
		inner join sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL ,'limited') i  on i.object_id = idxs.object_id and i.index_id = idxs.index_id
		where idxs.type in (1,2,5,6) 
		and (alloc_unit_type_desc = 'IN_ROW_DATA' or alloc_unit_type_desc is null )
		and OBJECT_SCHEMA_NAME(idxs.object_id) != 'sys'
		and idxs.is_disabled=0
		and obj.type_desc != 'TF' 
)
select b.*,a.[RowCount],a.Unused_MB
from cte_3 a join cte_4 b on a.name = b.ObjectName and a.SchemaName = b.ObjectSchema order by b.ObjectName


