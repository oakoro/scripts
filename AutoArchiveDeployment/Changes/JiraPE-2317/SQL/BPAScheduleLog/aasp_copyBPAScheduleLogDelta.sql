-- =====================================================================================
-- @version 24.5.03
-- Description: Delta copy of BPAScheduleLog table
-- Script execution Example: [BPC].[aasp_copyBPAScheduleLogDelta] '2021-05-27 02:05:00.000' ,'2023-11-03 06:30:00.000'
-- =======================================================================================
	
CREATE PROCEDURE [BPC].[aasp_copyBPAScheduleLogDelta]
@minDate DATETIME ,	@maxDate DATETIME 

AS

SELECT * FROM dbo.BPAScheduleLog WITH (NOLOCK) WHERE instancetime > @minDate and instancetime <= @maxDate 

GO


