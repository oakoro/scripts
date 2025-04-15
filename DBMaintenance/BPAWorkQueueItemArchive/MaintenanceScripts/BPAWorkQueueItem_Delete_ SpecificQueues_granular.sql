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


if (object_id('tempdb..#QueuesToInclude','U')) is not null
begin
drop table #QueuesToInclude
end


create table #QueuesToInclude(
    queueID UNIQUEIDENTIFIER NULL,
    queueName NVARCHAR(255) NOT NULL,
	ident BIGINT,
	finished DATETIME,
	created AS cast(finished as date),
	year AS datepart(year,cast(finished as date)),
	month AS datepart(MONTH,cast(finished as date)),
	week AS datepart(WEEK,cast(finished as date)),
	day AS datepart(DAY,cast(finished as date))
)



DECLARE @DeletedWorkQueueItems_Maintenance TABLE
(
WorkQueueItemID UNIQUEIDENTIFIER NOT NULL
)

INSERT #QueuesToInclude
SELECT DISTINCT q.id, q.name,i.ident, i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
WHERE i.finished is not null and i.finished < @Threshold and 
q.name not in 
(SELECT name from @exemptedqueue)



IF EXISTS (SELECT 1 FROM #QueuesToInclude WHERE QueueID IS NULL)
BEGIN
    PRINT 'One or more of the queue names provided does not exist see the results tab for these queues, update the names and re-run the query. No data has been modified, the script has been terminated';
    SELECT 'This Queue Does Not Exist',
           QueueName
    FROM #QueuesToInclude
    WHERE QueueID IS NULL;
    RETURN;
END;


select queueID, year,month,week,day,count(*)'NoOfRowsToDelete' from #QueuesToInclude
group by queueID,year,month,week,day
order by queueID,year,month,week,day

--SELECT * FROM #QueuesToInclude 

DECLARE @Year SMALLINT,@Month TINYINT, @Week TINYINT, @Day TINYINT,@QueueToDelete UNIQUEIDENTIFIER,@Str NVARCHAR(400),@COUNT INT
SELECT TOP 1 @QueueToDelete = queueID, @Year = year, @Month = month,
	@Week= week,@Day = day
FROM 
#QueuesToInclude

--select * from dbo.BPAWorkQueueItem
--where 

--SELECT @COUNT = COUNT(*) FROM #QueuesToInclude
--While (@COUNT > 0)
--Begin
select @QueueToDelete '@QueueToDelete',@Year '@Year',@Month '@Month', @Week '@Week', @Day '@Day'
--select @QueueToDelete ,@Year ,@Month , @Week , @Day 
--select * from dbo.BPAWorkQueueItem i inner join @QueueToDelete d on 

--end

--Verify batch to delete
select * from dbo.BPAWorkQueueItem
where 
queueid = @QueueToDelete and 
datepart(year,cast(finished as date)) = @Year and
datepart(MONTH,cast(finished as date)) = @Month and 
datepart(WEEK,cast(finished as date)) = @Week and 
datepart(DAY,cast(finished as date)) = @Day 

--Next work to create delete script and test