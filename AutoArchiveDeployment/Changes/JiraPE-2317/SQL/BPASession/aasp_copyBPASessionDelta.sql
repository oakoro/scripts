-- =====================================================================================
-- @version 24.5.03
-- Description: Delta copy of BPASession table
-- Script execution Example: [BPC].[aasp_copyBPASessionDelta] '2021-07-16 20:24:57.920' ,'2024-03-13 13:10:47.430'
-- =======================================================================================
	
CREATE PROCEDURE [BPC].[aasp_copyBPASessionDelta]
@minDate DATETIME ,	@maxDate DATETIME 

AS

SELECT * FROM dbo.BPASession WITH (NOLOCK) WHERE enddatetime > @minDate and enddatetime <= @maxDate 

GO


