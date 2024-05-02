CREATE PROCEDURE BPC.aasp_CopyBPAAuditEventsDelta
@minDate DATETIME, @maxDate DATETIME

AS

SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime >= @minDate and eventdatetime <= @maxDate 