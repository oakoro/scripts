/*
Drop schema bound view
Create copy of session log table
Get session log table ready for partitioning
*/
SET NOCOUNT ON
DECLARE @LoggingType BIT, 
	@LoggingTableNonUnicode NVARCHAR(30) = 'BPASessionLog_NonUnicode',
	@LoggingTableUnicode NVARCHAR(30) = 'BPASessionLog_Unicode',
	@SwitchCopySessionLog NVARCHAR(MAX),
	@CopyStartLogid BIGINT = 20

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

/*                                          
Identify dependants views and drop.
*/
DECLARE @schema_bound_views TABLE(viewName SYSNAME)
INSERT @schema_bound_views
SELECT object_name(m.object_id) FROM sys.sql_modules m join sys.views v ON m.object_id = v.object_id
WHERE m.is_schema_bound = 1 ;

IF EXISTS(SELECT 1 FROM @schema_bound_views)
BEGIN
DECLARE @str NVARCHAR(200),@count TINYINT, @int TINYINT = 0, @view SYSNAME
SELECT @count = count(*) FROM @schema_bound_views
WHILE @int < @count
BEGIN
SELECT TOP 1 @view = viewName FROM @schema_bound_views
SET @str = 'DROP VIEW '+@view

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES(@str);

print (@str)
--EXEC (@str)
DELETE @schema_bound_views WHERE viewName = @view
SET @int = @int + 1
END
END

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
SET @LoggingType = 1 --Test for Unicode
IF @LoggingType = 0

/* Create [dbo].[BPASessionLog_NonUnicodeCopy] Table for Switch */

BEGIN
INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('SessionLogTable is '+ @LoggingTableNonUnicode);

SET @SwitchCopySessionLog =
'
BEGIN TRAN
IF EXISTS (select 1 from sys.dm_db_partition_stats
where OBJECT_NAME(object_id) = '''+@LoggingTableNonUnicode+''' and row_count > 0)
BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@LoggingTableNonUnicode+'Copy'')
BEGIN
CREATE TABLE [dbo].['+@LoggingTableNonUnicode +'Copy](
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
 CONSTRAINT [PK_'+@LoggingTableNonUnicode +'Copy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


ALTER TABLE [dbo].[' +@LoggingTableNonUnicode +'Copy]  WITH CHECK ADD  CONSTRAINT [FK_'+@LoggingTableNonUnicode +'Copy_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[' +@LoggingTableNonUnicode +'Copy] CHECK CONSTRAINT [FK_'+@LoggingTableNonUnicode +'Copy_BPASession];



/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
CREATE NONCLUSTERED INDEX [Index_'+ @LoggingTableNonUnicode +'Copy_sessionnumber] ON [dbo].[' +@LoggingTableNonUnicode +'Copy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END
ALTER TABLE [dbo].['+@LoggingTableNonUnicode+'] SWITCH TO [dbo].['+@LoggingTableNonUnicode +'Copy];

SET IDENTITY_INSERT [dbo].[' +@LoggingTableNonUnicode +'] ON
INSERT INTO [dbo].[' +@LoggingTableNonUnicode +']
           ([logid]
		   ,[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset])
 SELECT		[logid]
		   ,[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset]
FROM [dbo].[' +@LoggingTableNonUnicode +'Copy] WITH (NOLOCK)
WHERE LOGID >= '+CONVERT(NVARCHAR(20),@CopyStartLogid) +
' ORDER BY logid DESC
SET IDENTITY_INSERT [dbo].[' +@LoggingTableNonUnicode +'] OFF
END
COMMIT TRAN'
END

ELSE

BEGIN
INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('SessionLogTable is '+ @LoggingTableUnicode);

SET @SwitchCopySessionLog = 
'
BEGIN TRAN
IF EXISTS (select 1 from sys.dm_db_partition_stats
where OBJECT_NAME(object_id) = '''+@LoggingTableUnicode+''' and row_count > 0)
BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@LoggingTableUnicode+'Copy'')
BEGIN
CREATE TABLE [dbo].['+@LoggingTableUnicode +'Copy](
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
 CONSTRAINT [PK_'+@LoggingTableUnicode +'Copy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


ALTER TABLE [dbo].[' +@LoggingTableUnicode +'Copy]  WITH CHECK ADD  CONSTRAINT [FK_'+@LoggingTableUnicode +'Copy_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[' +@LoggingTableUnicode +'Copy] CHECK CONSTRAINT [FK_'+@LoggingTableUnicode +'Copy_BPASession];



/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
CREATE NONCLUSTERED INDEX [Index_'+ @LoggingTableUnicode +'Copy_sessionnumber] ON [dbo].[' +@LoggingTableUnicode +'Copy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END
ALTER TABLE [dbo].['+@LoggingTableUnicode+'] SWITCH TO [dbo].['+@LoggingTableUnicode +'Copy];

SET IDENTITY_INSERT [dbo].[' +@LoggingTableUnicode +'] ON
INSERT INTO [dbo].[' +@LoggingTableUnicode +']
           ([logid]
		   ,[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset])
 SELECT		[logid]
		   ,[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset]
FROM [dbo].[' +@LoggingTableUnicode +'Copy] WITH (NOLOCK)
WHERE LOGID >= '+CONVERT(NVARCHAR(20),@CopyStartLogid) +
' ORDER BY logid DESC
SET IDENTITY_INSERT [dbo].[' +@LoggingTableUnicode +'] OFF
END
COMMIT TRAN'
END

print (@SwitchCopySessionLog)
--EXEC (@SwitchCopySessionLog)




