DECLARE @clusterindexpartition NVARCHAR(max) 
DECLARE @nonclusterindexpartition NVARCHAR(max)
DECLARE @loggingType BIT 
DECLARE @sessionlogtable NVARCHAR(50)
DECLARE @sessionlogindex NVARCHAR(100)

/*                                          
Creating Partition logging table
*/
IF (OBJECT_ID(N'[DBO].[PartitionAuditLog]',N'U')) IS NULL
BEGIN
CREATE TABLE PartitionAuditLog(
[StepNo] tinyint IDENTITY(1,1),
[ActionPerformed] varchar(200),
[TimeStamp] datetime DEFAULT getdate()
)
END

SELECT @loggingType = unicodeLogging FROM BPASysConfig
--set @LoggingType = 1
IF @loggingType = 0 
SET @sessionlogtable = 'BPASessionLog_NonUnicode'
ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'


DECLARE PartitionSessionLogTable Cursor
FOR
SELECT name FROM SYS.indexes WHERE OBJECT_NAME(OBJECT_ID) = @sessionlogtable --IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')

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

PRINT @clusterindexpartition

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

PRINT @clusterindexpartition 
END
FETCH NEXT FROM PartitionSessionLogTable INTO @sessionlogindex
END

CLOSE PartitionSessionLogTable
DEALLOCATE PartitionSessionLogTable