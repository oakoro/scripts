--set start variables
declare @period_length_days     as int      = -30
declare @start_dt               as datetime 
declare @end_dt                 as datetime 
select @start_dt = dateadd(day,@period_length_days,max(startdatetime)), @end_dt = max(startdatetime) from dbo.BPASession

declare @my_calender table (recid int identity(1,1), 
                            my_datetime     datetime, 
                            my_year         int, 
                            my_month        int, 
                            my_day          int,
							my_weekday		tinyint,
                            my_hour         int)
                            

--fill table
declare @loop_dt as datetime = @start_dt
    
    --loop from start_dt to end_dt, by adding 1 hour each cycle, until loop_dt = end_dt
    while @loop_dt <> @end_dt 
    begin
    insert into @my_calender 
        select 
            stuff(convert(varchar(20),@loop_dt,121),15,19,'00:00')
        ,   datepart(year,@loop_dt)
        ,   datepart(month,@loop_dt)
        ,   datepart(day,@loop_dt)
		,   datepart(WEEKDAY,@loop_dt)
        ,   datepart(hour,@loop_dt)
        
        

    set @loop_dt = dateadd(hour,1,@loop_dt)

    end
    
 
	;with cte
as
(
select  stuff(convert(varchar(20),startdatetime,121),15,19,'00:00')'startdatetime2', 
DATEPART(hh,startdatetime)'Hour',DATEPART(dd,startdatetime)'Day', DATEPART(ww,startdatetime)'Week',DATEPART(yy,startdatetime)'Year',
ROW_NUMBER() over (partition by DATEPART(yy,startdatetime) order by DATEPART(yy,startdatetime),DATEPART(ww,startdatetime) ,DATEPART(dd,startdatetime), DATEPART(hh,startdatetime) asc ) AS RowNum
from dbo.BPASession 
 where startdatetime > @start_dt
)

select a.my_datetime'Daytime',case
when a.my_weekday = 1 then 'Sunday'
when a.my_weekday = 2 then 'Monday'
when a.my_weekday = 3 then 'Tuesday'
when a.my_weekday = 4 then 'Wednesday'
when a.my_weekday = 5 then 'Thursday'
when a.my_weekday = 6 then 'Friday'
when a.my_weekday = 7 then 'Saturday'
end
AS 'Weekday',
a.my_hour'Hour', isnull(startdatetime2,'No session')'ProductionDate',
count(RowNum) 'TotalSession'
from @my_calender a left join cte b on a.my_datetime = b.startdatetime2
group by  a.my_datetime,a.my_weekday,a.my_hour, isnull(startdatetime2,'No session')

/*Verification**************************
select sessionnumber,startdatetime,stuff(convert(varchar(20),startdatetime,121),15,19,'00:00') from dbo.BPASession 
where startdatetime > @start_dt and stuff(convert(varchar(20),startdatetime,121),15,19,'00:00') like '2024-01-01 17:00%'
**************************************************
*/


