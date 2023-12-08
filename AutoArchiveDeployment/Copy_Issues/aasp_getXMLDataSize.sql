/****** Object:  StoredProcedure [BPC].[aasp_getXMLDataSize]    Script Date: 01/12/2023 11:45:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Description: Get total size of XML value to copy from session log table 
-- Script execution Example: [BPC].[aasp_getXMLDataSize] 0, 0, 2684354560
-- variable description: 
--	@minLogid - Minimum logid to copy, 
--  @maxLogid - Maximum logid to copy
--  @xmlDataThreshold - Session log XML size threshold in byte
-- ==============================================

ALTER PROCEDURE [BPC].[aasp_getXMLDataSize]
@minLogid BIGINT, @maxLogid BIGINT, @xmlDataThreshold BIGINT

AS

DECLARE @sumDataSize BIGINT,@status BIT,  
		@LoggingType BIT, @sessionlogtable NVARCHAR(50),
		@sqlCommandActual NVARCHAR(1000), @ParmDefinition NVARCHAR(500),
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
SET @ParmDefinition = N'@sessionlogtable NVARCHAR(255), @sumDataSize BIGINT OUTPUT';

EXEC sp_executesql @sqlCommandActual, @ParmDefinition, @sessionlogtable = @sessionlogtable, @sumDataSize = @sumDataSizeOUT OUTPUT;

IF ISNULL(@sumDataSizeOUT,1) <= @xmlDataThreshold SET @status = 0 ELSE SET @status = 1
SELECT @status AS 'DataSizeStatus'
END


SET NOCOUNT OFF
GO


