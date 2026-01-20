--select top 1* from BPAAuditEvents order by eventid desc --2021-07-16 20:24:57.920
DECLARE @DaysToKeep INT = 30

-----------------
DECLARE @Threshold DATETIME = DATEADD(DAY,-@DaysToKeep,GETDATE())

select @Threshold

;with cte
as
(
select  eventid,convert(date,eventdatetime)'Eventdate' from dbo.BPAAuditEvents with (nolock)
where eventdatetime < '2025-12-21 13:00:23.330'
)
select DATEPART(year,Eventdate)'Year',
DATEPART(quarter,Eventdate)'Quarter',
DATEPART(month,Eventdate)'Month', 
DATEPART(week,Eventdate)'Week',
COUNT(*)'RecordCount'
from cte
group by DATEPART(year,Eventdate),DATEPART(quarter,Eventdate),
DATEPART(month,Eventdate),DATEPART(week,Eventdate)
order by Year,Quarter,Month,Week


 