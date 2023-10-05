/****** Object:  StoredProcedure [BPC].[adfsp_get_minlogid]    Script Date: 05/10/2023 13:57:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ==============================================================================
-- Description: Get minimum logid to copy
-- Usage: EXEC [BPC].[adfsp_get_minlogid] 
-- Automate for both unicode and non-unicode
-- ==============================================================================

CREATE   PROCEDURE [BPC].[adfsp_get_minlogid]
	 

AS

DECLARE @sqlCommandWM NVARCHAR(1000),
	@ParmDefinition NVARCHAR(500),
	@minlogidWM NVARCHAR(20),
	@minlogidWMOUT BIGINT,
	@sqlCommandActual NVARCHAR(1000),
	@ParmDefinition1 NVARCHAR(500),
	@minlogidActual BIGINT,
	@minlogidActualOUT BIGINT,
	@minLogid BIGINT,
	@LoggingType BIT,
	@sessionlogtable NVARCHAR(50)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'


SET @sqlCommandWM = N'SELECT @minlogidWM = logid  FROM bpc.adf_watermark WHERE tableName = ''' + @sessionlogtable + ''';'
SET @ParmDefinition = N'@sessionlogtable NVARCHAR(255), @minlogidWM BIGINT OUTPUT';
EXEC sp_executesql @sqlCommandWM, @ParmDefinition, @sessionlogtable = @sessionlogtable, @minlogidWM = @minlogidWMOUT OUTPUT;



SET @sqlCommandActual = N'SELECT TOP 1 @minlogidActual = logid FROM dbo.'+@sessionlogtable +' WITH (nolock) WHERE logid >= '+CONVERT(NVARCHAR(50),@minlogidWMOUT) +' ORDER BY logid'
SET @ParmDefinition1 = N'@sessionlogtable NVARCHAR(255), @minlogidActual BIGINT OUTPUT';
EXEC sp_executesql @sqlCommandActual, @ParmDefinition1, @sessionlogtable = @sessionlogtable, @minlogidActual = @minlogidActualOUT OUTPUT;


IF @minlogidActualOUT > @minlogidWMOUT
BEGIN
SELECT @minlogidActualOUT AS 'minlogid'
END
ELSE
SELECT @minlogidWMOUT AS 'minlogid'
GO


