/****** Object:  StoredProcedure [BPC].[aasp_Update_adf_watermark_WQI]    Script Date: 23/10/2023 20:42:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


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

END
GO


