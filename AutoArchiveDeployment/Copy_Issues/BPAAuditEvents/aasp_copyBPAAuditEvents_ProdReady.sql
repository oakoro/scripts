-- ==============================================================================
-- @version 24.3.19
-- Description: Delta copy of BPAAuditEvents table
-- Usage: EXEC BPC.aasp_copyBPAAuditEvents 5000 
-- Initialize BPC.adf_watermark
--insert BPC.adf_watermark
--values('BPAAuditEvents','eventdatetime','1900-01-01 00:00:00.000',Null)
-- ==============================================================================


CREATE OR ALTER PROCEDURE BPC.aasp_copyBPAAuditEvents
@maxCount INT 

AS
 
DECLARE @currCount INT -- Current count of data to copy
DECLARE @maxDate DATETIME -- Ending date of data to copy 
DECLARE @minDate DATETIME -- Starting date of data to copy

DECLARE @lastDateCopied DATETIME = (SELECT last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = 'eventdatetime') --'1900-01-01 00:00:00.000' 

SELECT @currCount = COUNT(*) , @minDate = MIN(eventdatetime)   ,@maxDate = MAX(eventdatetime) FROM dbo.BPAAuditEvents WITH (NOLOCK) 

IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	WITH cte_maxdate
	AS
	(
	SELECT TOP(@maxCount) eventdatetime FROM dbo.BPAAuditEvents WITH (NOLOCK)  ORDER BY eventdatetime 
	)
	SELECT @maxDate = max(eventdatetime)  FROM cte_maxdate
	
	SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime >= @minDate and eventdatetime <= @maxDate
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
		
		SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime > @minDate and eventdatetime <= @maxDate
		END
		else
		begin
		set @minDate = @lastDateCopied
		SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime > @minDate and eventdatetime <= @maxDate
		END
		END
	END		

		
		
		
	


