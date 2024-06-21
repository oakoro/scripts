SELECT TOP 1000*
  FROM [dbo].[BPAScheduleLog] order by id


  SELECT TOP (1000) [id]
      ,[schedulelogid]
      ,[entrytype]
      ,[entrytime]
      ,[taskid]
      ,[logsessionnumber]
      ,[terminationreason]
      ,[stacktrace]
  FROM [dbo].[BPAScheduleLogEntry]
  where schedulelogid in (SELECT TOP 1000 id
  FROM [dbo].[BPAScheduleLog] order by id)
  

  --select * from dbo.bpatask
  --select * from dbo.bpaschedule