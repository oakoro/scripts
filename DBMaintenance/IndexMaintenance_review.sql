DECLARE @schemaname sysname,@tablename sysname,@indexname sysname,
		@partitionnum sysname,@frag sysname, @sqlcmd varchar(800),
		@objectid sysname,@indexid sysname,@partitioncount tinyint,
		@debug bit = 1

DECLARE @fragmentDetails TABLE (
schemaname sysname NULL,
objectid sysname NULL,
tablename sysname NULL,
indexid sysname NULL,
indexname sysname NULL,
partitionnum sysname NULL,
frag sysname NULL
)
SET NOCOUNT ON

insert @fragmentDetails
SELECT
c.name'Schemaname'
,a.object_id
,b.name
,a.index_id 
,d.name 'indexName'
,partition_number 
,convert(numeric(5,2),avg_fragmentation_in_percent)'avg_fragmentation_in_percent'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') a
join sys.objects b on a.object_id = b.object_id
JOIN sys.schemas as c ON c.schema_id = b.schema_id
JOIN sys.indexes d on d.object_id = b.object_id and d.type = a.index_id
WHERE avg_fragmentation_in_percent > 10.0 AND a.index_id > 0 AND page_count > 500

select * from @fragmentDetails
DECLARE defragIndex CURSOR
FOR
SELECT  schemaname,objectid,tablename,indexid,indexname,partitionnum,frag from @fragmentDetails
ORDER BY frag DESC

OPEN defragIndex

FETCH NEXT FROM defragIndex INTO @schemaname,@objectid,@tablename,@indexid,@indexname,@partitionnum,@frag 

WHILE @@FETCH_STATUS = 0

BEGIN
SET NOCOUNT ON;
SELECT @partitioncount = count (*)
FROM sys.partitions
WHERE object_id = @objectid AND index_id = @indexid;

IF @frag < 30.0 AND @partitioncount > 1
BEGIN
SET @sqlcmd = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @tablename + N' REORGANIZE PARTITION=' + CAST(@partitionnum AS nvarchar(10))+';';
END
ELSE
IF @frag < 30.0 AND @partitioncount = 1
BEGIN
SET @sqlcmd = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @tablename + N' REORGANIZE;';
END
ELSE
IF @frag >= 30.0 AND @partitioncount > 1
BEGIN
SET @sqlcmd = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @tablename + N' REBUILD PARTITION=' + CAST(@partitionnum AS nvarchar(10)) + N' WITH (ONLINE=ON);';
END
ELSE
IF @frag >= 30.0 AND @partitioncount = 1
BEGIN
SET @sqlcmd = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @tablename + N' REBUILD WITH (ONLINE=ON);';
END

IF @debug = 1
BEGIN
PRINT @sqlcmd;
END
ELSE EXEC (@sqlcmd);
 
FETCH NEXT FROM defragIndex INTO @schemaname,@objectid,@tablename,@indexid,@indexname,@partitionnum,@frag 
END

CLOSE defragIndex;

DEALLOCATE defragIndex;



