-- =====================================================================================
-- @version 24.5.03
-- Description: Delta copy of BPAScheduleLogEntry table
-- Script execution Example: [BPC].[aasp_copyBPAScheduleLogEntryDelta] '2021-05-27 11:26:16.087' ,'2022-01-23 09:02:37.170'
-- =======================================================================================
	
CREATE PROCEDURE [BPC].[aasp_copyBPAScheduleLogEntryDelta]
@minDate DATETIME ,	@maxDate DATETIME 

AS

SELECT * FROM dbo.BPAScheduleLogEntry WITH (NOLOCK) WHERE entrytime > @minDate and entrytime <= @maxDate 

GO


	