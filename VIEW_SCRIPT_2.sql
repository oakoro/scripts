/****** Object:  Schema [BPC] ******/
CREATE SCHEMA BPC
GO

DECLARE @username SYSNAME = N'__sqlUserMI__' 
	,@cmd	NVARCHAR(MAX)
	,@ERROR_SEVERITY INT
	,@ERROR_STATE INT
	,@ERROR_NUMBER INT
	,@ERROR_LINE INT
	,@ERROR_MESSAGE NVARCHAR(4000)




-- GRANT ALTER, DELETE, EXECUTE, REFERENCES, SELECT, INSERT, UPDATE ON SCHEMA BPC 
BEGIN TRY
		BEGIN
			SELECT @cmd = 'SELECT, EXECUTE ON SCHEMA::[BPC] TO  [' + @username + '];' 
			EXEC (@cmd)
		END
END TRY
 -- Catch any errors
BEGIN CATCH
	IF @@TRANCOUNT > 0
		-- Maintenance failed
		PRINT 'GRANT SELECT, EXECUTE ON SCHEMA BPC Failed at: ' + CAST(GETDATE() AS VARCHAR(50))
	SELECT   
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
GO
/****** Object:  View [BPC].[aavw_BPASessionLog_NonUnicode] ******/

/*
Author: Olabode Adesoye
-- 01. The script was amended on the 25.03.2022. I removed the BPAWorkItemQueue part from the original script.
-- 02. The script was amened for this view object to be created in BPC schema as agreed by the team.

*/


			CREATE VIEW [BPC].[aavw_BPASessionLog_NonUnicode]
			AS

			WITH cet_uniqSessionNumWithLog
			AS
			(
				SELECT DISTINCT s.sessionnumber FROM [dbo].[BPASession] as s
				INNER JOIN [dbo].[BPASessionLog_NonUnicode] as sl
						ON s.sessionnumber = sl.sessionnumber
				WHERE s.enddatetime is not null 	 
			)

-- The script below will be used in copy activity for Azure Data Factory   
			SELECT *
			FROM [dbo].[BPASessionLog_NonUnicode]
			WHERE [sessionnumber] IN (SELECT sessionnumber FROM cet_uniqSessionNumWithLog);
GO
/****** Object:  View [BPC].[aavw_Get_Sessionnumber_BPASessionLog_NonUnicode] ******/

			CREATE   view [BPC].[aavw_Get_Sessionnumber_BPASessionLog_NonUnicode]
			as
			SELECT s.sessionnumber,COUNT_BIG(*) as 'rowNumber' FROM [dbo].[BPASessionLog_NonUnicode] as sl
			INNER JOIN [dbo].[BPASession]  as s
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			group by  s.sessionnumber
GO
/****** Object:  View [BPC].[aavw_Sessionnumber]  ******/
			CREATE   view [BPC].[aavw_Sessionnumber]
			with schemabinding
			as
			SELECT s.sessionnumber,COUNT_BIG(*) as 'rowNumber' FROM [dbo].[BPASessionLog_NonUnicode] as sl
			INNER JOIN [dbo].[BPASession]  as s
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			group by  s.sessionnumber

GO
/****** Object:  View [BPC].[aavw_BPAWorkQueueItem] ******/

			CREATE VIEW [BPC].[aavw_BPAWorkQueueItem]
			AS

			WITH cet_uniqidWithWorkQ
			AS
			(
			SELECT DISTINCT s.sessionid FROM [dbo].[BPASession] as s
			INNER JOIN [dbo].[BPAWorkQueueItem] as q
			ON s.sessionid = q.sessionid
			WHERE s.enddatetime is not null 
				  and q.finished is not null
			)

-- The script below will be used in copy activity for Azure Data Factory   

			SELECT *
			FROM [dbo].[BPAWorkQueueItem]
			WHERE [sessionid] IN (SELECT sessionid FROM cet_uniqidWithWorkQ)


GO
/****** Object:  View [BPC].[aavw_ControlTableUpdate] ******/

			CREATE VIEW [BPC].[aavw_ControlTableUpdate]
			WITH SCHEMABINDING
			AS
			SELECT s.sessionnumber, COUNT_BIG(*) as rowNumber 
			FROM [dbo].[BPASession] as s
			INNER JOIN [dbo].[BPASessionLog_NonUnicode] as sl
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			GROUP BY s.sessionnumber

GO
/****** Object:  Index [aaix_vwSessionnumber] ******/
BEGIN TRY
		BEGIN
			CREATE UNIQUE CLUSTERED INDEX [aaix_vwSessionnumber] ON [BPC].[aavw_ControlTableUpdate]
			(
				[sessionnumber] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		END
END TRY

BEGIN CATCH
IF @@TRANCOUNT > 0
		-- Maintenance failed
		PRINT 'Index BPC.aaix_aavw_Sessionnumber was not created'
	SELECT   
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
