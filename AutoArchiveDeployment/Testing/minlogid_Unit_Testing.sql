DECLARE  @tableName varchar(255) = 'BPASessionLog_NonUnicode'
--SELECT logid as 'minlogidWMark' FROM bpc.adf_watermark where tableName = @tableName
--SELECT top 1 logid 'ActualMinLogid' 
--from
--dbo.BPASessionLog_NonUnicode with (nolock) 
 
--order by logid 

DECLARE @sqlCommand NVARCHAR(1000),
	@ParmDefinition NVARCHAR(500),
	@minlogidWM NVARCHAR(20),
	@minlogidWMOUT BIGINT,
	@sqlCommand1 NVARCHAR(1000),
	@ParmDefinition1 NVARCHAR(500),
	@minlogidActual BIGINT,
	@minlogidActualOUT BIGINT,
	@minLogid BIGINT

--SET @sqlCommand = N'SELECT logid as ''minlogidWMark'' FROM bpc.adf_watermark where tableName = ''' + @tableName + ''';'
SET @sqlCommand = N'SELECT @minlogidWM = logid  FROM bpc.adf_watermark where tableName = ''' + @tableName + ''';'
SET @ParmDefinition = N'@tableName varchar(255), @minlogidWM BIGINT OUTPUT';
EXEC sp_EXECutesql @sqlCommand, @ParmDefinition, @tableName = @tableName, @minlogidWM = @minlogidWMOUT OUTPUT;
SELECT @minlogidWMOUT '@minlogidWMOUT'
--DECLARE @a BIGINT
--SELECT top 1 @a = logid   from dbo.BPASessionLog_NonUnicode with (nolock) where logid > 320000000
--SELECT @a

SET @sqlCommand1 = N'SELECT top 1 @minlogidActual = logid from dbo.'+@tableName +' with (nolock) where logid > '+CONVERT(NVARCHAR(20),@minlogidWMOUT)
SET @ParmDefinition1 = N'@tableName varchar(255), @minlogidActual BIGINT OUTPUT';
EXEC sp_EXECutesql @sqlCommand1, @ParmDefinition1, @tableName = @tableName, @minlogidActual = @minlogidActualOUT OUTPUT;
SELECT @minlogidActualOUT '@minlogidActualOUT'

IF @minlogidActualOUT > @minlogidWMOUT
BEGIN
SELECT @minlogidActualOUT as 'minlogid'
END
ELSE
SELECT @minlogidWMOUT as 'minlogid'
