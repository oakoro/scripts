DECLARE @clusterindexpartition NVARCHAR(max) 
DECLARE @nonclusterindexpartition NVARCHAR(max)
DECLARE @loggingType BIT 
DECLARE @sessionlogtable NVARCHAR(50)
DECLARE @sessionlogindex NVARCHAR(100)

SET NOCOUNT ON;

SELECT @loggingType = unicodeLogging FROM BPASysConfig

IF @loggingType = 0 
SET @sessionlogtable = 'BPASessionLog_NonUnicode'
ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'


DECLARE PartitionSessionLogTable CURSOR
FOR
SELECT name FROM SYS.indexes WHERE OBJECT_NAME(OBJECT_ID) = @sessionlogtable 

OPEN PartitionSessionLogTable

FETCH NEXT FROM PartitionSessionLogTable INTO @sessionlogindex

WHILE @@FETCH_STATUS = 0

BEGIN
IF @sessionlogindex LIKE 'PK_%'
BEGIN
SET @clusterindexpartition = '
	CREATE UNIQUE CLUSTERED INDEX '+QUOTENAME(@sessionlogindex)+
	' ON [dbo].'+QUOTENAME(@sessionlogtable)+'(logid)
	WITH (DROP_EXISTING = ON)
	ON PS_Dynamic_NU (logid);'

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('CREATE UNIQUE CLUSTERED INDEX '+ @sessionlogindex +' INDEX');

EXEC (@clusterindexpartition)

END
ELSE
BEGIN
SET @clusterindexpartition = '
	
	DROP INDEX '+QUOTENAME(@sessionlogindex)+' ON [dbo].'+QUOTENAME(@sessionlogtable)+';
	
	CREATE NONCLUSTERED INDEX '+QUOTENAME(@sessionlogindex)+' ON [dbo].'+QUOTENAME(@sessionlogtable)+
	' (
	[sessionnumber] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	ON PS_Dynamic_NU (logid);'

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('CREATE UNIQUE CLUSTERED INDEX '+ @sessionlogindex +' INDEX');

EXEC (@clusterindexpartition)
END
FETCH NEXT FROM PartitionSessionLogTable INTO @sessionlogindex
END

CLOSE PartitionSessionLogTable
DEALLOCATE PartitionSessionLogTable