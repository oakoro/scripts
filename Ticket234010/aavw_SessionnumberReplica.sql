/****** Object:  View [BPC].[aavw_Sessionnumber]    Script Date: 21/10/2022 13:33:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [BPC].[aavw_Sessionnumber]  ******/
--BEGIN TRY
--		BEGIN
			CREATE   view [BPC].[aavw_SessionnumberReplica]
			with schemabinding
			as
			SELECT s.sessionnumber,COUNT_BIG(*) as 'rowNumber' FROM [dbo].[BPASessionLog_NonUnicodeReplica] as sl
			INNER JOIN [dbo].[BPASession]  as s
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			group by  s.sessionnumber
--		END
--END TRY

--BEGIN CATCH
--IF @@TRANCOUNT > 0
--		-- Maintenance failed
--		PRINT 'View BPC.aavw_Sessionnumber was not created'
--	SELECT   
--         ERROR_NUMBER() AS ErrorNumber  
--        ,ERROR_SEVERITY() AS ErrorSeverity  
--        ,ERROR_STATE() AS ErrorState  
--        ,ERROR_LINE () AS ErrorLine  
--        ,ERROR_PROCEDURE() AS ErrorProcedure  
--        ,ERROR_MESSAGE() AS ErrorMessage;
--END CATCH
GO


