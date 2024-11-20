/****** Object:  StoredProcedure [BPC].[aasp_Update_adf_watermark_WQI]    Script Date: 20/11/2024 16:14:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- @version 24.3.19
-- Description: Updates adf watermark table for Workqueueitem
-- variable description: 
--	@tablename - Table copied e.g Workqueueitem, 
--  @last_processed_date - Date of last table copy
-- Replace Create or Alter clause in SP
-- =============================================


CREATE PROCEDURE [BPC].[aasp_Update_adf_watermark_delta]
@last_processed_date datetime, 
@tablename varchar(50)

AS

BEGIN

    UPDATE [BPC].[adf_watermark] SET last_processed_date = @last_processed_date
    WHERE tablename = @tablename

END
GO


