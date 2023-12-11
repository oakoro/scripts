CREATE PROCEDURE BPC.aasp_create_new_partition_BPASessionlog

AS

DECLARE @loggingType BIT, @sessionLogTable NVARCHAR(30),@tableExists BIT, @partitionExists BIT,@emptyTable BIT,
		@identifyViewStr NVARCHAR(300),@maxLogid BIGINT,@mxidStr NVARCHAR(400),@mxidout BIGINT,
		@mnidout BIGINT,@param NVARCHAR(255) = '@mxid BIGINT OUTPUT, @mnid BIGINT OUTPUT',
		@maxlogidout BIGINT,@params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT',
		@strMaxLogid NVARCHAR(400),@createPartitionFunction NVARCHAR(400),@createPartitionScheme NVARCHAR(400),
		@nextPartitionID BIGINT,@partitionseedValue BIGINT,@clusterindexpartition NVARCHAR(max), 
		@nonclusterindexpartition NVARCHAR(max),@sessionlogindex NVARCHAR(100),@logidMax BIGINT
			
SELECT @loggingType = unicodeLogging FROM BPASysConfig
--set @LoggingType = 1
		IF @LoggingType = 0
		SET @sessionlogtable = 'BPASessionLog_NonUnicode'
		ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

IF EXISTS(SELECT 1 FROM sys.partitions where OBJECT_NAME(object_id) = @sessionlogtable AND rows <> 0) 
BEGIN
SET @tableExists = 1 
SET @emptyTable = 0 
END
ELSE
BEGIN
SET @tableExists = 1 
SET @emptyTable = 1
END
 

IF @emptyTable = 0 AND @tableExists = 1
BEGIN 
PRINT 'Starting table partition of non empty session log table'

	DECLARE @CopySessionLogTbl NVARCHAR(MAX),
			@switchCopySessionLog NVARCHAR(MAX),
			@constraintStr NVARCHAR(400), 
			@CopySessionLogTable NVARCHAR(30),
			@switchSessionLogBack NVARCHAR(MAX),
			@deleteCopySessionLogTable NVARCHAR(200),
			@vsessionlogtable NVARCHAR(30)

/*STEP1_Identify dependants views and drop */
		DECLARE @schema_bound_views TABLE(viewName SYSNAME)
		 
		SET @vsessionlogtable = '%' + @sessionlogtable + '%'
		SET @identifyViewStr = '
		SELECT schema_name(schema_id)+''.''+object_name(m.object_id) FROM sys.sql_modules m join sys.views v ON m.object_id = v.object_id
		WHERE m.is_schema_bound = 1 AND definition like '''+@vsessionlogtable+''''

		INSERT @schema_bound_views
		EXEC (@identifyViewStr)

		IF EXISTS(SELECT 1 FROM @schema_bound_views)
		BEGIN
		DECLARE @deleteViewStr NVARCHAR(200),@count TINYINT, @int TINYINT = 0, @viewName SYSNAME
		SELECT @count = COUNT(*) FROM @schema_bound_views
		WHILE @int < @Count
		BEGIN
		SELECT TOP 1 @viewName = viewName FROM @schema_bound_views
		SET @deleteViewStr = 'DROP VIEW '+@viewName

		PRINT (@deleteViewStr)
		EXEC (@deleteViewStr);

		DELETE @schema_bound_views WHERE viewName = @viewName
		SET @int = @int + 1
		END
		END

/*STEP2_Switch production data to a copy table*/
		PRINT '---Switching production data to a copy table---'

