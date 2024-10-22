/****** Object:  StoredProcedure [BPC].[aasp_getCopyDatesBPASession]    Script Date: 18/10/2024 09:59:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ==============================================================================
-- @version 13.6.24
-- Description: Get date boundary to copy
-- Usage: EXEC BPC.aasp_getCopyDatesBPASession 5000 
-- ==============================================================================


CREATE PROCEDURE [BPC].[aasp_getCopyDatesBPASession]
		 @maxCount INT


AS

DECLARE  @tablename VARCHAR(50) = 'BPASession'
DECLARE	@deltacolumn VARCHAR(50) = 'enddatetime'
DECLARE @currCount INT -- Current count of data to copy
DECLARE @maxDate DATETIME -- Ending date of data to copy 
DECLARE @minDate DATETIME -- Starting date of data to copy

DECLARE @lastDateCopied DATETIME = (SELECT last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacolumn AND tablename = @tablename) 

SELECT @currCount = COUNT(*) , @minDate = MIN(enddatetime)  ,@maxDate = MAX(enddatetime) FROM dbo.BPASession WITH (NOLOCK) 


IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	WITH cte_maxdate
	AS
	(
	SELECT TOP(@maxCount) enddatetime FROM dbo.BPASession WITH (NOLOCK)  ORDER BY enddatetime 
	)
	SELECT @maxDate = max(enddatetime)  FROM cte_maxdate
	SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SELECT @currCount = COUNT(*) FROM dbo.BPASession WITH (NOLOCK) WHERE enddatetime > @lastDateCopied and enddatetime <= @maxDate
		BEGIN
		IF @currCount > @maxCount
		BEGIN
		WITH cte_maxdate
		AS
		(
		SELECT TOP(@maxCount) enddatetime FROM  dbo.BPASession WITH (NOLOCK) WHERE enddatetime > @lastDateCopied ORDER BY enddatetime 
		)
		SELECT @minDate = @lastDateCopied, @maxDate = MAX(enddatetime)  FROM cte_maxdate
		SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
		END
		ELSE
		BEGIN
		SET @minDate = @lastDateCopied
		SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
		END
		END
	
	END		


		


	


GO


