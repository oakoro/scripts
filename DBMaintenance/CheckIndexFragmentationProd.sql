--Define table variables
DECLARE @exempt_list TABLE (tablename NVARCHAR(130),indexname NVARCHAR(130),system_type_id sysname,status BIT DEFAULT 1)
DECLARE @work_to_do TABLE (objectid INT,indexid INT,partitionnum BIGINT,frag FLOAT)
DECLARE @work_to_do_final TABLE (objectid INT,tablename NVARCHAR(130),indexid INT,indexname NVARCHAR(130),frag FLOAT,partitionnum BIGINT,status bit)

--identify indexes that cannot be rebuilt online
INSERT @exempt_list(tablename,indexname,system_type_id)
SELECT  DISTINCT OBJECT_NAME(ic.object_id) TABLE_NAME,i.name INDEX_NAME,t.system_type_id
FROM sys.columns c JOIN sys.index_columns ic ON c.object_id = ic.object_id and c.column_id = ic.column_id
JOIN sys.types t ON t.system_type_id = c.system_type_id
JOIN sys.indexes i ON i.object_id = ic.object_id and i.index_id = ic.index_id
JOIN sys.objects o ON o.object_id = i.object_id
WHERE t.system_type_id IN (34,35,36,99) and o.type = 'U' 

-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function
-- and convert object and index IDs to names.
INSERT @work_to_do
SELECT object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 and page_count > 1000
    AND index_id > 0;

INSERT @work_to_do_final(objectid,tablename,indexid,indexname ,frag ,partitionnum,[status])
SELECT w.objectid, OBJECT_NAME(i.object_id),w.indexid,i.name, frag,partitionnum,
  CASE WHEN [status] IS NULL THEN 0 ELSE STATUS END AS [status]
FROM @work_to_do w JOIN sys.indexes i ON w.objectid = i.object_id AND w.indexid = i.index_id
LEFT JOIN @exempt_list l ON l.tablename = OBJECT_NAME(i.object_id) and l.indexname = i.name


select * from @work_to_do_final 
order by --tablename,indexname,partitionnum, 
frag desc