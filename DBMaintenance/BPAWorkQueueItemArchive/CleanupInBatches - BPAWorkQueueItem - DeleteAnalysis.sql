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
DECLARE @QueueToDelete VARCHAR(100) = 'N002 - BeachHaemoRostering_Roster'

-- Set the variables
SET @DaysToKeep = 90;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);
SET @TableName = 'BPAWorkQueueItem';


;
declare @queuetabl table (Queuename varchar(100),finished datetime)

insert @queuetabl
select q.name 'Queuename',i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
where i.finished is not null and i.finished < @Threshold and q.name not in ('PR004 - Executor')

select Queuename, COUNT(*)'NoOfRowsToDelete' from @queuetabl group by Queuename order by NoOfRowsToDelete desc;

;
with
cte_summary
as
(
select convert(date,finished)'Date', datepart(year,convert(date,finished))'year',datepart(month,convert(date,finished))'month',
datepart(week,convert(date,finished))'week',COUNT(*)'NoOfRowsToDelete' 
from @queuetabl where Queuename = @QueueToDelete
group by convert(date,finished),datepart(year,convert(date,finished)),datepart(month,convert(date,finished)),datepart(week,convert(date,finished))
)
select year,month,week,sum(NoOfRowsToDelete)'NoOfRowsToDelete' from cte_summary
group by year,month,week
order by year,month,week