set identity_insert [dbo].[BPAWorkQueueItemCopy] on
INSERT INTO [dbo].[BPAWorkQueueItemCopy]
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
SELECT  
[id]
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
      --,[attemptworktime]
      --,[finished]
      --,[exceptionreasonvarchar]
      --,[exceptionreasontag]
      ,[encryptid]
      --,[lastupdated]
      ,[locktime]
      ,[lockid]
  FROM [dbo].[BPAWorkQueueItem] s
 WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[BPAWorkQueueItemCopy] t
        WHERE t.ident = s.ident
    )
--    ORDER BY s.ident;
set identity_insert [dbo].[BPAWorkQueueItemCopy] off