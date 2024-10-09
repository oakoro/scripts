DECLARE @exempt_list table (tablename sysname,indexname sysname,system_type_id sysname,status bit default 1)
DECLARE @work_to_do table (objectid sysname,indexid sysname,partitionnum sysname,frag sysname)



insert @exempt_list(tablename,indexname,system_type_id)
select  DISTINCT OBJECT_NAME(ic.object_id) TABLE_NAME,i.name INDEX_NAME,t.system_type_id
from sys.columns c join sys.index_columns ic on c.object_id = ic.object_id and c.column_id = ic.column_id
join sys.types t on t.system_type_id = c.system_type_id
join sys.indexes i on i.object_id = ic.object_id and i.index_id = ic.index_id
JOIN sys.objects o on o.object_id = i.object_id
WHERE t.system_type_id IN (34,35,36,99) and o.type = 'U'


insert @work_to_do
SELECT object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
--INTO #work_to_do
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0
    AND index_id > 0;

select * from @work_to_do
select * from @exempt_list ORDER BY tablename

  --SELECT @indexname = QUOTENAME(name)
  --  FROM sys.indexes
  --  WHERE object_id = @objectid
  --      AND index_id = @indexid;

  select objectid,OBJECT_NAME(i.object_id)'TableName', partitionnum,frag,i.name,[status]
  from @work_to_do w join sys.indexes i on w.objectid = i.object_id and w.indexid = i.index_id
  left join @exempt_list l on l.tablename = OBJECT_NAME(i.object_id) and l.indexname = i.name

    select objectid,OBJECT_NAME(i.object_id)'TableName', partitionnum,frag,i.name,
  case when [status] IS NULL THEN 0 else STATUS end as [status]
  from @work_to_do w join sys.indexes i on w.objectid = i.object_id and w.indexid = i.index_id
  left join @exempt_list l on l.tablename = OBJECT_NAME(i.object_id) and l.indexname = i.name


  

