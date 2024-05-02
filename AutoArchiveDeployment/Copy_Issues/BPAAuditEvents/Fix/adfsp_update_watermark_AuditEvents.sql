/****** Object:  StoredProcedure [BPC].[adfsp_update_watermark_AuditEvents]    Script Date: 22/04/2024 11:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- ==============================================================================
-- @version 24.4.23
-- Description: Update adf watermark table for BPAAuditEvents table
-- Usage: EXEC [BPC].[adfsp_update_watermark_AuditEvents] '2024-04-19 15:24:34.907'
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_update_watermark_AuditEvents]
 @copiedDate DATETIME

 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET last_processed_date = @copiedDate
   WHERE tableName = 'BPAAuditEvents'
 END
GO

