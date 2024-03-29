/****** Object:  StoredProcedure [BPC].[adfsp_get_maxlogid]    Script Date: 20/09/2023 15:30:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



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
			@mxidout BIGINT, @param NVARCHAR(255) = '@mxid BIGINT OUTPUT' 
	--DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

	SET @mxidStr = 'SELECT @mxid = MAX(logid) FROM [dbo].'+QUOTENAME(@sessionlogtable)+' with (nolock)'
	
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
		
SELECT @maxLogid as 'MaxLogid'	
SET NOCOUNT OFF	
GO

