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
	
	DECLARE @addrow BIGINT, @maxLogid BIGINT
	DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
	

	IF @rowamt IS NOT NULL
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

	IF @mxid IS NOT NULL AND @addrow = 0
		BEGIN
			SET @maxLogid = @mxid
		END
		ELSE IF @mxid IS NOT NULL AND @addrow <> 0
		BEGIN
			IF @mxid >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			END
			ELSE SET @maxLogid = @mxid
		END 
		ELSE IF @mxid IS NULL
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
-- ====================================================================================

ALTER PROCEDURE [BPC].[adfsp_get_maxlogid]
(
	 @minlogid BIGINT, @rowamt BIGINT = NULL
)
AS

SET NOCOUNT ON	
	
	DECLARE @addrow BIGINT, @maxLogid BIGINT
	DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
	

	IF @rowamt IS NOT NULL
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

	IF @mxid IS NOT NULL AND @addrow = 0
		BEGIN
			SET @maxLogid = @mxid
		END
		ELSE IF @mxid IS NOT NULL AND @addrow <> 0
		BEGIN
			IF @mxid >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			END
			ELSE SET @maxLogid = @mxid
		END 
		ELSE IF @mxid IS NULL
		SET @maxLogid = @minlogid
		
SELECT @maxLogid as ''MaxLogid''	
SET NOCOUNT OFF	
'
EXECUTE SP_EXECUTESQL @alter_adfsp_get_maxlogid

END