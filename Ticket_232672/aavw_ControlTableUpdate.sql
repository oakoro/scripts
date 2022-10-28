/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 26/09/2022 17:50:16 ******/
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


SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

/****** Object:  Index [aaix_vwSessionnumber]    Script Date: 26/09/2022 17:49:38 ******/
CREATE UNIQUE CLUSTERED INDEX [aaix_vwSessionnumber] ON [BPC].[aavw_ControlTableUpdate]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
