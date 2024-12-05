
-- Declare variables
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;
DECLARE @ERROR_SEVERITY INT;
DECLARE @ERROR_STATE INT;
DECLARE @ERROR_NUMBER INT;
DECLARE @ERROR_LINE INT;
DECLARE @ERROR_MESSAGE NVARCHAR(4000);
DECLARE @Queuename NVARCHAR(200) = 'ES001 - Executor'
DECLARE @QueuesToInclude TABLE
(
    QueueID UNIQUEIDENTIFIER NULL,
    QueueName NVARCHAR(255) NOT NULL
);

-- Set variables, modify the @DaysToKeep to reflect the required retention period
SET @DaysToKeep = 365;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);

-- Create maintenance table to hold the WorkQueueItem(s) we want to delete
IF OBJECT_ID(N'DeletedWorkQueueItems_Maintenance', N'U') IS NULL
BEGIN
    CREATE TABLE [DeletedWorkQueueItems_Maintenance]
    (
        WorkQueueItemID UNIQUEIDENTIFIER NOT NULL
    );
END;

-- Insert QueueNames, update the VALUES below to reflext the name of the Queues you want to target
INSERT INTO @QueuesToInclude (QueueName)
VALUES (@Queuename);

-- Update QueueIDs
UPDATE @QueuesToInclude
SET QI.QueueID = Q.id
FROM BPAWorkQueue AS Q WITH (NOLOCK) 
INNER JOIN @QueuesToInclude AS QI ON QI.QueueName = Q.[name];

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


		INSERT INTO DeletedWorkQueueItems_Maintenance
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
		LEFT JOIN DeletedWorkQueueItems_Maintenance AS WM
			ON WM.WorkQueueItemID = I.id
		WHERE inext.id IS NULL
			  AND WM.WorkQueueItemID IS NULL
			  --AND I.finished < @Threshold
			  AND datepart(year,convert(date,I.finished)) = '2024'
			  AND datepart(month,convert(date,I.finished)) in ('6','7','8')
			  --AND datepart(week,convert(date,I.finished)) in ('23')
			  AND QI.QueueID IS NOT NULL;

	SELECT COUNT(*) FROM DeletedWorkQueueItems_Maintenance





