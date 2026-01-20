
--select * from dbo.BPAWorkQueueItem i join dbo.BPAWorkQueue q on i.queueid = q.id
--where q.name = 'Web Enquiries - UpdateEntries - Work Queue' and completed is not null
--order by completed
--select * from dbo.BPAWorkQueue
--where name in ('BPC - Regular Valuations')

-- Declare variables
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;
DECLARE @TableName sysname;
DECLARE @TotalRowCount DECIMAL(38, 2);
DECLARE @ToDeleteRowCount DECIMAL(38, 2);
DECLARE @TableSizeInMB DECIMAL(38, 2);
DECLARE @QueueToDelete VARCHAR(100) = 'Finance Match Off Executor'

-- Set the variables
SET @DaysToKeep = 30;
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

;
with
cte_summary
as
(
select Queuename,convert(date,finished)'Date', datepart(year,convert(date,finished))'year',datepart(month,convert(date,finished))'month',
datepart(week,convert(date,finished))'week',COUNT(*)'NoOfRowsToDelete' 
from @queuetabl --where Queuename = @QueueToDelete
group by Queuename,convert(date,finished),datepart(year,convert(date,finished)),datepart(month,convert(date,finished)),datepart(week,convert(date,finished))
)
select 
Queuename,
--year,
month,
--week,
sum(NoOfRowsToDelete)'NoOfRowsToDelete' from cte_summary
group by 
Queuename,
--year,
month
--week
order by 
Queuename,
--year,
month
--,week