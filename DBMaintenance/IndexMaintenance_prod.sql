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
;
WITH cte_getFragmentedIndex
AS
(
SELECT
object_id ,index_id ,partition_number ,avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (DB_ID('MyDB'), NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND page_count > 500
)
,cte_identifyTable
AS
(
SELECT f.*,o.name as tablename, s.name as schemaname
FROM sys.objects AS o JOIN sys.schemas as s ON s.schema_id = o.schema_id
JOIN cte_getFragmentedIndex f ON f.object_id = o.object_id
)
,cte_addIndex
AS
(
SELECT f.schemaname,f.object_id,f.tablename,f.index_id,i.name,f.partition_number,f.avg_fragmentation_in_percent FROM cte_identifyTable f JOIN sys.indexes i
ON f.object_id = i.object_id AND f.index_id = f.index_id
)
INSERT @fragmentDetails(schemaname,objectid,tablename,indexid,indexname,partitionnum,frag)
SELECT schemaname,object_id, tablename,index_id, name,partition_number, avg_fragmentation_in_percent FROM cte_addIndex

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



