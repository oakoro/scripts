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
SET @DaysToKeep = 90;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);


--Queue - Portal Bot Declare variables
DECLARE @TableName sysname;
DECLARE @TotalRowCount DECIMAL(38, 2);
DECLARE @ToDeleteRowCount DECIMAL(38, 2);
DECLARE @TableSizeInMB DECIMAL(38, 2);
DECLARE @topQueue nvarchar(255);

DECLARE @queuetabl table (ident bigint,Queuename nvarchar(255),finished datetime);

DECLARE @queuesToDeleteSummary table (Queuename nvarchar(255),RecordCount int);

 -- Set the variables
SET @TableName = 'BPAWorkQueueItem';

INSERT @queuetabl
SELECT i.ident,q.name 'Queuename',i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
WHERE i.finished is not null and i.finished < @Threshold and 
q.name not in 
(SELECT name from @exemptedqueue)

INSERT @queuesToDeleteSummary(Queuename,RecordCount)
SELECT Queuename, COUNT(ident) from @queuetabl 
group by Queuename 

SELECT TOP 1 @topQueue = Queuename from @queuesToDeleteSummary order by RecordCount desc

SELECT * from @queuesToDeleteSummary order by RecordCount desc


--Details of biggest queue to delete
;
with
cte_summary
as
(
select 
cast(finished as date)'date',
datepart(year,cast(finished as date))'year',
datepart(MONTH,cast(finished as date))'month',
datepart(WEEK,cast(finished as date))'week',
datepart(DAY,cast(finished as date))'day',
COUNT(*)'NoOfRowsToDelete' 
from @queuetabl where Queuename = @topQueue
group by 
cast(finished as date),
datepart(year,cast(finished as date)),
datepart(MONTH,cast(finished as date)),
datepart(WEEK,cast(finished as date)),
datepart(DAY,cast(finished as date))
)
select year,month,week,day,sum(NoOfRowsToDelete)'NoOfRowsToDelete' from cte_summary
group by year,month,week,day
order by year,month,week,day

