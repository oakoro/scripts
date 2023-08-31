select top 1 logid from [dbo].[BPASessionLog_NonUnicode]
where logid > 330000000
--go
--select top 1 logid from [dbo].[BPASessionLog_NonUnicode]
----where logid > 330000000 
--order by logid

EXEC [BPC].[adfsp_get_minlogidTestOA] 'BPASessionLog_NonUnicode'


-- ==============================================================================
-- Description: Get minimum logid to copy
-- Usage: EXEC [BPC].[adfsp_get_minlogid] 'BPASessionLog_NonUnicode'
-- ==============================================================================

declare
	 @tableName NVARCHAR(255) = 'BPASessionLog_NonUnicode'




DECLARE @sqlCommandWM NVARCHAR(1000),
	@ParmDefinition NVARCHAR(500),
	@minlogidWM NVARCHAR(20),
	@minlogidWMOUT BIGINT,
	@sqlCommandActual NVARCHAR(1000),
	@ParmDefinition1 NVARCHAR(500),
	@minlogidActual BIGINT,
	@minlogidActualOUT BIGINT,
	@minLogid BIGINT


SET @sqlCommandWM = N'SELECT @minlogidWM = logid  FROM bpc.adf_watermark WHERE tableName = ''' + @tableName + ''';'
SET @ParmDefinition = N'@tableName NVARCHAR(255), @minlogidWM BIGINT OUTPUT';
EXEC sp_EXECutesql @sqlCommandWM, @ParmDefinition, @tableName = @tableName, @minlogidWM = @minlogidWMOUT OUTPUT;
select @minlogidWMOUT '@minlogidWMOUT'


SET @sqlCommandActual = N'SELECT TOP 1 @minlogidActual = logid FROM dbo.'+@tableName +' WITH (nolock) WHERE logid > '+CONVERT(NVARCHAR(20),@minlogidWMOUT) +' ORDER BY logid'
SET @ParmDefinition1 = N'@tableName NVARCHAR(255), @minlogidActual BIGINT OUTPUT';
EXEC sp_EXECutesql @sqlCommandActual, @ParmDefinition1, @tableName = @tableName, @minlogidActual = @minlogidActualOUT OUTPUT;
select @minlogidActualOUT '@minlogidActualOUT'

IF @minlogidActualOUT > @minlogidWMOUT
BEGIN
SELECT @minlogidActualOUT AS 'minlogid'
END
ELSE
SELECT @minlogidWMOUT AS 'minlogid'
GO


