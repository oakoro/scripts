BEGIN
EXECUTE ('DROP PROCEDURE IF EXISTS [BPC].[adfsp_update_watermark_AuditEvents];')
DECLARE @adfsp_update_watermark_AuditEvents NVARCHAR(MAX) = 
'

-- ==============================================================================
-- @version 24.5.03
-- Description: Update adf watermark table for BPAAuditEvents table
-- Usage: EXEC [BPC].[adfsp_update_watermark_AuditEvents] ''2024-04-19 15:24:34.907''
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_update_watermark_AuditEvents]
 @copiedDate DATETIME

 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET last_processed_date = @copiedDate
   WHERE tableName = ''BPAAuditEvents''
 END'

 EXECUTE SP_EXECUTESQL @adfsp_update_watermark_AuditEvents
END
