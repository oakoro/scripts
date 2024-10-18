/****** Object:  StoredProcedure [BPC].[adfsp_update_watermark_AuditEvents]    Script Date: 18/10/2024 10:10:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- @version 24.5.03
-- Description: Update adf watermark table for BPAAuditEvents table
-- Usage: EXEC [BPC].[adfsp_update_watermark_AuditEvents] '2024-04-19 15:24:34.907'
-- ==============================================================================

ALTER PROCEDURE [BPC].[adfsp_update_watermark_AuditEvents]
 @copiedDate DATETIME

 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET last_processed_date = @copiedDate
   WHERE tableName = 'BPAAuditEvents'
 END
GO


