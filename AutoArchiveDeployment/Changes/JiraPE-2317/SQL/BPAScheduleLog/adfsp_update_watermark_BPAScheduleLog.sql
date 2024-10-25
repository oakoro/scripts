/****** Object:  StoredProcedure [BPC].[adfsp_update_watermark_BPASession]    Script Date: 18/10/2024 10:10:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- @version 24.5.03
-- Description: Update adf watermark table for BPAScheduleLog table
-- Usage: EXEC [BPC].[adfsp_update_watermark_BPAScheduleLog] '2023-11-03 06:30:00.000'
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_update_watermark_BPAScheduleLog]
 @copiedDate DATETIME 

 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET last_processed_date = @copiedDate
   WHERE tableName = 'BPAScheduleLog'
 END
GO


