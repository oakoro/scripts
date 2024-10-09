select  DISTINCT OBJECT_NAME(ic.object_id), c.name, c.system_type_id,i.name INDEX_NAME
from sys.columns c join sys.index_columns ic on c.object_id = ic.object_id and c.column_id = ic.column_id
join sys.types t on t.system_type_id = c.system_type_id
join sys.indexes i on i.object_id = ic.object_id and i.index_id = ic.index_id
where OBJECT_NAME(c.object_id) = 'BPAWorkQueueItem' 
--WHERE o.type = 'U'
and t.system_type_id IN (34,35,36,99)


select  DISTINCT OBJECT_NAME(ic.object_id), c.name, c.system_type_id,i.name INDEX_NAME
from sys.columns c join sys.index_columns ic on c.object_id = ic.object_id and c.column_id = ic.column_id
join sys.types t on t.system_type_id = c.system_type_id
join sys.indexes i on i.object_id = ic.object_id and i.index_id = ic.index_id
JOIN sys.objects o on o.object_id = i.object_id
WHERE t.system_type_id IN (34,35,36,99) and o.type = 'U'