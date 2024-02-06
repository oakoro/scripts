DECLARE @minDateTime AS DATETIME;
DECLARE @maxDateTime AS DATETIME;
DECLARE @count int, @int int, @session int
declare @start_dt               as datetime 
declare @end_dt                 as datetime 
declare @period_length_days     as int      = 30

select @start_dt = dateadd(day,-@period_length_days,max(startdatetime)), @end_dt = max(startdatetime) from dbo.BPASession

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
    
   --select * from @my_calender

DECLARE @timetbl TABLE (
sessionnumber int,
temp_startdatetime datetime,
temp_enddatetime datetime
)

DECLARE @timeraw TABLE (Dates datetime,sessionnumber int )

SET NOCOUNT ON


INSERT @timetbl(sessionnumber,temp_startdatetime,temp_enddatetime)
select  sessionnumber,startdatetime, isnull(enddatetime,getdate()) from dbo.BPASession 
WHERE DATEDIFF(DD,startdatetime,GETDATE()) <= @period_length_days 

--SELECT * FROM @timetbl ORDER BY temp_startdatetime DESC

SELECT @count = COUNT(*) FROM @timetbl

WHILE @count > 0
BEGIN
SELECT TOP 1 @session =  sessionnumber, @minDateTime =temp_startdatetime, @maxDateTime = temp_enddatetime FROM @timetbl ;
IF stuff(convert(varchar(20),@minDateTime,121),15,19,'00:00') <> stuff(convert(varchar(20),@maxDateTime,121),15,19,'00:00')
	BEGIN
	WITH Dates_CTE  
     AS (SELECT @minDateTime AS Dates 
         UNION ALL
         SELECT    Dateadd(HH, 1, Dates)
         FROM   Dates_CTE
         WHERE  Dates < @maxDateTime)
	insert @timeraw([Dates],sessionnumber)
	SELECT Dates,@session
	FROM   Dates_CTE
	OPTION (MAXRECURSION 0) 
	END
	ELSE
	BEGIN
	insert @timeraw([Dates],sessionnumber)
	VALUES(@minDateTime,@session)
	END
DELETE @timetbl WHERE sessionnumber = @session;
SET @count = @count - 1
END

--SELECT * from @timeraw 
	;with cte
as
(
select  sessionnumber,stuff(convert(varchar(20),dates,121),15,19,'00:00')'startdatetime2', 
DATEPART(hh,dates)'Hour',DATEPART(dd,dates)'Day', DATEPART(ww,dates)'Week',DATEPART(yy,dates)'Year',
ROW_NUMBER() over (partition by DATEPART(yy,dates) order by DATEPART(yy,dates),DATEPART(ww,dates) ,DATEPART(dd,dates), DATEPART(hh,dates) asc ) AS RowNum
from @timeraw 
)
--select * from cte order  
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
order by Daytime