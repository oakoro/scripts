
-- ==============================================================================
-- @version 13.6.24
-- Description: Get date boundary to copy
-- Usage: EXEC BPC.aasp_getCopyDatesBPAScheduleLogEntry 5000 
-- ==============================================================================


ALTER PROCEDURE [BPC].[aasp_getCopyDatesBPAScheduleLogEntry]
		 @maxCount INT, @tablename VARCHAR(50) = 'BPAScheduleLogEntry', 
		@deltacolumn VARCHAR(50) = 'entrytime'


AS


DECLARE @currCount INT -- Current count of data to copy
DECLARE @maxDate DATETIME -- Ending date of data to copy 
DECLARE @minDate DATETIME -- Starting date of data to copy

DECLARE @lastDateCopied DATETIME = (SELECT last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacolumn AND tablename = @tablename) 

SELECT @currCount = COUNT(*) , @minDate = MIN(entrytime)  ,@maxDate = MAX(entrytime) FROM dbo.BPAScheduleLogEntry WITH (NOLOCK) 


IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	WITH cte_maxdate
	AS
	(
	SELECT TOP(@maxCount) entrytime FROM dbo.BPAScheduleLogEntry WITH (NOLOCK)  ORDER BY entrytime 
	)
	SELECT @maxDate = max(entrytime)  FROM cte_maxdate
	SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SELECT @currCount = COUNT(*) FROM dbo.BPAScheduleLogEntry WITH (NOLOCK) WHERE entrytime > @lastDateCopied and entrytime <= @maxDate
		BEGIN
		IF @currCount > @maxCount
		BEGIN
		WITH cte_maxdate
		AS
		(
		SELECT TOP(@maxCount) entrytime FROM  dbo.BPAScheduleLogEntry WITH (NOLOCK) WHERE entrytime > @lastDateCopied ORDER BY entrytime 
		)
		SELECT @minDate = @lastDateCopied, @maxDate = MAX(entrytime)  FROM cte_maxdate
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


