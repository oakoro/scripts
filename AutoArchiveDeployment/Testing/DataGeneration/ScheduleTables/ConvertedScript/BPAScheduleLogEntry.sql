--select * from [dbo].[BPAScheduleLogEntry]
--select * from [dbo].[BPAScheduleLogEntry_data_1306] where [taskid] = 'Null'

set identity_insert [dbo].[BPAScheduleLogEntry] on

INSERT INTO [dbo].[BPAScheduleLogEntry]
           ([id]
		   ,[schedulelogid]
           ,[entrytype]
           ,[entrytime]
           ,[taskid]
           ,[logsessionnumber]
           ,[terminationreason]
           ,[stacktrace])
select     convert(int,[id])
		   ,[schedulelogid]
           ,[entrytype]
           ,convert(datetime,[entrytime],103)
           --,isnull([taskid],0)
		   ,replace([taskid],'Null',0)
           ,replace([logsessionnumber],'Null',0)
           ,replace([terminationreason],'Null',0)
           ,replace([stacktrace],'Null',0)
from [dbo].[BPAScheduleLogEntry_data_1306]


--delete [dbo].[BPAScheduleLogEntry_data_1306]
--where id = 'Completion time: 2024' 