/****** Create [BPC].[adfsp_update_watermark_sessionlog] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[adfsp_update_watermark_sessionlog]',N'P')) IS NULL
BEGIN
DECLARE @adfsp_update_watermark_sessionlog NVARCHAR(MAX) = '

-- ==============================================================================
-- Description: Update adf watermark table after copy from BPASessionLog_NonUnicode table
-- ==============================================================================

CREATE PROC [BPC].[adfsp_update_watermark_sessionlog]
 @logid bigint,
 @tableName varchar(255)
 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET logid = @logid, 
   createdTS = GETDATE()
   WHERE tableName = @tableName
 END'

 EXECUTE SP_EXECUTESQL @adfsp_update_watermark_sessionlog
END
