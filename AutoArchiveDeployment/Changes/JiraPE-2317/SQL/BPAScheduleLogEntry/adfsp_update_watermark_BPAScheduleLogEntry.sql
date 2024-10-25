/****** Object:  StoredProcedure [BPC].[adfsp_update_watermark_BPASession]    Script Date: 18/10/2024 10:10:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- @version 24.5.03
-- Description: Update adf watermark table for BPAScheduleLogEntry table
-- Usage: EXEC [BPC].[adfsp_update_watermark_BPAScheduleLogEntry] '2022-01-23 09:02:37.170'
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_update_watermark_BPAScheduleLogEntry]
 @copiedDate DATETIME 

 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET last_processed_date = @copiedDate
   WHERE tableName = 'BPAScheduleLogEntry'
 END
GO


