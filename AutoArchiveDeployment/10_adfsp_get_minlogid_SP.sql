/****** Create [BPC].[adfsp_get_minlogid] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[adfsp_get_minlogid]',N'P')) IS NULL
BEGIN
DECLARE @adfsp_get_minlogid NVARCHAR(MAX) = '
-- ==============================================================================
-- Description: Get minimum logid to copy
-- Usage: EXEC [BPC].[adfsp_get_minlogid] ''BPASessionLog_NonUnicode''
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_get_minlogid]
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


SET @sqlCommandWM = N''SELECT @minlogidWM = logid  FROM bpc.adf_watermark WHERE tableName = '''''' + @tableName + '''''';''
SET @ParmDefinition = N''@tableName NVARCHAR(255), @minlogidWM BIGINT OUTPUT'';
EXEC sp_EXECutesql @sqlCommandWM, @ParmDefinition, @tableName = @tableName, @minlogidWM = @minlogidWMOUT OUTPUT;



SET @sqlCommandActual = N''SELECT TOP 1 @minlogidActual = logid FROM dbo.''+@tableName +'' WITH (nolock) WHERE logid > ''+CONVERT(NVARCHAR(20),@minlogidWMOUT) +'' ORDER BY logid''
SET @ParmDefinition1 = N''@tableName NVARCHAR(255), @minlogidActual BIGINT OUTPUT'';
EXEC sp_EXECutesql @sqlCommandActual, @ParmDefinition1, @tableName = @tableName, @minlogidActual = @minlogidActualOUT OUTPUT;


IF @minlogidActualOUT > @minlogidWMOUT
BEGIN
SELECT @minlogidActualOUT AS ''minlogid''
END
ELSE
SELECT @minlogidWMOUT AS ''minlogid'''

EXECUTE SP_EXECUTESQL @adfsp_get_minlogid
END
ELSE
BEGIN
DECLARE @alter_adfsp_get_minlogid NVARCHAR(MAX) = '
-- ==============================================================================
-- Description: Get minimum logid to copy
-- Usage: EXEC [BPC].[adfsp_get_minlogid] ''BPASessionLog_NonUnicode''
-- ==============================================================================

ALTER PROCEDURE [BPC].[adfsp_get_minlogid]
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


SET @sqlCommandWM = N''SELECT @minlogidWM = logid  FROM bpc.adf_watermark WHERE tableName = '''''' + @tableName + '''''';''
SET @ParmDefinition = N''@tableName NVARCHAR(255), @minlogidWM BIGINT OUTPUT'';
EXEC sp_EXECutesql @sqlCommandWM, @ParmDefinition, @tableName = @tableName, @minlogidWM = @minlogidWMOUT OUTPUT;



SET @sqlCommandActual = N''SELECT TOP 1 @minlogidActual = logid FROM dbo.''+@tableName +'' WITH (nolock) WHERE logid > ''+CONVERT(NVARCHAR(20),@minlogidWMOUT) +'' ORDER BY logid''
SET @ParmDefinition1 = N''@tableName NVARCHAR(255), @minlogidActual BIGINT OUTPUT'';
EXEC sp_EXECutesql @sqlCommandActual, @ParmDefinition1, @tableName = @tableName, @minlogidActual = @minlogidActualOUT OUTPUT;


IF @minlogidActualOUT > @minlogidWMOUT
BEGIN
SELECT @minlogidActualOUT AS ''minlogid''
END
ELSE
SELECT @minlogidWMOUT AS ''minlogid''
'
EXECUTE SP_EXECUTESQL @alter_adfsp_get_minlogid
END