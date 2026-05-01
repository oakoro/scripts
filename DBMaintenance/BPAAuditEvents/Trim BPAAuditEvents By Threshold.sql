DECLARE @DaysToKeep INT =  datediff(day,'2026-01-01',getdate())
select @DaysToKeep
-----------------
DECLARE @Threshold DATETIME = DATEADD(DAY,-@DaysToKeep,GETDATE())

select @Threshold

declare @deltable table (
	year sysname,
	quarter sysname,
	month sysname,
	week sysname
	)

declare @year sysname, @quarter sysname, @month sysname, @week sysname

;with cte
as
(
select  eventid,convert(date,eventdatetime)'Eventdate' from dbo.BPAAuditEvents with (nolock)
where eventdatetime < @Threshold
)
insert @deltable(year,quarter,month,week)
select DATEPART(year,Eventdate)'Year',
DATEPART(quarter,Eventdate)'Quarter',
DATEPART(month,Eventdate)'Month', 
DATEPART(week,Eventdate)'Week'
--COUNT(*)'RecordCount'
from cte
group by DATEPART(year,Eventdate),DATEPART(quarter,Eventdate),
DATEPART(month,Eventdate),DATEPART(week,Eventdate)
order by Year,Quarter,Month,Week
--@year sysname, @quarter sysname, @month sysname, @week 

 while (select count(*) from @delTable) > 0
  begin
  select top 1 @year = year, @quarter = quarter, @month = month, @week = week from @delTable
  
  delete from [dbo].[BPAAuditEvents] 
  where  DATEPART(year,eventdatetime) = @year
	and  DATEPART(quarter,eventdatetime) = @quarter
	and	 DATEPART(month,eventdatetime) = @month
	and  DATEPART(week,eventdatetime) = @week

  
  delete @delTable 
  where year= @year and quarter = @quarter and month = @month and week = @week
  end
  select * from @delTable



 