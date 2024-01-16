  DECLARE @delTable table (eventid int)
  DECLARE @count int, @eventid int
 

  insert @delTable
  select eventid FROM [dbo].[BPAAuditEvents]
  where DATEPART(YEAR,[eventdatetime]) = '2023' --18726
  and DATEPART(QUARTER,[eventdatetime]) = '4'
  and DATEPART(MONTH,[eventdatetime]) = '10'

  while (select count(*) from @delTable) > 0
  begin
  select top 1 @eventid = eventid from @delTable
  delete [dbo].[BPAAuditEvents] where eventid = @eventid
  print convert(varchar(10),@eventid)+' deleted'
  delete @delTable where eventid = @eventid
  end
  select eventid from @delTable
  

  