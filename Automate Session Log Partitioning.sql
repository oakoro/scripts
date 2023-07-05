BEGIN TRY
SET NOCOUNT ON
DECLARE @LoggingType BIT, @LoggingTable NVARCHAR(30),
	@CreateSessionLogCopy NVARCHAR(MAX), @Varchar_unicode CHAR(1) = 'n'
DECLARE @schema_bound_views TABLE(viewName SYSNAME)
INSERT @schema_bound_views
SELECT object_name(m.object_id) FROM sys.sql_modules m join sys.views v ON m.object_id = v.object_id
where m.is_schema_bound = 1 

IF EXISTS(SELECT 1 FROM @schema_bound_views)
BEGIN
DECLARE @str NVARCHAR(200),@count TINYINT, @int TINYINT = 0, @view SYSNAME
SELECT @count = count(*) FROM @schema_bound_views
WHILE @int < @count
BEGIN
SELECT TOP 1 @view = viewName FROM @schema_bound_views
SET @str = 'DROP VIEW '+@view
print (@str)
DELETE @schema_bound_views WHERE viewName = @view
SET @int = @int + 1
END
END

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
IF @LoggingType = 0
SET @LoggingTable = 'BPASessionLog_NonUnicode'
ELSE SET @LoggingTable ='BPASessionLog_Unicode'
/* Create [dbo].[BPASessionLog_NonUnicodeCopy] Table for Switch */
SET @CreateSessionLogCopy =
'IF EXISTS (select 1 from sys.dm_db_partition_stats
where OBJECT_NAME(object_id) = '''+@LoggingTable+''' and row_count > 0)
BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@LoggingTable+'Copy'')
BEGIN
CREATE TABLE [dbo].['+@LoggingTable +'Copy](
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
 CONSTRAINT [PK_'+@LoggingTable +'Copy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


ALTER TABLE [dbo].[' +@LoggingTable +'Copy]  WITH CHECK ADD  CONSTRAINT [FK_'+@LoggingTable +'Copy_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[' +@LoggingTable +'Copy] CHECK CONSTRAINT [FK_'+@LoggingTable +'Copy_BPASession];



/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
CREATE NONCLUSTERED INDEX [Index_'+ @LoggingTable +'Copy_sessionnumber] ON [dbo].[' +@LoggingTable +'Copy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END
ELSE
BEGIN
CREATE TABLE [dbo].['+@LoggingTable +'Copy](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionnumber] [int] NOT NULL,
	[stageid] [uniqueidentifier] NULL,
	[stagename] [' +@Varchar_unicode +'varchar](128) NULL,
	[stagetype] [int] NULL,
	[processname] [' +@Varchar_unicode +'varchar](128) NULL,
	[pagename] [' +@Varchar_unicode +'varchar](128) NULL,
	[objectname] [' +@Varchar_unicode +'varchar](128) NULL,
	[actionname] [' +@Varchar_unicode +'varchar](128) NULL,
	[result] [' +@Varchar_unicode +'varchar](max) NULL,
	[resulttype] [int] NULL,
	[startdatetime] [datetime] NULL,
	[enddatetime] [datetime] NULL,
	[attributexml] [' +@Varchar_unicode +'varchar](max) NULL,
	[automateworkingset] [bigint] NULL,
	[targetappname] [' +@Varchar_unicode +'varchar](32) NULL,
	[targetappworkingset] [bigint] NULL,
	[starttimezoneoffset] [int] NULL,
	[endtimezoneoffset] [int] NULL,
	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
 CONSTRAINT [PK_'+@LoggingTable +'Copy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


ALTER TABLE [dbo].[' +@LoggingTable +'Copy]  WITH CHECK ADD  CONSTRAINT [FK_'+@LoggingTable +'Copy_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[' +@LoggingTable +'Copy] CHECK CONSTRAINT [FK_'+@LoggingTable +'Copy_BPASession];



/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
CREATE NONCLUSTERED INDEX [Index_'+ @LoggingTable +'Copy_sessionnumber] ON [dbo].[' +@LoggingTable +'Copy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END
END
END'
print (@CreateSessionLogCopy)
--exec (@CreateSessionLogCopy)
/**Switch data from BPASessionLog_NonUnicode to BPASessionLog_NonUnicodeCopy**/
--ALTER TABLE [dbo].[BPASessionLog_NonUnicode] SWITCH TO [dbo].[BPASessionLog_NonUnicodeCopy];

--SET IDENTITY_INSERT [dbo].[BPASessionLog_NonUnicode] ON
--INSERT INTO [dbo].[BPASessionLog_NonUnicode]
--           ([logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset])
-- SELECT	TOP 1	[logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset]
--FROM [dbo].[BPASessionLog_NonUnicodeCopy] WITH (NOLOCK)
--ORDER BY logid DESC
--SET IDENTITY_INSERT [dbo].[BPASessionLog_NonUnicodeRetain] OFF


END TRY

BEGIN CATCH
SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH