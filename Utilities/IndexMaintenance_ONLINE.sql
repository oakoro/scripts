SET NOCOUNT ON
DECLARE @schema nvarchar(10), @table nvarchar(200), @index nvarchar(200), 
		@fragment float, @str nvarchar(400),@debug bit = 1

DROP TABLE IF EXISTS dbo.indexmaintenance;

CREATE TABLE indexmaintenance(
[schema] varchar(10),
[table] varchar(200),
[index] varchar(200),
[fragment] float,
[processeddate] datetime
)

DECLARE defrag_index CURSOR
FOR
SELECT  
SCHEMA_NAME(o.[schema_id]) AS [Schema Name],
OBJECT_NAME(ps.OBJECT_ID) AS [Object Name], 
i.[name] AS [Index Name], 
ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL , N'LIMITED') AS ps
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON ps.[object_id] = i.[object_id] 
AND ps.index_id = i.index_id
INNER JOIN sys.objects AS o WITH (NOLOCK)
ON i.[object_id] = o.[object_id]
WHERE ps.database_id = DB_ID()
AND ps.page_count > 500 AND ps.avg_fragmentation_in_percent > 29.99
AND OBJECT_NAME(ps.OBJECT_ID) NOT LIKE '%PRE65' AND i.[name] IS NOT NULL
ORDER BY OBJECT_NAME(ps.OBJECT_ID) ,ps.avg_fragmentation_in_percent DESC OPTION (RECOMPILE);

OPEN defrag_index

FETCH NEXT FROM defrag_index INTO @schema, @table, @index, @fragment

WHILE @@FETCH_STATUS = 0

BEGIN
--PRINT  @schema +' '+ @table+' '+ @index+' ' + convert(nvarchar(10),@fragment)
IF @fragment BETWEEN 0 AND 30
BEGIN
SET @str = 'ALTER INDEX '+@index +' ON '+@schema+'.'+@table+ ' REORGANIZE'
IF @debug = 1
PRINT @str
ELSE 
EXECUTE SP_EXECUTESQL @str
END
IF @fragment > 30 AND @index = 'PK_BPASessionLog_NonUnicode'
BEGIN
SET @str = 'ALTER INDEX '+@index +' ON '+@schema+'.'+@table+ ' REORGANIZE'
IF @debug = 1
PRINT @str
ELSE 
EXECUTE SP_EXECUTESQL @str
END
IF @fragment > 30 AND @index <> 'PK_BPASessionLog_NonUnicode'
BEGIN
SET @str = 'ALTER INDEX '+@index +' ON '+@schema+'.'+@table+ ' REBUILD WITH (ONLINE=ON)'
IF @debug = 1
PRINT @str
ELSE 
EXECUTE SP_EXECUTESQL @str
END
INSERT indexmaintenance VALUES(@schema,@table,@index,@fragment,getdate())


FETCH NEXT FROM defrag_index INTO @schema, @table, @index, @fragment
END
CLOSE defrag_index
DEALLOCATE defrag_index
SET NOCOUNT OFF