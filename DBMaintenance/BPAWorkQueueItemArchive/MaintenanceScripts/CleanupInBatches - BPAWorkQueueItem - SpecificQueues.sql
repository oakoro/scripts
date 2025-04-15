

-- Declare variables
DECLARE @DaysToKeep INT = 90;
DECLARE @Threshold DATETIME;
DECLARE @ERROR_SEVERITY INT;
DECLARE @ERROR_STATE INT;
DECLARE @ERROR_NUMBER INT;
DECLARE @ERROR_LINE INT;
DECLARE @ERROR_MESSAGE NVARCHAR(4000);
DECLARE @Queuename NVARCHAR(200) = 'Finance AR Reprocess Statement Allocations Status'
DECLARE @QueuesToInclude TABLE
(
    QueueID UNIQUEIDENTIFIER NULL,
    QueueName NVARCHAR(255) NOT NULL
);
DECLARE @DeletedWorkQueueItems_Maintenance TABLE
(
WorkQueueItemID UNIQUEIDENTIFIER NOT NULL
)

-- Set variables, modify the @DaysToKeep to reflect the required retention period
--SET @DaysToKeep = 365;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);

select @Threshold

-- Create maintenance table to hold the WorkQueueItem(s) we want to delete

--IF OBJECT_ID(N'DeletedWorkQueueItems_Maintenance', N'U') IS NULL
--BEGIN
--    CREATE TABLE [DeletedWorkQueueItems_Maintenance]
--    (
--        WorkQueueItemID UNIQUEIDENTIFIER NOT NULL,
--	finished datetime
--    );
--END;

-- Insert QueueNames, update the VALUES below to reflext the name of the Queues you want to target
INSERT INTO @QueuesToInclude (QueueName)
VALUES (@Queuename);

-- Update QueueIDs
UPDATE @QueuesToInclude
SET QI.QueueID = Q.id
FROM BPAWorkQueue AS Q WITH (NOLOCK) 
INNER JOIN @QueuesToInclude AS QI ON QI.QueueName = Q.[name];

select * from @QueuesToInclude
-- If any of the queue names do not exits stop the script and print and error
IF EXISTS (SELECT 1 FROM @QueuesToInclude WHERE QueueID IS NULL)
BEGIN
    PRINT 'One or more of the queue names provided does not exist see the results tab for these queues, update the names and re-run the query. No data has been modified, the script has been terminated';
    SELECT 'This Queue Does Not Exist',
           QueueName
    FROM @QueuesToInclude
    WHERE QueueID IS NULL;
    RETURN;
END;

-- Get WorkQueueItem(s) we want to delete
BEGIN TRY
    BEGIN TRANSACTION;

		INSERT INTO @DeletedWorkQueueItems_Maintenance
		(
			WorkQueueItemID			
		)
		SELECT I.id
		FROM BPAWorkQueueItem AS I
		INNER JOIN @QueuesToInclude AS QI
			ON QI.QueueID = I.queueid
		LEFT JOIN BPAWorkQueueItem AS inext
			ON I.id = inext.id
			   AND inext.attempt = I.attempt + 1
		LEFT JOIN @DeletedWorkQueueItems_Maintenance AS WM
			ON WM.WorkQueueItemID = I.id
		WHERE inext.id IS NULL
			  AND WM.WorkQueueItemID IS NULL
			  --AND I.finished < @Threshold
			  AND datepart(year,cast(I.finished as date)) in (2024)
			  AND datepart(MONTH,cast(I.finished as date)) in (1,2,3,4,5,6,7,8,9,10,11)
			  --AND datepart(WEEK,cast(I.finished as date)) in (49,50)
			  --AND datepart(DAY,cast(I.finished as date)) in (15,16,17,18,19)
			  AND QI.QueueID IS NOT NULL;


select count(*) as 'TotalToDelete' from @DeletedWorkQueueItems_Maintenance
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

-- Delete BPAWorkQueueItem records in batches of 25,000
WHILE (2 > 1)
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE TOP (25000) WQI
    FROM BPAWorkQueueItem AS WQI
    INNER JOIN @DeletedWorkQueueItems_Maintenance AS WM
        ON WM.WorkQueueItemID = WQI.id;

    -- If no records are left to delete commit the transaction and break out of the loop
    IF @@ROWCOUNT = 0
    BEGIN
        COMMIT TRANSACTION;
        BREAK;
    END;

    -- Commit transaction
    COMMIT TRANSACTION;

    -- 1 second delay to allow other operations to access BPAWorkQueueItem
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