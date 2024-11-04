  DECLARE @delTable table (eventid int)
  DECLARE @count int, @eventid int

  insert @delTable
  select eventid FROM [dbo].[BPAAuditEvents]
  where DATEPART(YEAR,[eventdatetime]) in ('2023')--60018

  while (select count(*) from @delTable) > 0
  begin
  select top 1 @eventid = eventid from @delTable
  delete [dbo].[BPAAuditEvents] where eventid = @eventid
  print convert(varchar(10),@eventid)+' deleted'
  delete @delTable where eventid = @eventid
  end
  select eventid from @delTable

    select distinct DATEPART(YEAR,[eventdatetime]) FROM [dbo].[BPAAuditEvents]
	/*
	2023
2024
2022
2021
2020
*/
  

  