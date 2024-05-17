SET NOCOUNT ON;

DECLARE @objectid int;

DECLARE @indexid int;

DECLARE @partitioncount bigint;

DECLARE @schemaname nvarchar(130);

DECLARE @objectname nvarchar(130);

DECLARE @indexname nvarchar(130);

DECLARE @partitionnum bigint;

DECLARE @partitions bigint;

DECLARE @frag float;

DECLARE @command nvarchar(4000);

DECLARE @fragmentDetails TABLE (
schemaname sysname NULL,
objectid sysname NULL,
tablename sysname NULL,
indexid sysname NULL,
indexname sysname NULL,
partitionnum sysname NULL,
frag sysname NULL
)

-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function

-- and convert object and index IDs to names.
INSERT @fragmentDetails(objectid,indexid,partitionnum,frag)
SELECT

object_id AS objectid,

index_id AS indexid,

partition_number AS partitionnum,

avg_fragmentation_in_percent AS frag

--INTO #work_to_do

FROM sys.dm_db_index_physical_stats (DB_ID('MyDB'), NULL, NULL , NULL, 'LIMITED')

WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0;

-- Declare the cursor for the list of partitions to be processed.

DECLARE partitions CURSOR FOR SELECT objectid,indexid,partitionnum,frag FROM @fragmentDetails;

-- Open the cursor.

OPEN partitions;

-- Loop through the partitions.

WHILE (1=1)

BEGIN;

FETCH NEXT

FROM partitions

INTO @objectid, @indexid, @partitionnum, @frag;

IF @@FETCH_STATUS < 0 BREAK;


SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)

FROM sys.objects AS o

JOIN sys.schemas as s ON s.schema_id = o.schema_id

WHERE o.object_id = @objectid;



SELECT @indexname = QUOTENAME(name)

FROM sys.indexes

WHERE object_id = @objectid AND index_id = @indexid;

--SELECT @partitioncount = count (*)

--FROM sys.partitions

--WHERE object_id = @objectid AND index_id = @indexid;

UPDATE @fragmentDetails
SET schemaname = @schemaname, tablename = @objectname, indexname = @indexname
WHERE objectid = @objectid AND indexid = @indexid 

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.

--IF @frag < 30.0

--SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';

--IF @frag >= 30.0

--SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';

--IF @partitioncount > 1

--SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));

----EXEC (@command);

--PRINT @command;

END;

-- Close and deallocate the cursor.

CLOSE partitions;

DEALLOCATE partitions;

-- Drop the temporary table.

--DROP TABLE #work_to_do;
SELECT * FROM @fragmentDetails

DECLARE generateRebuildScript CURSOR 
FOR
SELECT schemaname, tablename, indexname,frag FROM @fragmentDetails