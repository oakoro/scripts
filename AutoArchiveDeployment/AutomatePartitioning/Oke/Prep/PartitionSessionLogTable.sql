SET XACT_ABORT ON;

/*1_Create session log copy table and switch data from production to copy*/
BEGIN TRANSACTION
SET NOCOUNT ON;
BEGIN
DECLARE @CopySessionLogTbl NVARCHAR(MAX),
		@loggingTable NVARCHAR(30),
		@loggingType BIT,
		@switchCopySessionLog NVARCHAR(MAX),
		@copyTopLogging NVARCHAR(MAX),
		@deleteTopLogging NVARCHAR(200),
		@debug BIT = 0,
		@CopySessionLogTable NVARCHAR(30),
		@switchSessionLogBack NVARCHAR(MAX),
		@maxLogid BIGINT, 
		@sessionlogtable NVARCHAR(50), 
		@mxidStr NVARCHAR(400),
		@mxidout BIGINT, @mnidout BIGINT, 
		@param NVARCHAR(255) = '@mxid BIGINT OUTPUT, @mnid BIGINT OUTPUT',
		@constraintStr NVARCHAR(400), 
		@logidMax BIGINT,
		@maxlogidout BIGINT,
		@params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT',
		@strMaxLogid NVARCHAR(400), 
		@createPartitionFunction NVARCHAR(400),
		@createPartitionScheme NVARCHAR(400),
		@nextPartitionID BIGINT, --Maximum logid or seed value in BPASessionLog Table
		@partitionseedValue BIGINT --Partition function seed value


/*                                          
Creating Partition logging table
*/
IF @debug  = 0
BEGIN
IF (OBJECT_ID(N'[DBO].[PartitionAuditLog]',N'U')) IS NULL
BEGIN
CREATE TABLE PartitionAuditLog(
[StepNo] TINYINT IDENTITY(1,1),
[ActionPerformed] VARCHAR(200),
[TimeStamp] DATETIME DEFAULT getdate()
)
END
END


/*                                          
Identify dependants views and drop.
*/
DECLARE @schema_bound_views TABLE(viewName SYSNAME)
INSERT @schema_bound_views
SELECT schema_name(schema_id)+'.'+object_name(m.object_id) FROM sys.sql_modules m join sys.views v ON m.object_id = v.object_id
WHERE m.is_schema_bound = 1 ;

IF EXISTS(SELECT 1 FROM @schema_bound_views)
BEGIN
DECLARE @deleteViewStr NVARCHAR(200),@count TINYINT, @int TINYINT = 0, @viewName SYSNAME
SELECT @count = COUNT(*) FROM @schema_bound_views
WHILE @int < @Count
BEGIN
SELECT TOP 1 @viewName = viewName FROM @schema_bound_views
SET @deleteViewStr = 'DROP VIEW '+@viewName


IF @debug = 1
BEGIN
PRINT (@deleteViewStr)
END
ELSE 
BEGIN
EXEC (@deleteViewStr);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('Delete view '+@viewName);
END

DELETE @schema_bound_views WHERE viewName = @viewName
SET @int = @int + 1
END
END


/*                                          
Identify session log table and switch 
data to replica table.
*/

SELECT @loggingType = unicodeLogging FROM BPASysConfig

IF @loggingType = 0

BEGIN
SET @loggingTable = 'BPASessionLog_NonUnicode'
SET @CopySessionLogTbl = '


