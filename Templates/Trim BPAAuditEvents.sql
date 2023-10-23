-- Author: Phil Cornelissen
-- Date: 2021/09/01
-- Version: 1
-- Description: Script for Audit Events in the Blue Prism database.
--				Please change @DaysToKeep as is appropriate for your data retention policies.
-- DBA Approval initial and date: DS 2021/09/01
-- CS Approval initial and date:

-- Configurable parameters
DECLARE @DaysToKeep INT = 30

-----------------
DECLARE @Threshold DATETIME = DATEADD(DAY,-@DaysToKeep,GETDATE())
DECLARE @Rows INT = 1;

DECLARE @ERROR_SEVERITY INT;
DECLARE @ERROR_STATE INT;
DECLARE @ERROR_NUMBER INT;
DECLARE @ERROR_LINE INT;
DECLARE @ERROR_MESSAGE NVARCHAR(4000);

WHILE (@Rows > 0)
	BEGIN TRY
		BEGIN TRANSACTION

			DELETE TOP (5000) FROM BPAAuditEvents
			WHERE eventdatetime < @Threshold

			SET @Rows = @@ROWCOUNT
		COMMIT TRANSACTION;
	END TRY

-- Catch any errors and rollback the transaction
BEGIN CATCH
	IF @@TRANCOUNT > 0
		-- Maintenance failed
		PRINT 'Maintenance Failed at: ' + CAST(GETDATE() AS VARCHAR(50));

		ROLLBACK TRANSACTION;

		SELECT @ERROR_SEVERITY = ERROR_SEVERITY(),
			@ERROR_STATE = ERROR_STATE(),
			@ERROR_NUMBER = ERROR_NUMBER(),
			@ERROR_LINE = ERROR_LINE(),
			@ERROR_MESSAGE = ERROR_MESSAGE();

		RAISERROR (
				'Msg %d, Line %d, : %s',
				@ERROR_SEVERITY,
				@ERROR_STATE,
				@ERROR_NUMBER,
				@ERROR_LINE,
				@ERROR_MESSAGE
				);
END CATCH