SET NOCOUNT ON
DECLARE @LoggingType BIT, 
	@LoggingTableNonUnicode NVARCHAR(30) = 'BPASessionLog_NonUnicode',
	@LoggingTableUnicode NVARCHAR(30) = 'BPASessionLog_Unicode',
	@SwitchCopySessionLog NVARCHAR(MAX)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
--SET @LoggingType = 1 --Test for Unicode
IF @LoggingType = 0

/* Create [dbo].[BPASessionLog_NonUnicodeCopy] Table for Switch */

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
END
COMMIT TRAN'


ELSE

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

END
COMMIT TRAN'


print (@SwitchCopySessionLog)