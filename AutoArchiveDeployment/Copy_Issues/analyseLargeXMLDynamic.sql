
DECLARE @sumDataSize BIGINT,@status BIT, @minLogid BIGINT = 7, 
		@maxLogid BIGINT = 12, @xmlDataThreshold BIGINT,
		@LoggingType BIT, @sessionlogtable NVARCHAR(50),
		@sqlCommandActual NVARCHAR(1000), @ParmDefinition1 NVARCHAR(500),
		@sumDataSizeOUT NVARCHAR(50)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'


SET NOCOUNT ON
BEGIN
SET @sqlCommandActual = N'SELECT @sumDataSize  = SUM( 
	ISNULL(DATALENGTH([result]), 1)+ISNULL(DATALENGTH([attributexml]), 1) ) FROM dbo.'+@sessionlogtable +' WITH (NOLOCK)
	WHERE logid BETWEEN '+CONVERT(NVARCHAR(50),@minLogid)+ ' AND '+CONVERT(NVARCHAR(50),@maxLogid)+';'
SET @ParmDefinition1 = N'@sessionlogtable NVARCHAR(255), @sumDataSize BIGINT OUTPUT';

EXEC sp_executesql @sqlCommandActual, @ParmDefinition1, @sessionlogtable = @sessionlogtable, @sumDataSize = @sumDataSizeOUT OUTPUT;
SELECT @sumDataSizeOUT

IF ISNULL(@sumDataSizeOUT,0) <= @xmlDataThreshold SET @status = 0 ELSE SET @status = 1
SELECT @status AS 'DataSizeStatus'
END






SET NOCOUNT OFF
GO

