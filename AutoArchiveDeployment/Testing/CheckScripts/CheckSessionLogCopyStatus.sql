DECLARE @loggingType BIT, @sessionLogTable NVARCHAR(30),@maxLogid BIGINT,@mxidStr NVARCHAR(400),@mxidout BIGINT,
		@param NVARCHAR(255) = '@mxid BIGINT OUTPUT',@maxlogidout BIGINT,@params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT',
		@strMaxLogid NVARCHAR(400),@copyStatus NVARCHAR(50),@copiedMax BIGINT, @copyDiff BIGINT,@totalRowCount BIGINT

SELECT @loggingType = unicodeLogging FROM BPASysConfig

		IF @LoggingType = 0
		SET @sessionlogtable = 'BPASessionLog_NonUnicode'
		ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SELECT @totalRowCount = SUM(rows) FROM sys.partitions
WHERE object_name(object_id) = @SessionLogTable and index_id = 1

IF OBJECT_ID (N'BPC.adf_watermark', N'U') IS NOT NULL 
BEGIN
SET @mxidStr = 'SELECT @mxid = MAX(logid) FROM [dbo].'+QUOTENAME(@SessionLogTable)+' WITH (NOLOCK)'
EXEC sp_executeSQL @mxidStr, N'@mxid BIGINT OUTPUT', @mxid = @mxidout OUTPUT  
SELECT @copiedMax = logid  FROM BPC.adf_watermark where tablename = @SessionLogTable

SELECT @copyDiff = (@mxidout - @copiedMax)

	IF @copyDiff between 0 and 10000000
	BEGIN
	SELECT @copyStatus = 'Data Vault Uptodate'  
	END
	ELSE SELECT @copyStatus = 'Data Vault Not-Uptodate' 

END
ELSE 
SELECT @copyStatus = 'Data Vault Not Deployed', @copyDiff =  ISNULL(@totalRowCount,0) 

SELECT @@SERVERNAME 'DBServerName',DB_NAME()'DBName', ISNULL(@copyStatus,0) 'CopyStatus', 
ISNULL(@totalRowCount,0) 'TotalSessionLogCount',ISNULL(@copyDiff,0) 'CopyDifference'








