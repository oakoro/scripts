/****** Object:  StoredProcedure [BPC].[aasp_copyBPAAuditEventsDelta]    Script Date: 18/10/2024 10:08:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================================
-- @version 24.5.03
-- Description: Delta copy of BPAAuditEvents table
-- Script execution Example: [BPC].[aasp_copyBPAAuditEventsDelta] '2021-07-16 20:24:57.920' ,'2024-03-13 13:10:47.430'
-- =======================================================================================

CREATE PROCEDURE [BPC].[aasp_copyBPAAuditEventsDelta]
@minDate DATETIME, @maxDate DATETIME

AS

SELECT * FROM dbo.BPAAuditEvents WITH (NOLOCK) WHERE eventdatetime > @minDate and eventdatetime <= @maxDate 

GO


