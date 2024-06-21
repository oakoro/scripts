--select * from [dbo].[BPASchedule]
--select * from [dbo].[bpascheduleNew]

set identity_insert [dbo].[BPASchedule] on

INSERT INTO [dbo].[BPASchedule]
           ([id]
		   ,[name]
           ,[description]
           ,[initialtaskid]
           ,[retired]
           ,[versionno]
           ,[deletedname])
select     id
           ,name 
           ,description
           ,initialtaskid
           ,retired
           ,versionno
           ,deletedname
from [dbo].[bpascheduleNew]
