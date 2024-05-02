/****** Object:  StoredProcedure [BPC].[adfsp_update_watermark_sessionlog]    Script Date: 18/04/2024 16:19:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ==============================================================================
-- @version 24.3.19
-- Description: Update adf watermark table for BPAAuditEvents table
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


