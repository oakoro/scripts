-- ==============================================================================
-- Description: Get minimum logid to copy
-- Usage: [BPC].[adfsp_get_minlogidTestOA] 'BPASessionLog_NonUnicode'
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_get_minlogidTestOA] 
	 @tableName NVARCHAR(255)


AS

DECLARE @sqlCommandWM NVARCHAR(1000),
	@ParmDefinition NVARCHAR(500),
	@minlogidWM NVARCHAR(20),
	@minlogidWMOUT BIGINT,
	@sqlCommandActual NVARCHAR(1000),
	@ParmDefinition1 NVARCHAR(500),
	@minlogidActual BIGINT,
	@minlogidActualOUT BIGINT,
	@minLogid BIGINT


SET @sqlCommandWM = N'SELECT @minlogidWM = logid  FROM bpc.adf_watermark where tableName = ''' + @tableName + ''';'
SET @ParmDefinition = N'@tableName varchar(255), @minlogidWM BIGINT OUTPUT';
EXEC sp_EXECutesql @sqlCommandWM, @ParmDefinition, @tableName = @tableName, @minlogidWM = @minlogidWMOUT OUTPUT;



SET @sqlCommandActual = N'SELECT top 1 @minlogidActual = logid from dbo.'+@tableName +' with (nolock) where logid > '+CONVERT(NVARCHAR(20),@minlogidWMOUT)
SET @ParmDefinition1 = N'@tableName varchar(255), @minlogidActual BIGINT OUTPUT';
EXEC sp_EXECutesql @sqlCommandActual, @ParmDefinition1, @tableName = @tableName, @minlogidActual = @minlogidActualOUT OUTPUT;


IF @minlogidActualOUT > @minlogidWMOUT
BEGIN
SELECT @minlogidActualOUT AS 'minlogid'
END
ELSE
SELECT @minlogidWMOUT AS 'minlogid'