SET @CopySessionLogTable = @sessionlogtable+'_Temp'
IF @loggingType = 0

		BEGIN
		
		SET @CopySessionLogTbl = '

		BEGIN
		IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@CopySessionLogTable+''')
		BEGIN
		CREATE TABLE [dbo].['+@CopySessionLogTable +'](
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
		CONSTRAINT [PK_'+@CopySessionLogTable +'] PRIMARY KEY CLUSTERED 
		(
		[logid] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

		ALTER TABLE [dbo].[' +@CopySessionLogTable +']  WITH CHECK ADD  CONSTRAINT [FK_'+@CopySessionLogTable +'_BPASession] FOREIGN KEY([sessionnumber])
		REFERENCES [dbo].[BPASession] ([sessionnumber]);

		ALTER TABLE [dbo].[' +@CopySessionLogTable +'] CHECK CONSTRAINT [FK_'+@CopySessionLogTable +'_BPASession];


		/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
		CREATE NONCLUSTERED INDEX [Index_'+ @CopySessionLogTable +'_sessionnumber] ON [dbo].[' +@CopySessionLogTable +']
		(
		[sessionnumber] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
		END

		ALTER TABLE [dbo].['+@SessionLogTable+'] SWITCH TO [dbo].['+@CopySessionLogTable +'];
		END'

		END

		ELSE

		BEGIN
		
		SET @CopySessionLogTbl = '

		BEGIN
		IF NOT EXISTS(SELECT 1 FROM sys.tables where name = '''+@CopySessionLogTable+''')
		BEGIN
		CREATE TABLE [dbo].['+@CopySessionLogTable +'](
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
		CONSTRAINT [PK_'+@CopySessionLogTable +'] PRIMARY KEY CLUSTERED 
		(
		[logid] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

		ALTER TABLE [dbo].[' +@CopySessionLogTable +']  WITH CHECK ADD  CONSTRAINT [FK_'+@CopySessionLogTable +'_BPASession] FOREIGN KEY([sessionnumber])
		REFERENCES [dbo].[BPASession] ([sessionnumber]);

		ALTER TABLE [dbo].[' +@CopySessionLogTable +'] CHECK CONSTRAINT [FK_'+@CopySessionLogTable +'_BPASession];


		/****** Object:  Index [Index_BPASessionLog_NonUnicodeCopy_sessionnumber]    Script Date: 27/03/2023 10:43:01 ******/
		CREATE NONCLUSTERED INDEX [Index_'+ @CopySessionLogTable +'_sessionnumber] ON [dbo].[' +@CopySessionLogTable +']
		(
		[sessionnumber] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
		END

		ALTER TABLE [dbo].['+@sessionlogtable+'] SWITCH TO [dbo].['+@CopySessionLogTable +'];
		END'

		END
--PRINT @CopySessionLogTbl
EXEC (@CopySessionLogTbl)
PRINT '---Switching production data to a copy table completed---'

/*STEP3_Create check constraints on copy session log table */
		BEGIN
		PRINT '---Creating check constraints on copy session log table---'
		
		IF EXISTS(SELECT 1 FROM sys.partitions where OBJECT_NAME(object_id) = @CopySessionLogTable AND rows <> 0)
		BEGIN
		SET @mxidStr = 'SELECT @mxid = MAX(logid), @mnid = MIN(logid) FROM [dbo].'+QUOTENAME(@CopySessionLogTable)+' with (nolock)'
	
		EXEC sp_executeSQL @mxidStr, N'@mxid BIGINT OUTPUT, @mnid BIGINT OUTPUT', @mxid = @mxidout OUTPUT,@mnid = @mnidout OUTPUT  ;
	
		SET @logidMax = @mxidout + 1
		SET @constraintStr = '
		ALTER TABLE [dbo].'+QUOTENAME(@CopySessionLogTable)+'
		ADD CONSTRAINT cslogid CHECK (logid >= '+CONVERT(NVARCHAR(50),@mnidout) + ' and logid < ' +CONVERT(NVARCHAR(50),@logidMax) +') '

		--select @mnidout'@mnidout',@mxidout'@mxidout',@logidMax'@logidMax'
		EXEC  (@constraintStr)
		--PRINT (@constraintStr)
		END
		PRINT '---Creating check constraints on copy session log table completed---'
		END

/*STEP4_Create partition function*/
		BEGIN 
		PRINT '---Creating partition function and scheme---'



		SET @strMaxLogid = 'select @maxlogid = max(logid) from ' +@CopySessionLogTable

		EXEC sp_executeSQL @strMaxLogid, @params, @maxlogid = @maxlogidout OUTPUT;


		IF @maxlogidout IS NULL SET @nextPartitionID = 0 ELSE SET @nextPartitionID =  @maxlogidout + 1
		--select @nextPartitionID'@nextPartitionID'

		IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
		BEGIN
		SET @createPartitionFunction = 'CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES('+CONVERT(NVARCHAR(50),@nextPartitionID)+')'	

		EXEC (@createPartitionFunction);

		END
		END

PRINT 'Completed table partition of non empty session log table'
END

IF @emptyTable = 1 AND @tableExists = 1
/*STEP4_Create partition function for empty partition table*/
BEGIN 
		PRINT '---Creating partition function and scheme---'



		SET @strMaxLogid = 'select @maxlogid = max(logid) from ' +@SessionLogTable

		EXEC sp_executeSQL @strMaxLogid, @params, @maxlogid = @maxlogidout OUTPUT;


		IF @maxlogidout IS NULL SET @nextPartitionID = 1 ELSE SET @nextPartitionID =  @maxlogidout + 1
		--select @nextPartitionID'@nextPartitionID'

		IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
		BEGIN
		SET @createPartitionFunction = 'CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES('+CONVERT(NVARCHAR(50),@nextPartitionID)+')'	

		EXEC (@createPartitionFunction);

		END
END

/*STEP5_Create partition scheme*/
IF @tableExists = 1
BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
		SET @createPartitionScheme = 'CREATE PARTITION SCHEME [PS_Dynamic_NU] AS PARTITION PF_Dynamic_NU ALL TO ([PRIMARY])'

		EXEC (@createPartitionScheme);

		PRINT '---Creating partition function and scheme completed---'
END

/*STEP5_Partition production session log table*/
BEGIN 
	
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

			EXEC (@clusterindexpartition)
		END
		FETCH NEXT FROM PartitionSessionLogTable INTO @sessionlogindex
		END

		CLOSE PartitionSessionLogTable
		DEALLOCATE PartitionSessionLogTable
		PRINT '---Partitioning production session log table completed and delete copy table---'
END
END


/*STEP6_Switch session log data back to production table and delete copy table*/
IF @emptyTable = 0
BEGIN 
		PRINT '---Switching session log data back to production table---'

		SET @switchSessionLogBack = 'ALTER TABLE DBO.'+QUOTENAME(@CopySessionLogTable) + ' SWITCH TO DBO.'+QUOTENAME(@SessionLogTable) +' PARTITION 1;'
		EXEC (@switchSessionLogBack)

		SET @deleteCopySessionLogTable = 'IF NOT EXISTS(SELECT 1 FROM DBO.'+QUOTENAME(@CopySessionLogTable)+')
		DROP TABLE DBO.'+QUOTENAME(@CopySessionLogTable)+';'
		EXEC (@deleteCopySessionLogTable)
PRINT '---Switching session log data back to production table and delete copy table completed---'
END
--select @sessionlogtable
IF (SELECT TOP (1) ps.name AS [Partition Scheme] FROM sys.tables t INNER JOIN sys.indexes i ON t.object_id = i.object_id AND i.type IN (0,1) INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name in ('BPASessionLog_NonUnicode')) = 'PS_Dynamic_NU'
BEGIN
Select @sessionlogtable+' Successfully Partitioned' as Results;
END
ELSE 
Select @sessionlogtable+' Partitioning Failed'  as Results;



