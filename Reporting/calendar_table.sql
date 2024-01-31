--set start variables
declare @period_length_days     as int      = 21
declare @start_dt               as datetime = getdate()
declare @end_dt                 as datetime = dateadd(day,@period_length_days,getdate())

--declare table
declare @my_calender table (recid int identity(1,1), 
                            my_datetime     datetime, 
                            my_year         int, 
                            my_month        int, 
                            my_day          int, 
                            my_hour         int)
                            --of course you can add multiple more: iso_wk, minute, second etc etc

--fill table
declare @loop_dt as datetime = @start_dt
    
    --loop from start_dt to end_dt, by adding 1 hour each cycle, until loop_dt = end_dt
    while @loop_dt <> @end_dt 
    begin
    insert into @my_calender 
        select 
            @loop_dt
        ,   datepart(year,@loop_dt)
        ,   datepart(month,@loop_dt)
        ,   datepart(day,@loop_dt)
        ,   datepart(hour,@loop_dt)
        
        

    set @loop_dt = dateadd(hour,1,@loop_dt)

    end
    
    select * from @my_calender