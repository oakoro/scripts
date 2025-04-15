--EXEMPTED QUEUES
DECLARE @exemptedqueue TABLE ([name] NVARCHAR(255));

INSERT @exemptedqueue
VALUES
('Allocate Payroll - Email Reminders'),
('Allocate Payroll - Jotform Received'),
('Allocate Payroll - Jotform Sent'),
('Allocate Payroll - IQX')

--DEFINE QUEUE RETENTION
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;
SET @DaysToKeep = 100;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);

-- Declare variables
DECLARE @ERROR_SEVERITY INT;
DECLARE @ERROR_STATE INT;
DECLARE @ERROR_NUMBER INT;
DECLARE @ERROR_LINE INT;
DECLARE @ERROR_MESSAGE NVARCHAR(4000);
DECLARE @Queuename NVARCHAR(200) = 'Finance AR Reprocess Statement Allocations Status'
DECLARE @QueuesToInclude TABLE
(
    QueueID UNIQUEIDENTIFIER NULL,
    QueueName NVARCHAR(255) NOT NULL,
	ident BIGINT,
	finished DATETIME)
	;
DECLARE @DeletedWorkQueueItems_Maintenance TABLE
(
WorkQueueItemID UNIQUEIDENTIFIER NOT NULL
)

INSERT @QueuesToInclude
SELECT DISTINCT q.id, q.name,i.ident, i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
WHERE i.finished is not null and i.finished < @Threshold and 
q.name not in 
(SELECT name from @exemptedqueue)

--SELECT * FROM @QueuesToInclude where ident = 855944

IF EXISTS (SELECT 1 FROM @QueuesToInclude WHERE QueueID IS NULL)
BEGIN
    PRINT 'One or more of the queue names provided does not exist see the results tab for these queues, update the names and re-run the query. No data has been modified, the script has been terminated';
    SELECT 'This Queue Does Not Exist',
           QueueName
    FROM @QueuesToInclude
    WHERE QueueID IS NULL;
    RETURN;
END;

--INSERT INTO @DeletedWorkQueueItems_Maintenance
--		(
--			WorkQueueItemID			
--		)
--		SELECT I.id
--		FROM BPAWorkQueueItem AS I
--		INNER JOIN @QueuesToInclude AS QI
--			ON QI.QueueID = I.queueid
--		LEFT JOIN BPAWorkQueueItem AS inext
--			ON I.id = inext.id
--			   AND inext.attempt = I.attempt + 1
--		LEFT JOIN @DeletedWorkQueueItems_Maintenance AS WM
--			ON WM.WorkQueueItemID = I.id
--		WHERE inext.id IS NULL
--			  AND WM.WorkQueueItemID IS NULL
--			  AND I.finished < @Threshold
--			  --AND datepart(year,cast(I.finished as date)) in (2024)
--			  --AND datepart(MONTH,cast(I.finished as date)) in (1,2,3,4,5,6,7,8,9,10,11)
--			  ----AND datepart(WEEK,cast(I.finished as date)) in (49,50)
--			  ----AND datepart(DAY,cast(I.finished as date)) in (15,16,17,18,19)
--			  AND QI.QueueID IS NOT NULL;


--select count(*) 'Count1'
-- FROM BPAWorkQueueItem AS WQI  WITH (NOLOCK) 
--    INNER JOIN @QueuesToInclude AS WM
--        ON WM.QueueID = WQI.queueid and WM.ident = WQI.ident

--select * from BPAWorkQueueItem where ident  = 1338149
--select * from @QueuesToInclude where ident = 1338149
		

SELECT * FROM @QueuesToInclude
--SELECT count(*) 'Count2' FROM @QueuesToInclude

DECLARE @count INT, @str NVARCHAR(800),@ident BIGINT

SELECT @count = COUNT(*) FROM @QueuesToInclude

while (@count > 0) 
begin
SELECT TOP 1 @ident = ident FROM  @QueuesToInclude
PRINT @ident
SET @str = 'delete * from DBO.BPAWorkQueueItem where ident = '+CONVERT(NVARCHAR(20),@ident)
print @str
delete @QueuesToInclude where ident = @ident
set @count = @count - 1
end


