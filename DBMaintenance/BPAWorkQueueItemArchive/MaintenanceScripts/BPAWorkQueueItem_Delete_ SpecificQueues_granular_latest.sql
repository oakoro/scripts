SET NOCOUNT ON
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
	queueID UNIQUEIDENTIFIER NOT NULL,
    queueName NVARCHAR(255) NOT NULL,
	finished DATETIME,
	created AS cast(finished as date),
	year AS datepart(year,cast(finished as date)),
	month AS datepart(MONTH,cast(finished as date)),
	week AS datepart(WEEK,cast(finished as date)),
	day AS datepart(DAY,cast(finished as date))
)

DECLARE @QueuesToInclude TABLE(
	queueID UNIQUEIDENTIFIER NOT NULL,
	year SMALLINT,
	month TINYINT ,
	week TINYINT ,
	day SMALLINT ,
	recordCount INT)



DECLARE @DeletedWorkQueueItems_Maintenance TABLE
(
WorkQueueItemID UNIQUEIDENTIFIER NOT NULL
)

INSERT #QueuesToInclude(queueID,queueName,finished)
SELECT TOP 100 i.queueid, q.name, i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
WHERE i.finished is not null and i.finished < @Threshold and 
q.name not in 
(SELECT name from @exemptedqueue)

INSERT @QueuesToInclude(queueID,year,month,week,day,recordCount)
SELECT queueID,year,month,week,day,count(*) FROM #QueuesToInclude
group by queueID,year,month,week,day


DECLARE @Year SMALLINT,@Month TINYINT, @Week TINYINT, @Day TINYINT,@QueueToDelete UNIQUEIDENTIFIER,@Str NVARCHAR(400),@COUNT INT

SELECT @COUNT = COUNT(*) FROM @QueuesToInclude
While (@COUNT > 0)
Begin

SELECT TOP 1 @QueueToDelete = queueid, @Year = year, @Month = month,
	@Week= week,@Day = day
FROM 
@QueuesToInclude ORDER BY day
select @QueueToDelete ,@Year ,@Month , @Week , @Day 
set @Str = 'delete from dbo.BPAWorkQueueItem where queueid = '''+CONVERT(NVARCHAR(50),@QueueToDelete) + ''''
	+' AND datepart(year,cast(finished as date)) = ' +CONVERT(NVARCHAR(10),@Year) +' AND datepart(MONTH,cast(finished as date)) = ' +CONVERT(NVARCHAR(10),@Month)
	+' AND datepart(WEEK,cast(finished as date)) = ' +CONVERT(NVARCHAR(10),@Week) +' AND datepart(DAY,cast(finished as date)) = ' +CONVERT(NVARCHAR(10),@Day)

PRINT (@Str)

DELETE @QueuesToInclude 
WHERE queueid = @QueueToDelete AND year = @Year AND month = @Month 
		AND week = @Week AND day = @Day
select count(*) as RecordCount from @QueuesToInclude
set @count = @count - 1
end
SELECT * FROM @QueuesToInclude 
--SELECT TOP 2 Q.id,I.queueid,Q.name FROM BPAWorkQueueItem I JOIN BPAWorkQueue Q ON I.queueid = Q.ID

--5DD00560-A8D1-4E88-B3F5-476BAB2525D0

--delete wqi
--from dbo.BPAWorkQueueItem wqi JOIN BPAWorkQueue