IF EXISTS (select 1 from sys.dm_db_partition_stats
where OBJECT_NAME(object_id) = '''+@loggingTable+''' and row_count > 0)
BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@loggingTable+'Copy'')
BEGIN
CREATE TABLE [dbo].['+@loggingTable +'Copy](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionnumber] [int] NOT NULL,
	[stageid] [uniqueidentifier] NULL,
	[stagename] [varchar](128) NULL,
	[stagetype] [int] NULL,
	[processname] [varchar](128) NULL,
	[pagename] [varchar](128) NULL,
	[objectname] [varchar](128) NULL,
	[actionname] [varchar](128) NULL,
	[result] [varchar](max) NULL,
	[resulttype] [int] NULL,
	[startdatetime] [datetime] NULL,
	[enddatetime] [datetime] NULL,
	[attributexml] [varchar](max) NULL,
	[automateworkingset] [bigint] NULL,
	[targetappname] [varchar](32) NULL,
	[targetappworkingset] [bigint] NULL,
	[starttimezoneoffset] [int] NULL,
	[endtimezoneoffset] [int] NULL,
	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
 CONSTRAINT [PK_'+@loggingTable +'Copy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


ALTER TABLE [dbo].[' +@loggingTable +'Copy]  WITH CHECK ADD  CONSTRAINT [FK_'+@loggingTable +'Copy_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[' +@loggingTable +'Copy] CHECK CONSTRAINT [FK_'+@loggingTable +'Copy_BPASession];


/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
CREATE NONCLUSTERED INDEX [Index_'+ @loggingTable +'Copy_sessionnumber] ON [dbo].[' +@loggingTable +'Copy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END
'

SET @switchCopySessionLog = 'ALTER TABLE [dbo].['+@loggingTable+'] SWITCH TO [dbo].['+@loggingTable +'Copy];'

END

ELSE

BEGIN
SET @loggingTable = 'BPASessionLog_Unicode'
SET @CopySessionLogTbl = '


IF EXISTS (select 1 from sys.dm_db_partition_stats
where OBJECT_NAME(object_id) = '''+@loggingTable+''' and row_count > 0)
BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@loggingTable+'Copy'')
BEGIN
CREATE TABLE [dbo].['+@loggingTable +'Copy](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionnumber] [int] NOT NULL,
	[stageid] [uniqueidentifier] NULL,
	[stagename] [nvarchar](128) NULL,
	[stagetype] [int] NULL,
	[processname] [nvarchar](128) NULL,
	[pagename] [nvarchar](128) NULL,
	[objectname] [nvarchar](128) NULL,
	[actionname] [nvarchar](128) NULL,
	[result] [nvarchar](max) NULL,
	[resulttype] [int] NULL,
	[startdatetime] [datetime] NULL,
	[enddatetime] [datetime] NULL,
	[attributexml] [nvarchar](max) NULL,
	[automateworkingset] [bigint] NULL,
	[targetappname] [nvarchar](32) NULL,
	[targetappworkingset] [bigint] NULL,
	[starttimezoneoffset] [int] NULL,
	[endtimezoneoffset] [int] NULL,
	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
 CONSTRAINT [PK_'+@loggingTable +'Copy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


ALTER TABLE [dbo].[' +@loggingTable +'Copy]  WITH CHECK ADD  CONSTRAINT [FK_'+@loggingTable +'Copy_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[' +@loggingTable +'Copy] CHECK CONSTRAINT [FK_'+@loggingTable +'Copy_BPASession];



/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
CREATE NONCLUSTERED INDEX [Index_'+ @loggingTable +'Copy_sessionnumber] ON [dbo].[' +@loggingTable +'Copy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END


DECLARE @csLogidMax BIGINT, @csLogidMin BIGINT
SELECT @csLogidMax = MAX(logid), @csLogidMin = MIN(logid) FROM [dbo].[' +@loggingTable +'Copy];

ALTER TABLE [dbo].[' +@loggingTable +'Copy]
ADD CONSTRAINT cslogid CHECK (logid >= @csLogidMin and logid < @csLogidMax) 

'

SET @switchCopySessionLog = 'ALTER TABLE [dbo].['+@loggingTable+'] SWITCH TO [dbo].['+@loggingTable +'Copy];'

END

IF @debug = 1
BEGIN
PRINT (@CopySessionLogTbl)
PRINT (@switchCopySessionLog)

END
ELSE
BEGIN
EXEC (@CopySessionLogTbl);
EXEC (@switchCopySessionLog)
END

END

/*2_Set check constraints for logid in copy session log table*/

BEGIN

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicodeCopy'
	ELSE SET @sessionlogtable = 'BPASessionLog_UnicodeCopy'

IF EXISTS(SELECT 1 FROM sys.partitions where OBJECT_NAME(object_id) = @sessionlogtable AND rows <> 0)
BEGIN
	SET @mxidStr = 'SELECT @mxid = MAX(logid), @mnid = MIN(logid) FROM [dbo].'+QUOTENAME(@sessionlogtable)+' with (nolock)'
	
	EXEC sp_executeSQL @mxidStr, N'@mxid BIGINT OUTPUT, @mnid BIGINT OUTPUT', @mxid = @mxidout OUTPUT,@mnid = @mnidout OUTPUT  ;
	
	SELECT @mxidout, @mnidout 
	SET @logidMax = @mxidout+1
SET @constraintStr = '
ALTER TABLE [dbo].'+QUOTENAME(@sessionlogtable)+'
ADD CONSTRAINT cslogid CHECK (logid >= '+CONVERT(NVARCHAR(50),@mnidout) + ' and logid < ' +CONVERT(NVARCHAR(50),@logidMax) +') '

--PRINT (@constraintStr)
EXEC  (@constraintStr)
END
END

/*3_Partition production session log table*/
BEGIN

SET NOCOUNT ON;


SELECT @loggingType = unicodeLogging FROM BPASysConfig

IF @loggingType = 0 
SET @sessionlogtable = 'dbo.BPASessionLog_NonUnicode'
ELSE SET @sessionlogtable = 'dbo.BPASessionLog_Unicode'

SET @strMaxLogid = 'select @maxlogid = max(logid) from ' +@sessionlogtable

EXEC sp_executeSQL @strMaxLogid, @params, @maxlogid = @maxlogidout OUTPUT;

IF @maxlogidout is null SET @nextPartitionID = 0 ELSE SET @nextPartitionID =  @maxlogidout


/**Create partition function and scheme **/

IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
SET @createPartitionFunction = 'CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES('+CONVERT(NVARCHAR(20),@nextPartitionID)+')'	

IF @debug = 1
BEGIN
PRINT (@createPartitionFunction)
END
ELSE
BEGIN
EXEC (@createPartitionFunction);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('Create Partition Function');
END

END
IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
SET @createPartitionScheme = 'CREATE PARTITION SCHEME [PS_Dynamic_NU] AS PARTITION PF_Dynamic_NU ALL TO ([PRIMARY])'

IF @debug = 1
BEGIN
PRINT (@createPartitionScheme)
END
ELSE
BEGIN
EXEC (@createPartitionScheme);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('Create Partition Scheme');
END

END
END


/*4_Switch data to partitioned production session log table*/

BEGIN

SELECT @loggingType = unicodeLogging FROM BPASysConfig

IF @loggingType = 0

BEGIN
SET @loggingTable = 'BPASessionLog_NonUnicode'
SET @CopySessionLogTable = 'BPASessionLog_NonUnicodeCopy'
END
ELSE
BEGIN
SET @loggingTable = 'BPASessionLog_Unicode'
SET @CopySessionLogTable = 'BPASessionLog_UnicodeCopy'
END

SET @switchSessionLogBack = 'ALTER TABLE DBO.'+QUOTENAME(@CopySessionLogTable) + ' SWITCH TO DBO.'+QUOTENAME(@loggingTable) +' PARTITION 1;'

EXEC (@switchSessionLogBack)

END
COMMIT TRANSACTION
SET XACT_ABORT OFF;