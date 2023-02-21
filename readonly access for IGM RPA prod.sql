--create login readonlyrpaprod with password = 'uL6VI9DWNQYuquH8'

--create user readonlyrpaprod from login readonlyrpaprod 

--grant select on [dbo].[BPASessionLog_NonUnicode] to readonlyrpaprod
--go
--grant select on [dbo].[BPASession] to readonlyrpaprod
--go
--grant select on [dbo].[BPAWorkQueue] to readonlyrpaprod
--go
--grant select on [dbo].[BPAWorkQueueItem] to readonlyrpaprod
--go
--grant select on [dbo].[BPAResource] to readonlyrpaprod
--go
--grant select on [dbo].[BPAProcess] to readonlyrpaprod
--go
