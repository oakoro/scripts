/****** Create [BPC].[aasp_copyBPAAuditEventsDelta] Stored Procedure ******/


BEGIN
EXECUTE ('DROP PROCEDURE IF EXISTS [BPC].[aasp_copyBPAAuditEventsDelta];')
DECLARE @aasp_copyBPAAuditEventsDelta NVARCHAR(MAX) = 
'
-- =====================================================================================
-- @version 24.5.03
-- Description: Delta copy of BPAAuditEvents table
-- Script execution Example: [BPC].[aasp_copyBPAAuditEventsDelta] ''2024-04-17 00:00:00.523'' ,''2024-04-19 15:24:34.907''
-- =======================================================================================

CREATE PROCEDURE [BPC].[aasp_copyBPAAuditEventsDelta]
@minDate DATETIME, @maxDate DATETIME

AS

SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime > @minDate and eventdatetime <= @maxDate 

'
EXECUTE SP_EXECUTESQL @aasp_copyBPAAuditEventsDelta

END


