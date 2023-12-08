DECLARE @loggingType BIT, @sessionlogtable NVARCHAR(50), @maxLogidOut BIGINT,@copiedLogid BIGINT,
		@maxlogidstr NVARCHAR(100), @pardef NVARCHAR(100) = N'@maxLogid NVARCHAR(50) OUTPUT'

SELECT @loggingType = unicodeLogging FROM DBO.BPASysConfig
	
	IF @loggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

IF (select object_id('BPC.adf_watermark','U')) IS NOT NULL
BEGIN
	 SELECT @copiedLogid = logid FROM [BPC].[adf_watermark] WHERE tablename = @sessionlogtable
	 SET @maxlogidstr = 'SELECT @maxLogid = MAX(logid) FROM DBO.'+ QUOTENAME(@sessionlogtable) +' WITH (NOLOCK)'
	 EXEC sp_executesql  @maxlogidstr, @pardef, @maxLogid = @maxLogidOut OUTPUT
 
	 SELECT @@servername AS 'serverName',
			@maxLogidOut AS maxLogid, 
			@copiedLogid AS copiedLogid, 
			(@maxLogidOut -  @copiedLogid) AS tobeCopied,
			GETDATE() AS '	reportDate'
END
ELSE
BEGIN
	 SET @copiedLogid = 0
	 SET @maxlogidstr = 'SELECT @maxLogid = MAX(logid) FROM DBO.'+ QUOTENAME(@sessionlogtable) +' WITH (NOLOCK)'
	 EXEC sp_executesql  @maxlogidstr, @pardef, @maxLogid = @maxLogidOut OUTPUT
 
	 SELECT @@servername AS 'serverName',
			@maxLogidOut AS maxLogid, 
			@copiedLogid AS copiedLogid, 
			(@maxLogidOut -  @copiedLogid) AS tobeCopied,
			GETDATE() AS '	reportDate'
END