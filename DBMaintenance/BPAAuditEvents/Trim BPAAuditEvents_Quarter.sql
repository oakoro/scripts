  DECLARE @delTable table (eventid int)
  DECLARE @count int, @eventid int
 

  insert @delTable
  select eventid FROM [dbo].[BPAAuditEvents]
  where DATEPART(YEAR,[eventdatetime]) = '2024' --18726
  and DATEPART(QUARTER,[eventdatetime]) = '3'
  and DATEPART(MONTH,[eventdatetime]) = '8'
  --and DATEPART(week,[eventdatetime]) = '32'

  while (select count(*) from @delTable) > 0
  begin
  select top 1 @eventid = eventid from @delTable
  delete [dbo].[BPAAuditEvents] where eventid = @eventid
  print convert(varchar(10),@eventid)+' deleted'
  delete @delTable where eventid = @eventid
  end
  select eventid from @delTable
  
   --select distinct DATEPART(YEAR,[eventdatetime]),DATEPART(QUARTER,[eventdatetime]),
   --DATEPART(MONTH,[eventdatetime]) 
   --FROM [dbo].[BPAAuditEvents]
   --order by DATEPART(MONTH,[eventdatetime]) ,DATEPART(QUARTER,[eventdatetime])





--select min(eventdatetime), max(eventdatetime) from BPAAuditEvents



select eventdatetime, eventid
from BPAAuditEvents
where DATEDIFF(day,eventdatetime,GETDATE()) > 1300
order by eventdatetime desc

 select eventdatetime, DATEPART(YEAR,[eventdatetime])[YEAR],DATEPART(QUARTER,[eventdatetime])[QUARTER],
   DATEPART(MONTH,[eventdatetime])[MONTH],DATEDIFF(DAY,eventdatetime,GETDATE())'Age'
   FROM [dbo].[BPAAuditEvents]
   order by eventdatetime,DATEPART(MONTH,[eventdatetime]) ,DATEPART(QUARTER,[eventdatetime])



   delete BPAAuditEvents
   where DATEDIFF(day,eventdatetime,GETDATE()) > 21 
   /*
   >1300 == 439
   >1000 == 10
   >500 == 9070
   >400 == 10552
   >200 == 68114
   >100 == 76044
   >50 == 40302
   >21 == 23551
   */



  