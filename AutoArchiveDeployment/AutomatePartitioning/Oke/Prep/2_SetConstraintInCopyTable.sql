DECLARE  @maxLogid BIGINT, @LoggingType BIT,
			@sessionlogtable NVARCHAR(50), @mxidStr NVARCHAR(400),
			@mxidout BIGINT, @mnidout BIGINT, @param NVARCHAR(255) = '@mxid BIGINT OUTPUT, @mnid BIGINT OUTPUT',
			@constraintStr NVARCHAR(400), @logidMax BIGINT
	

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicodeCopy'
	ELSE SET @sessionlogtable = 'BPASessionLog_UnicodeCopy'

IF EXISTS(SELECT 1 FROM sys.partitions where OBJECT_NAME(object_id) = @sessionlogtable AND rows <> 0)
BEGIN
	SET @mxidStr = 'SELECT @mxid = MAX(logid), @mnid = MIN(logid) FROM [dbo].'+QUOTENAME(@sessionlogtable)+' with (nolock)'
	
	EXEC sp_executeSQL @mxidStr, N'@mxid BIGINT OUTPUT, @mnid BIGINT OUTPUT', @mxid = @mxidout OUTPUT,@mnid = @mnidout OUTPUT  ;
	
	
	SET @logidMax = @mxidout+1
SET @constraintStr = '
ALTER TABLE [dbo].'+QUOTENAME(@sessionlogtable)+'
ADD CONSTRAINT cslogid CHECK (logid >= '+CONVERT(NVARCHAR(50),@mnidout) + ' and logid < ' +CONVERT(NVARCHAR(50),@logidMax) +') '

EXEC  (@constraintStr)
END












