
--with cte_cleanup
--as
--(select ROW_NUMBER() over (partition by ident order by ident ) as rownum,
-- [id]
--      ,[queueid]
--      ,[keyvalue]
--      ,[status]
--      ,[attempt]
--      ,[loaded]
--      ,[completed]
--      ,[exception]
--      ,[exceptionreason]
--      ,[deferred]
--      ,[worktime]
--      ,[data]
--      ,[queueident]
--      ,[ident]
--      ,[sessionid]
--      ,[priority]
--      ,[prevworktime]
--      ,[attemptworktime]
--      ,[finished]
--      ,[exceptionreasonvarchar]
--      ,[exceptionreasontag]
--      ,[encryptid]
--      ,[lastupdated]
--      ,[locktime]
--      ,[lockid]
--from [dbo].[BPAWorkQueueItemRestore] 
--)
--delete from cte_cleanup where rownum > 1




--select ident, count(*)'rowcount' from [dbo].[BPAWorkQueueItemRestore]
--group by id, ident
--having count(*) > 1
--order by id,ident
