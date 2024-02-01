DECLARE @loggingType BIT, @sessionLogTable NVARCHAR(30),@maxLogid BIGINT,@mxidStr NVARCHAR(400),@mxidout BIGINT,
		@param NVARCHAR(255) = '@mxid BIGINT OUTPUT',@maxlogidout BIGINT,@params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT',
		@strMaxLogid NVARCHAR(400),@copyStatus BIT,@copiedMax BIGINT, @copyDiff BIGINT,@totalRowCount BIGINT, @PartitionStatus BIT

SELECT @loggingType = unicodeLogging FROM BPASysConfig

		IF @LoggingType = 0
		SET @sessionlogtable = 'BPASessionLog_NonUnicode'
		ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SELECT @totalRowCount = SUM(rows) FROM sys.partitions
WHERE object_name(object_id) = @SessionLogTable and index_id = 1

/***Check session log copy status***/
IF OBJECT_ID (N'BPC.adf_watermark', N'U') IS NOT NULL 
BEGIN
SET @mxidStr = 'SELECT @mxid = MAX(logid) FROM [dbo].'+QUOTENAME(@SessionLogTable)+' WITH (NOLOCK)'
EXEC sp_executeSQL @mxidStr, N'@mxid BIGINT OUTPUT', @mxid = @mxidout OUTPUT  
SELECT @copiedMax = logid  FROM BPC.adf_watermark where tablename = @SessionLogTable

SELECT @copyDiff = (ISNULL(@mxidout,0) - @copiedMax)

		IF @copyDiff between 0 and 10000000
		BEGIN
		SET @copyStatus = 1  
		END
		ELSE SET @copyStatus = 0 

END
ELSE 
SELECT @copyStatus = 0, @copyDiff =  ISNULL(@totalRowCount,0) 

/****Check session log partition status****/
BEGIN
IF EXISTS(SELECT 1 FROM sys.indexes i INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id
			WHERE OBJECT_NAME(i.OBJECT_ID) = @sessionlogtable) 
		SET @PartitionStatus = 1
		ELSE
		SET @PartitionStatus = 0
		END

/***Output report***/
SELECT ISNULL(@copyStatus,0) 'CopyStatus', ISNULL(@totalRowCount,0) 'TotalSessionLogCount',ISNULL(@copyDiff,0) 'CopyDifference',@PartitionStatus 'PartitionStatus'












