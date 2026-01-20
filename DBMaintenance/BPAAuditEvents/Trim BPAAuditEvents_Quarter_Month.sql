  DECLARE @delTable table (eventid int)
  DECLARE @count int, @eventid int
 

  insert @delTable
  select eventid FROM [dbo].[BPAAuditEvents]
  where DATEPART(YEAR,[eventdatetime]) = '2025' --18726
  and DATEPART(QUARTER,[eventdatetime]) = '4'
  and DATEPART(MONTH,[eventdatetime]) = '11'
  --and DATEPART(week,[eventdatetime]) = '32'

 -- select * from [dbo].[BPAAuditEvents] where eventid in (select * from @delTable) order by eventdatetime

  while (select count(*) from @delTable) > 0
  begin
  select top 1 @eventid = eventid from @delTable
  delete [dbo].[BPAAuditEvents] where eventid = @eventid
  print convert(varchar(10),@eventid)+' deleted'
  delete @delTable where eventid = @eventid
  end
  select eventid from @delTable