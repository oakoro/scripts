SELECT Queuename, COUNT(*)[RowCount],sum(TotalSizeByte)/1024[TotalSizekByte]
FROM
(
SELECT 
		[name][Queuename],i.[ident]
	  ,(ISNULL(datalength(i.[id]),0)
      +ISNULL(datalength([queueid]),0)
      +ISNULL(datalength([keyvalue]),0)
      +ISNULL(datalength([status]),0)
      +ISNULL(datalength([attempt]),0)
      +ISNULL(datalength([loaded]),0)
      +ISNULL(datalength([completed]),0)
      +ISNULL(datalength([exception]),0)
      +ISNULL(datalength([exceptionreason]),0)
      +ISNULL(datalength([deferred]),0)
      +ISNULL(datalength([worktime]),0)
      +ISNULL(datalength([data]),0)
      +ISNULL(datalength([queueident]),0)
      +ISNULL(datalength(i.[ident]),0)
      +ISNULL(datalength([sessionid]),0)
      +ISNULL(datalength([priority]),0)
      +ISNULL(datalength([prevworktime]),0)
      +ISNULL(datalength([attemptworktime]),0)
      +ISNULL(datalength([finished]),0)
      +ISNULL(datalength([exceptionreasonvarchar]),0)
      +ISNULL(datalength([exceptionreasontag]),0)
      +ISNULL(datalength(i.[encryptid]),0)
      +ISNULL(datalength([lastupdated]),0)
      +ISNULL(datalength([locktime]),0)
      +ISNULL(datalength([lockid]),0)
      +ISNULL(datalength([sla]),0)
      +ISNULL(datalength([sladatetime]),0)
      +ISNULL(datalength([processname]),0)
      +ISNULL(datalength([issuggested]),0))[TotalSizeByte]
  FROM [dbo].[BPAWorkQueueItem] i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id
  --order by data desc
  )list
  GROUP BY Queuename
  --select q.name 'Queuename',i.finished from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock)on i.queueid = q.id

GO


