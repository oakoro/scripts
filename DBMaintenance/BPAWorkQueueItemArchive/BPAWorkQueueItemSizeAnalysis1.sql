

SELECT 
		[name][Queuename]
	  ,datalength(i.[id])[id]
      ,datalength([queueid])[queueid]
      ,datalength([keyvalue])[keyvalue]
      ,datalength([status])[status]
      ,datalength([attempt])[attempt]
      ,datalength([loaded])[loaded]
      ,datalength([completed])[completed]
      ,datalength([exception])[exception]
      ,datalength([exceptionreason])[exceptionreason]
      ,datalength([deferred])[deferred]
      ,datalength([worktime])[worktime]
      ,datalength([data])[data]
      ,datalength([queueident])[queueident]
      ,datalength(i.[ident])[ident]
      ,datalength([sessionid])[sessionid]
      ,datalength([priority])[priority]
      ,datalength([prevworktime])[prevworktime]
      ,datalength([attemptworktime])[attemptworktime]
      ,datalength([finished])[finished]
      ,datalength([exceptionreasonvarchar])[exceptionreasonvarchar]
      ,datalength([exceptionreasontag])[exceptionreasontag]
      ,datalength(i.[encryptid])[encryptid]
      ,datalength([lastupdated])[lastupdated]
      ,datalength([locktime])[locktime]
      ,datalength([lockid])[lockid]
      ,datalength([sla])[sla]
      ,datalength([sladatetime])[sladatetime]
      ,datalength([processname])[processname]
      ,datalength([issuggested])[issuggested]
  FROM [dbo].[BPAWorkQueueItem] i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
  order by data desc

  --select q.name 'Queuename',i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id

GO

select top 100 name, data
  FROM [dbo].[BPAWorkQueueItem] i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
  where name in ('Snap Survey Reporting','Snap Survey Archive')
  ORDER BY NEWID();


