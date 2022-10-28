/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 06/09/2022 18:16:19 ******/
DROP VIEW [BPC].[aavw_ControlTableUpdate]
GO

/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 06/09/2022 18:16:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [BPC].[aavw_ControlTableUpdate] ******/
--BEGIN TRY
--		BEGIN
			CREATE VIEW [BPC].[aavw_ControlTableUpdate]
			WITH SCHEMABINDING
			AS
			SELECT s.sessionnumber, COUNT_BIG(*) as rowNumber 
			FROM [dbo].[BPASession] as s
			INNER JOIN [dbo].[BPASessionLog_NonUnicode] as sl
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			GROUP BY s.sessionnumber
--		END
--END TRY

--BEGIN CATCH
--IF @@TRANCOUNT > 0
--		-- Maintenance failed
--		PRINT 'View BPC.aavw_ControlTableUpdate was not created'
--	SELECT   
--         ERROR_NUMBER() AS ErrorNumber  
--        ,ERROR_SEVERITY() AS ErrorSeverity  
--        ,ERROR_STATE() AS ErrorState  
--        ,ERROR_LINE () AS ErrorLine  
--        ,ERROR_PROCEDURE() AS ErrorProcedure  
--        ,ERROR_MESSAGE() AS ErrorMessage;
--END CATCH
GO


