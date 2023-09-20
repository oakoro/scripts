


-- ===================================================================================
-- Description: Get maximum logid to copy. Where chunksize is not provided, 
-- maximum logid will default to actual maximum logid in BPASessionLog_NonUnicode table
-- Usages: 
-- If chunksize is provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000,  10000000
-- If chunksize is NOT provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000
-- ====================================================================================

--CREATE PROCEDURE [BPC].[adfsp_get_maxlogid]
--(
--	 @minlogid BIGINT, @rowamt BIGINT = NULL
--)
--AS

--SET NOCOUNT ON	

--SELECT @LoggingType = unicodeLogging FROM BPASysConfig

--IF @LoggingType = 0
--  SET @sessionlogtable = 'BPASessionLog_NonUnicode'
--  ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'
	
	declare @rowamt BIGINT = NULL, @minlogid BIGINT = 0
	DECLARE @addrow BIGINT, @maxLogid BIGINT, @LoggingType BIT,
			@sessionlogtable NVARCHAR(50), @mxidStr NVARCHAR(400),
			@mxidout BIGINT, @param NVARCHAR(255) = '@mxid BIGINT OUTPUT' 

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	set @LoggingType = 1
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

	SET @mxidStr = 'SELECT @mxid = MAX(logid) FROM [dbo].'+QUOTENAME(@sessionlogtable)+' with (nolock)'
	PRINT @mxidStr
	EXEC sp_executeSQL @mxidStr, @param, @mxid = @mxidout OUTPUT;
	select @mxidout
	--select MAX(logid) FROM [dbo].BPASessionLog_NonUnicode
	--select MAX(logid) FROM [dbo].BPASessionLog_Unicode
	--DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
	

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


