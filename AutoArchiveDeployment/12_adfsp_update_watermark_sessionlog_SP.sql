/****** Object:  StoredProcedure [BPC].[adfsp_update_watermark_sessionlog]    Script Date: 23/10/2023 20:10:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- Description: Update adf watermark table after copy from BPASessionLog_NonUnicode table
-- ==============================================================================

CREATE OR ALTER PROCEDURE [BPC].[adfsp_update_watermark_sessionlog]
 @logid BIGINT

 AS

 BEGIN
	DECLARE @LoggingType BIT,@sessionlogtable NVARCHAR(50)

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

   UPDATE bpc.adf_watermark
   SET logid = @logid, 
   last_processed_date = GETDATE()
   WHERE tableName = @sessionlogtable
 END
GO


