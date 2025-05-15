--select * from dbo.BPAWorkQueueItem i join dbo.BPAWorkQueue q on i.queueid = q.id
--where q.name = 'Web Enquiries - UpdateEntries - Work Queue' and completed is not null
--order by completed
--select * from dbo.BPAWorkQueue
--where name in ('BPC - Regular Valuations')

--Queue - Portal Bot Declare variables
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;
DECLARE @TableName sysname;
DECLARE @TotalRowCount DECIMAL(38, 2);
DECLARE @ToDeleteRowCount DECIMAL(38, 2);
DECLARE @TableSizeInMB DECIMAL(38, 2);
DECLARE @QueueToDelete VARCHAR(100) = 'Finance AR Reprocess Statement Allocations Status'

-- Set the variables
SET @DaysToKeep = 365;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);
SET @TableName = 'BPAWorkQueueItem';


;
declare @queuetabl table (Queuename varchar(100),finished datetime)

insert @queuetabl
select q.name 'Queuename',i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
where i.finished is not null and i.finished < @Threshold 
--and 
--q.name not in ('Allocate Payroll - Email Reminders','Allocate Payroll - Jotform Received','Allocate Payroll - Jotform Sent','Allocate Payroll - IQX')

select Queuename, COUNT(*)'NoOfRowsToDelete' from @queuetabl group by Queuename order by NoOfRowsToDelete desc;
/*
cast(finished as date)'day',
datepart(year,cast(finished as date))'year',
datepart(MONTH,cast(finished as date))'month',
datepart(WEEK,cast(finished as date))'week',
datepart(DAY,cast(finished as date))'day'
*/

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
from @queuetabl where Queuename = @QueueToDelete
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