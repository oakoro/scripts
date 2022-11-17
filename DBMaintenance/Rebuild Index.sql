declare @schema varchar(10),@table varchar(50),@indexName varchar(50),@frag float, @cmdstr nvarchar(200)
declare index_maintenance cursor
for
SELECT  SCHEMA_NAME(o.[schema_id]) AS [Schema Name],
OBJECT_NAME(ps.OBJECT_ID) AS [Object Name], i.[name] AS [Index Name]
, ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL , N'LIMITED') AS ps
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON ps.[object_id] = i.[object_id] 
AND ps.index_id = i.index_id
INNER JOIN sys.objects AS o WITH (NOLOCK)
ON i.[object_id] = o.[object_id]
WHERE ps.database_id = DB_ID()
AND ps.page_count > 500 and ps.avg_fragmentation_in_percent > 29 
AND OBJECT_NAME(ps.OBJECT_ID) NOT IN ('BPASessionLog_NonUnicode_pre65','BPASessionLog_Unicode_pre65')
ORDER BY [Object Name]

open index_maintenance

fetch next from index_maintenance into @schema, @table, @indexName, @frag

while @@fetch_status = 0
begin
set nocount on
select @schema, @table, @indexName, @frag
if @table = 'BPASessionLog_NonUnicode' and @indexName = 'PK_BPASessionLog_NonUnicode'
set @cmdstr = 'ALTER INDEX '+@indexName +' ON '+@schema+'.'+@table +' REORGANIZE'
else
set @cmdstr = 'ALTER INDEX '+@indexName +' ON '+@schema+'.'+@table +' REBUILD WITH (ONLINE=ON)'
print (@cmdstr)
--EXECUTE sp_executesql @cmdstr
fetch next from index_maintenance into @schema, @table, @indexName, @frag
end

close index_maintenance
deallocate index_maintenance