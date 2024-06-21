--select * from [dbo].[BPAScheduleLog]
--select * from [dbo].[BPAScheduleLog1306] where [instancetime] = ''
set identity_insert [dbo].[BPAScheduleLog] on
INSERT INTO [dbo].[BPAScheduleLog]
           ([id]
		   ,[scheduleid]
           ,[instancetime]
           ,[firereason]
           ,[servername]
           ,[heartbeat])
select     convert(int,[id])
		   ,convert(int,[scheduleid])
		   --,[instancetime]
           ,convert(datetime,[instancetime],103)
           ,[firereason]
           ,[servername]
           ,convert(datetime,[heartbeat],103)
from [dbo].[BPAScheduleLog1306]



