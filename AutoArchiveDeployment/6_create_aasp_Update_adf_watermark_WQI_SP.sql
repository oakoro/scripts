/****** Create [BPC].[aasp_Update_adf_watermark_WQI] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[aasp_Update_adf_watermark_WQI]',N'P')) IS NULL
BEGIN
DECLARE @aasp_Update_adf_watermark_WQI NVARCHAR(MAX) = 

'
-- =============================================
-- Description: Updates adf watermark table for Workqueueitem
-- variable description: 
--	@tablename - Table copied e.g Workqueueitem, 
--  @last_processed_date - Date of last table copy
-- =============================================


CREATE PROC [BPC].[aasp_Update_adf_watermark_WQI]
@last_processed_date datetime, 
@tablename varchar(50)

AS

BEGIN

    UPDATE [BPC].[adf_watermark] SET last_processed_date = @last_processed_date
    WHERE tablename = @tablename

END'

EXECUTE SP_EXECUTESQL @aasp_Update_adf_watermark_WQI
END

