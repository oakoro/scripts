SET NOCOUNT ON;

DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @exemptobjectname NVARCHAR(130);
DECLARE @exemptindexname NVARCHAR(130);
DECLARE @exemptstatus BIT;
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);
DECLARE @starttime DATETIME = GETDATE() --'2024-10-11 09:10:19.303'
DECLARE @datediff INT;



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
WHERE avg_fragmentation_in_percent > 10.0
    AND index_id > 0;

INSERT @work_to_do_final(objectid,tablename,indexid,indexname ,frag ,partitionnum,[status])
SELECT w.objectid, OBJECT_NAME(i.object_id),w.indexid,i.name, frag,partitionnum,
  CASE WHEN [status] IS NULL THEN 0 ELSE STATUS END AS [status]
FROM @work_to_do w JOIN sys.indexes i ON w.objectid = i.object_id AND w.indexid = i.index_id
LEFT JOIN @exempt_list l ON l.tablename = OBJECT_NAME(i.object_id) and l.indexname = i.name


-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR
FOR
SELECT objectid,tablename,indexid,indexname ,partitionnum,frag ,[status]
FROM  @work_to_do_final
ORDER BY frag DESC;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
FETCH NEXT
FROM partitions
INTO @objectid,
	@objectname,
	@indexid,
	@indexname,
    @partitionnum,
    @frag,
	@exemptstatus;

 
	WHILE @@FETCH_STATUS = 0

	BEGIN

	

    SELECT 
        @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    INNER JOIN sys.schemas AS s
        ON s.schema_id = o.schema_id
    WHERE o.name = @objectname;

	SELECT @partitioncount = count(*)
    FROM sys.partitions 
	 WHERE object_id = @objectid
        AND index_id = @indexid;

     --30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
    IF @frag < 30
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';

    IF @frag >= 30 and @exemptstatus = 0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE=ON) ';

	IF @frag >= 30 and @exemptstatus = 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';

    IF @frag >= 30 and @partitioncount > 1
        --SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS NVARCHAR(10)) ;
		SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD PARTITION='+ CAST(@partitionnum AS NVARCHAR(10)) +N' WITH (ONLINE=ON) ';

	IF @frag < 30 and @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE PARTITION='+ CAST(@partitionnum AS NVARCHAR(10)) ;


    PRINT @command;
	EXEC (@command);
    --PRINT N'Executed: ' + @command;

--Terminate maintenance 
SET @datediff = DATEDIFF(mi,@starttime,GETDATE())

IF @datediff > 2
BEGIN
BREAK;
END

FETCH NEXT
    FROM partitions
    INTO @objectid,
		@objectname,
		@indexid,
		@indexname,
        @partitionnum,
        @frag,
		@exemptstatus;
END;

-- Close and deallocate the cursor.
CLOSE partitions;

DEALLOCATE partitions;

GO
