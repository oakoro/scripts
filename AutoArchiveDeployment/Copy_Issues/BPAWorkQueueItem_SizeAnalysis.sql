/****** Script for SelectTopNRows command from SSMS  ******/
SELECT isnull(datalength([id]),0)'id'
      ,isnull(datalength([queueid]),0)'queueid'
      ,isnull(datalength([keyvalue]),0)'keyvalue'
      ,isnull(datalength([status]),0)'status'
      ,isnull(datalength([attempt]),0)'attempt'
      ,isnull(datalength([loaded]),0)'loaded'
      ,isnull(datalength([completed]),0)'completed'
      ,isnull(datalength([exception]),0)'exception'
      ,isnull(datalength([exceptionreason]),0)'exceptionreason'
      ,isnull(datalength([deferred]),0)'deferred'
      ,isnull(datalength([worktime]),0)'worktime'
      ,isnull(datalength([data]),0)'data'
      ,isnull(datalength([queueident]),0)'queueident'
      ,isnull(datalength([ident]),0)'ident'
      ,isnull(datalength([sessionid]),0)'sessionid'
      ,isnull(datalength([priority]),0)'priority'
      ,isnull(datalength([prevworktime]),0)'prevworktime'
      ,isnull(datalength([attemptworktime]),0)'attemptworktime]'
      ,isnull(datalength([finished]),0)'finished'
      ,isnull(datalength([exceptionreasonvarchar]),0)'exceptionreasonvarchar'
      ,isnull(datalength([exceptionreasontag]),0)'exceptionreasontag'
      ,isnull(datalength([encryptid]),0)'encryptid'
      ,isnull(datalength([lastupdated]),0)'lastupdated'
      ,isnull(datalength([locktime]),0)'locktime'
      ,isnull(datalength([lockid]),0)'lockid'
  FROM [dbo].[BPAWorkQueueItem] 
  where isnull(datalength([data]),0) > 80000 and finished is not null
  order by isnull(datalength([data]),0)

  --select top 2*   FROM [dbo].[BPAWorkQueueItem] where finished is not null --84419
  --select count(*)   FROM [dbo].[BPAWorkQueueItem] where finished is not null --84419
  select count(*)   FROM [dbo].[BPAWorkQueueItem] where isnull(datalength([data]),0) > 285933

  select min(isnull(datalength([data]),0))'MinData', AVG(isnull(datalength([data]),0))'AvgData'
  FROM [dbo].[BPAWorkQueueItem]


  select ident,id,queueid,status,loaded,completed,isnull(datalength([data]),0)/1024 'XMLSizeInKilobyte'
   FROM [dbo].[BPAWorkQueueItem] 
  where isnull(datalength([data]),0) > 80000 and finished is not null
  order by isnull(datalength([data]),0)