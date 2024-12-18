/****** Object:  StoredProcedure [BPC].[aasp_getCopyDatesBPAAuditEvents]    Script Date: 18/10/2024 09:59:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ==============================================================================
-- @version 13.6.24
-- Description: Get date boundary to copy
-- Usage: EXEC BPC.aasp_getCopyDatesBPAAuditEvents 5000 
-- ==============================================================================


CREATE PROCEDURE [BPC].[aasp_getCopyDatesBPAAuditEvents]
		 @maxCount INT


AS

DECLARE  @tablename VARCHAR(50) = 'BPAAuditEvents'
DECLARE	@deltacolumn VARCHAR(50) = 'eventdatetime'
DECLARE @currCount INT -- Current count of data to copy
DECLARE @maxDate DATETIME -- Ending date of data to copy 
DECLARE @minDate DATETIME -- Starting date of data to copy

DECLARE @lastDateCopied DATETIME = (SELECT last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacolumn AND tablename = @tablename) 

SELECT @currCount = COUNT(*) , @minDate = MIN(eventdatetime)  ,@maxDate = MAX(eventdatetime) FROM dbo.BPAAuditEvents WITH (NOLOCK) 


IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	WITH cte_maxdate
	AS
	(
	SELECT TOP(@maxCount) eventdatetime FROM dbo.BPAAuditEvents WITH (NOLOCK)  ORDER BY eventdatetime 
	)
	SELECT @maxDate = max(eventdatetime)  FROM cte_maxdate
	SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SELECT @currCount = COUNT(*) FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime > @lastDateCopied and eventdatetime <= @maxDate
		BEGIN
		IF @currCount > @maxCount
		BEGIN
		WITH cte_maxdate
		AS
		(
		SELECT TOP(@maxCount) eventdatetime FROM  dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime > @lastDateCopied ORDER BY eventdatetime 
		)
		SELECT @minDate = @lastDateCopied, @maxDate = MAX(eventdatetime)  FROM cte_maxdate
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


