/*
	Name:			CleanupInBatches - BPAWorkQueueItem.sql
	Author:			Blue Prism
	Date:			20220330
	Description:	This script is to be used to clean up the BPAWorkQueueItem, BPATag and BPAWorkQueueLog tables in scenarios where the standard maintenance 
					scripts do not complete in a timely fashion. By default it will retain the last 7 days of data in the BPAWorkQueueItem table and BPATag records 
					that are not associated with a work queue item.
					The deletes from both BPAWorkQueueItem and BPATag are done in batches of 25,000
	BP Version(s):	This script has been tested against Version 6.4+ of Blue Prism
	Usage:			The "Blue Prism Database Name Here" needs replacing with the name of your Blue Prism database
					The @DaysToKeep variable is to be updated where a retention period other than 7 days is required
	
	This script can potentially delete tens of gigabytes of data from the BPAWorkQueueItem table
	and will impact the size of your transaction log file as such it is recommended that; 
		- The person running the script should have a good understanding of how transactions and transaction log backups impact the transaction log of a database
		- Your Blue Prism database is in FULL recovery
		- You have regular transaction log backups scheduled
		- You have sufficient disk space on the drive on which your transaction log and transaction log backup files reside
	
	Example 1: 
		- Your BPAWorkQueueItem table is 60GB
		- This contains 365 days of data
		- You want to keep 90 days of data (@DaysToKeep variable = 90)
		- The Blue Prism Database is in FULL recovery
		- Transaction log backups are taken every 15 minutes
		- This will result in 45GB of data being removed from the BPAWorkQueueItem table which will be recorded in the transaction log
			- 90 Days is ~ 1/4 of 365 resulting in 3/4 of 60GB being deleted
		- If the script takes 30 minutes to execute then 22.5GB of transaction log will be generated between each transaction log backup

	Example 2: 
		- Your BPAWorkQueueItem table is 60GB
		- This contains 365 days of data
		- You want to keep 90 days of data (@DaysToKeep variable = 90)
		- The Blue Prism Database is in FULL recovery
		- Transaction log backups are taken every 60 minutes
		- This will result in 45GB of data being removed from the BPAWorkQueueItem table which will be recorded in the transaction log
			- 90 Days is ~ 1/4 of 365 resulting in 3/4 of 60GB being deleted
		- If the script takes 30 minutes to execute then 45GB of transaction log will be generated between each transaction log backup

	*** Whilst this script is re-runnable it does make use of transactions, if the script is stopped when manually being executed in management studio there is a possibility
	*** that there may still be an open transaction, this can safely be rolled back and only the last batch will be undone. This can be achieved by either
	***	closing the query window and clicking "No" on the resulting "There are uncommitted transactions. Do you with to commit these transactions?" prompt or by
	*** highlighting only the words "ROLLBACK TRANSACTION;" in the script and executing this single line (line number 109 for example)	

	*** The script is to be tested in lower route to live environments (Development / Test / UAT / SIT) and the results verified before being run against a Production environment

	*** Always make sure that you have backups in place that can be used to recover any data that has been removed

	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
*/

-- Set database context
--USE [Blue Prism Database Name Here];
--GO

-- Declare variables
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;
DECLARE @ERROR_SEVERITY INT;
DECLARE @ERROR_STATE INT;
DECLARE @ERROR_NUMBER INT;
DECLARE @ERROR_LINE INT;
DECLARE @ERROR_MESSAGE NVARCHAR(4000);

-- Set variables, modify the @DaysToKeep to reflect the required retention period
SET @DaysToKeep = 14;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);

-- Create maintenance table to hold the WorkQueueItem(s) we want to delete
IF OBJECT_ID(N'DeletedWorkQueueItems_Maintenance', N'U') IS NULL
BEGIN
    CREATE TABLE [DeletedWorkQueueItems_Maintenance]
    (
        WorkQueueItemID UNIQUEIDENTIFIER NOT NULL
    );
END;

-- Get WorkQueueItem(s) we want to delete
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO DeletedWorkQueueItems_Maintenance
    (
        WorkQueueItemID
    )
    SELECT I.id
    FROM BPAWorkQueueItem1 AS I
    LEFT JOIN BPAWorkQueueItem1 AS inext
        ON I.id = INEXT.id
           AND INEXT.attempt = I.attempt + 1
    LEFT JOIN DeletedWorkQueueItems_Maintenance AS WM
        ON WM.WorkQueueItemID = I.id
    WHERE INEXT.id IS NULL
          AND WM.WorkQueueItemID IS NULL
          AND I.finished < @threshold;

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

    RAISERROR('Msg %d, Line %d, : %s', @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER, @ERROR_LINE, @ERROR_MESSAGE);
END CATCH;

-- Delete BPAWorkQueueItem1 records in batches of 25,000
WHILE (2 > 1)
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE TOP (25000) WQI
    FROM BPAWorkQueueItem1 AS WQI
    INNER JOIN DeletedWorkQueueItems_Maintenance AS WM
        ON WM.WorkQueueItemID = WQI.id;

    -- If no records are left to delete commit the transaction and break out of the loop
    IF @@ROWCOUNT = 0
    BEGIN
        COMMIT TRANSACTION;
        BREAK;
    END;

    -- Commit transaction
    COMMIT TRANSACTION;

    -- 1 second delay to allow other operations to access BPAWorkQueueItem1
    WAITFOR DELAY '00:00:01';
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

    RAISERROR('Msg %d, Line %d, : %s', @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER, @ERROR_LINE, @ERROR_MESSAGE);
END CATCH;

-- Delete in batches of 25,000 BPATag records that are not associated with a work queue item
WHILE (2 > 1)
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE TOP (25000) T
    FROM BPATag AS T
    LEFT JOIN BPAWorkQueueItemTag AS IT
        ON T.id = IT.tagid
    WHERE IT.tagid IS NULL;

    -- If no records are left to delete commit the transaction and break out of the loop
    IF @@ROWCOUNT = 0
    BEGIN
        COMMIT TRANSACTION;
        BREAK;
    END;

    -- Commit transaction
    COMMIT TRANSACTION;
    -- 1 second delay to allow other operations to access BPATag
    WAITFOR DELAY '00:00:01';
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

    RAISERROR('Msg %d, Line %d, : %s', @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER, @ERROR_LINE, @ERROR_MESSAGE);
END CATCH;

-- Truncate BPAWorkQueueLog and DeletedSessions_Maintenance ready for next run
BEGIN TRY
    BEGIN TRANSACTION;
		TRUNCATE TABLE BPAWorkQueueLog;
		TRUNCATE TABLE DeletedWorkQueueItems_Maintenance;
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

    RAISERROR('Msg %d, Line %d, : %s', @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER, @ERROR_LINE, @ERROR_MESSAGE);
END CATCH;
GO