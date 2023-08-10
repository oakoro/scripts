/*
Drop schema bound view
Create copy of session log table
Get session log table ready for partitioning
Set @debug = 1 to print out script
*/
SET NOCOUNT ON
DECLARE @loggingType BIT, 
	--@loggingTableNonUnicode NVARCHAR(30) = 'BPASessionLog_NonUnicode',
	--@loggingTableUnicode NVARCHAR(30) = 'BPASessionLog_Unicode',
	@loggingTable NVARCHAR(30),
	@switchCopySessionLog NVARCHAR(MAX),
	@debug BIT = 1
	
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
--SET @LoggingType = 1 --Test for Unicode
IF @loggingType = 0



BEGIN
SET @loggingTable = 'BPASessionLog_Unicode' 


SET @switchCopySessionLog =
'
BEGIN TRAN
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

ALTER TABLE [dbo].['+@loggingTable+'] SWITCH TO [dbo].['+@loggingTable +'Copy];

END
COMMIT TRAN'



END

ELSE

BEGIN

SET @loggingTable = 'BPASessionLog_NonUnicode'


SET @switchCopySessionLog = 
'
BEGIN TRAN
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

ALTER TABLE [dbo].['+@loggingTable+'] SWITCH TO [dbo].['+@loggingTable +'Copy];


END
COMMIT TRAN'



END

IF @debug = 1
BEGIN
PRINT (@switchCopySessionLog)
END
ELSE
BEGIN
EXEC (@switchCopySessionLog);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('SessionLogTable is '+ @loggingTable);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES(@loggingTable +'Copy Created');

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('Data moved to ' +@loggingTable +'Copy');
END