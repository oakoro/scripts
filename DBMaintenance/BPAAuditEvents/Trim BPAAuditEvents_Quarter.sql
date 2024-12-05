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
  