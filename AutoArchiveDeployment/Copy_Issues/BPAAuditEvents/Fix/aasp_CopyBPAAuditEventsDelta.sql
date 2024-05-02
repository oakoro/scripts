
-- =====================================================================================
-- @version 24.4.23
-- Description: Delta copy of BPAAuditEvents table
-- Script execution Example: [BPC].[aasp_CopyBPAAuditEventsDelta] '2024-04-17 00:00:00.523' ,'2024-04-19 15:24:34.907'
-- =======================================================================================

CREATE PROCEDURE [BPC].[aasp_CopyBPAAuditEventsDelta]
@minDate DATETIME, @maxDate DATETIME

AS

SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime >= @minDate and eventdatetime <= @maxDate 
GO


