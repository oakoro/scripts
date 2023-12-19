SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @DaysToKeep INT,@Threshold DATETIME,@ToDeleteRowCount INT


SET @DaysToKeep = 14;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);
set identity_insert [dbo].[BPAWorkQueueItemRetain] ON;

with cte_delete
as
(SELECT i.id,i.ident
FROM BPAWorkQueueItem AS i 
LEFT JOIN BPAWorkQueueItem AS inext
    ON i.id = inext.id
       AND inext.attempt = i.attempt + 1
WHERE inext.id IS NULL
      AND i.finished < @threshold
)

--select * from BPAWorkQueueItem where ident not in (select ident from cte_delete ) 

INSERT INTO [dbo].[BPAWorkQueueItemRetain]
           ([id]
           ,[queueid]
           ,[keyvalue]
           ,[status]
           ,[attempt]
           ,[loaded]
           ,[completed]
           ,[exception]
           ,[exceptionreason]
           ,[deferred]
           ,[worktime]
           ,[data]
           ,[queueident]
		   ,[ident]
           ,[sessionid]
           ,[priority]
           ,[prevworktime]
           ,[encryptid]
           ,[locktime]
           ,[lockid])
  select top 1
           id 
           ,queueid
           ,keyvalue
           ,status
           ,attempt
           ,loaded
           ,completed
           ,exception
           ,exceptionreason
           ,deferred
           ,worktime
           ,data
           ,queueident
		   ,ident
           ,sessionid
           ,priority
           ,prevworktime
           ,encryptid
           ,locktime
           ,lockid
from [dbo].[BPAWorkQueueItem] where ident not in (select ident from cte_delete )
set identity_insert [dbo].[BPAWorkQueueItemRetain] OFF;