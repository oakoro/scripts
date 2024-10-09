SET NOCOUNT ON;

DECLARE @exempt_list table (tablename sysname,indexname sysname,system_type_id sysname,status bit default 1)
DECLARE @work_to_do table (objectid sysname,indexid sysname,partitionnum sysname,frag float)
DECLARE @work_to_do_final table (tablename sysname,indexname sysname,frag float,partitionnum sysname,status bit)



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

insert @work_to_do_final(tablename ,indexname ,frag ,partitionnum,[status])
  select OBJECT_NAME(i.object_id),i.name, frag,partitionnum,
  case when [status] IS NULL THEN 0 else STATUS end as [status]
  from @work_to_do w join sys.indexes i on w.objectid = i.object_id and w.indexid = i.index_id
  left join @exempt_list l on l.tablename = OBJECT_NAME(i.object_id) and l.indexname = i.name

 --select * from @work_to_do_final  



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
DECLARE @frag float;
DECLARE @command NVARCHAR(4000);
DECLARE @starttime DATETIME = GETDATE() --'2024-10-09 10:20:19.303'


-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function
-- and convert object and index IDs to names.
--SELECT object_id AS objectid,
--    index_id AS indexid,
--    partition_number AS partitionnum,
--    avg_fragmentation_in_percent AS frag
--INTO #work_to_do
--FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
--WHERE avg_fragmentation_in_percent > 10.0
--    AND index_id > 0;






-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR
FOR
SELECT tablename ,indexname ,partitionnum,frag ,[status]
FROM  @work_to_do_final;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1 = 1) AND DATEDIFF(MI,@starttime,GETDATE())< 1
BEGIN;

    FETCH NEXT
    FROM partitions
    INTO @objectname,
        @indexname,
        @partitionnum,
        @frag,
		@exemptstatus;

    IF @@FETCH_STATUS < 0
        BREAK;

    SELECT 
        @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    INNER JOIN sys.schemas AS s
        ON s.schema_id = o.schema_id
    WHERE o.name = @objectname;

	--select @frag

    --SELECT @indexname = QUOTENAME(name)
    --FROM sys.indexes
    --WHERE object_id = @objectid
    --    AND index_id = @indexid;
	

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

    IF @partitioncount > 1
        --SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS NVARCHAR(10)) ;
		SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD PARTITION='+ CAST(@partitionnum AS NVARCHAR(10)) ;

    --EXEC (@command);
	PRINT @command;
    --PRINT N'Executed: ' + @command;
END;

-- Close and deallocate the cursor.
CLOSE partitions;

DEALLOCATE partitions;

-- Drop the temporary table.
--DROP TABLE #work_to_do;
GO

/*
ALTER INDEX PK_BPAProcessNameDependency ON [dbo].BPAProcessNameDependency REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAProcessActionDependency ON [dbo].BPAProcessActionDependency REBUILD WITH (ONLINE=ON) 
ALTER INDEX INDEX_BPAAuditEvents_eventdatetime ON [dbo].BPAAuditEvents REORGANIZE
ALTER INDEX IX_BPAAuditEvents_gTgtProcID ON [dbo].BPAAuditEvents REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPADBVersion ON [dbo].BPADBVersion REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAReleaseEntry ON [dbo].BPAReleaseEntry REORGANIZE
ALTER INDEX PK_BPAProcess ON [dbo].BPAProcess REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAValCheck ON [dbo].BPAValCheck REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPALicense ON [dbo].BPALicense REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAPerm ON [dbo].BPAPerm REBUILD WITH (ONLINE=ON) 
ALTER INDEX UNQ_BPAPerm_name ON [dbo].BPAPerm REBUILD WITH (ONLINE=ON)

ALTER INDEX PK_BPAProcessNameDependency ON [dbo].BPAProcessNameDependency REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAProcessActionDependency ON [dbo].BPAProcessActionDependency REBUILD WITH (ONLINE=ON) 
ALTER INDEX INDEX_BPAAuditEvents_eventdatetime ON [dbo].BPAAuditEvents REORGANIZE
ALTER INDEX INDEX_BPAAuditEvents_eventdatetime ON [dbo].BPAAuditEvents REORGANIZE
ALTER INDEX PK_BPADBVersion ON [dbo].BPADBVersion REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAReleaseEntry ON [dbo].BPAReleaseEntry REORGANIZE
ALTER INDEX PK_BPAReleaseEntry ON [dbo].BPAReleaseEntry REORGANIZE
ALTER INDEX PK_BPAValCheck ON [dbo].BPAValCheck REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPALicense ON [dbo].BPALicense REBUILD WITH (ONLINE=ON) 
ALTER INDEX PK_BPAPerm ON [dbo].BPAPerm REBUILD WITH (ONLINE=ON) 
ALTER INDEX UNQ_BPAPerm_name ON [dbo].BPAPerm REBUILD WITH (ONLINE=ON) 
*/