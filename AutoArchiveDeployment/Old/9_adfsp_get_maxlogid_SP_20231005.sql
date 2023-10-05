/****** Create [BPC].[adfsp_get_maxlogid] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[adfsp_get_maxlogid]',N'P')) IS NULL
BEGIN
DECLARE @adfsp_get_maxlogid NVARCHAR(MAX) = '

-- ===================================================================================
-- Description: Get maximum logid to copy. Where chunksize is not provided, 
-- maximum logid will default to actual maximum logid in BPASessionLog_NonUnicode table
-- Usages: 
-- If chunksize is provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000,  10000000
-- If chunksize is NOT provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000
-- ====================================================================================

CREATE PROCEDURE [BPC].[adfsp_get_maxlogid]
(
	 @minlogid BIGINT, @rowamt BIGINT = NULL
)
AS

SET NOCOUNT ON	
	
	DECLARE @addrow BIGINT, @maxLogid BIGINT, @LoggingType BIT,
			@sessionlogtable NVARCHAR(50), @mxidStr NVARCHAR(400),
			@mxidout BIGINT, @param NVARCHAR(255) = ''@mxid BIGINT OUTPUT'' 
	

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = ''BPASessionLog_NonUnicode''
	ELSE SET @sessionlogtable = ''BPASessionLog_Unicode''

	SET @mxidStr = ''SELECT @mxid = MAX(logid) FROM [dbo].''+QUOTENAME(@sessionlogtable)+'' with (nolock)''
	
	EXEC sp_executeSQL @mxidStr, @param, @mxid = @mxidout OUTPUT;
	

	IF @rowamt IS NOT NULL
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

	IF @mxidout IS NOT NULL AND @addrow = 0
		BEGIN
			SET @maxLogid = @mxidout
		END
		ELSE IF @mxidout IS NOT NULL AND @addrow <> 0
		BEGIN
			IF @mxidout >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			END
			ELSE SET @maxLogid = @mxidout
		END 
		ELSE IF @mxidout IS NULL
		SET @maxLogid = @minlogid
		
SELECT @maxLogid as ''MaxLogid''	
SET NOCOUNT OFF		
'

EXECUTE SP_EXECUTESQL @adfsp_get_maxlogid

END
ELSE
BEGIN
DECLARE @alter_adfsp_get_maxlogid NVARCHAR(MAX) = '

-- ===================================================================================
-- Description: Get maximum logid to copy. Where chunksize is not provided, 
-- maximum logid will default to actual maximum logid in BPASessionLog_NonUnicode table
-- Usages: 
-- If chunksize is provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000,  10000000
-- If chunksize is NOT provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000
-- Automate for both unicode and non-unicode
-- ====================================================================================

ALTER PROCEDURE [BPC].[adfsp_get_maxlogid]
(
	 @minlogid BIGINT, @rowamt BIGINT = NULL
)
AS

SET NOCOUNT ON	
	
	DECLARE @addrow BIGINT, @maxLogid BIGINT, @LoggingType BIT,
			@sessionlogtable NVARCHAR(50), @mxidStr NVARCHAR(400),
			@mxidout BIGINT, @param NVARCHAR(255) = ''@mxid BIGINT OUTPUT'' 
	

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = ''BPASessionLog_NonUnicode''
	ELSE SET @sessionlogtable = ''BPASessionLog_Unicode''

	SET @mxidStr = ''SELECT @mxid = MAX(logid) FROM [dbo].''+QUOTENAME(@sessionlogtable)+'' with (nolock)''
	
	EXEC sp_executeSQL @mxidStr, @param, @mxid = @mxidout OUTPUT;
	

	IF @rowamt IS NOT NULL
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

	IF @mxidout IS NOT NULL AND @addrow = 0
		BEGIN
			SET @maxLogid = @mxidout
		END
		ELSE IF @mxidout IS NOT NULL AND @addrow <> 0
		BEGIN
			IF @mxidout >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			END
			ELSE SET @maxLogid = @mxidout
		END 
		ELSE IF @mxidout IS NULL
		SET @maxLogid = @minlogid
		
SELECT @maxLogid as ''MaxLogid''	
SET NOCOUNT OFF	
'
EXECUTE SP_EXECUTESQL @alter_adfsp_get_maxlogid

END