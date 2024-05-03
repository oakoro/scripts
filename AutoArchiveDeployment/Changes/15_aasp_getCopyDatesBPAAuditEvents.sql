/****** Create [BPC].[aasp_getCopyDatesBPAAuditEvents] Stored Procedure ******/


BEGIN
EXECUTE ('DROP PROCEDURE IF EXISTS [BPC].[aasp_getCopyDatesBPAAuditEvents];')
DECLARE @aasp_getCopyDatesBPAAuditEvents NVARCHAR(MAX) = 
'

-- ==============================================================================
-- @version 24.5.03
-- Description: Get date boundary to copy
-- Usage: EXEC BPC.aasp_getCopyDatesBPAAuditEvents 5000 
-- ==============================================================================


CREATE PROCEDURE [BPC].[aasp_getCopyDatesBPAAuditEvents]
@maxCount INT 

AS
 
DECLARE @currCount INT -- Current count of data to copy
DECLARE @maxDate DATETIME -- Ending date of data to copy 
DECLARE @minDate DATETIME -- Starting date of data to copy
DECLARE @defaultdate DATETIME = ''1900-01-01 00:00:00.000'' -- Default date

DECLARE @lastDateCopied DATETIME = (SELECT last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = ''eventdatetime'') 

SELECT @currCount = COUNT(*) , @minDate = MIN(eventdatetime)  ,@maxDate = MAX(eventdatetime) FROM dbo.BPAAuditEvents WITH (NOLOCK) 

IF @lastDateCopied = @defaultdate
	BEGIN
	WITH cte_maxdate
	AS
	(
	SELECT TOP(@maxCount) eventdatetime FROM dbo.BPAAuditEvents WITH (NOLOCK)  ORDER BY eventdatetime 
	)
	SELECT @maxDate = max(eventdatetime)  FROM cte_maxdate
	SELECT ISNULL(@minDate,@defaultdate) AS ''minDate'', ISNULL(@maxDate,@defaultdate) AS ''maxDate''
	END
	ELSE
	IF @lastDateCopied <> @defaultdate
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
		SELECT ISNULL(@minDate,@defaultdate) AS ''minDate'', ISNULL(@maxDate,@defaultdate) AS ''maxDate''
		END
		ELSE
		BEGIN
		SET @minDate = @lastDateCopied
		SELECT ISNULL(@minDate,@defaultdate) AS ''minDate'', ISNULL(@maxDate,@defaultdate) AS ''maxDate''
		END
		END
	
	END	'	


		
EXECUTE SP_EXECUTESQL @aasp_getCopyDatesBPAAuditEvents
END


