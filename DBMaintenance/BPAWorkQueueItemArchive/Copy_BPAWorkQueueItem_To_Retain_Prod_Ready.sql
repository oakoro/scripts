declare @endident bigint, @currentident bigint, @initident bigint = 0
declare @BatchSize INT = 50000;

select top 1 @endident = ident  from [dbo].[BPAWorkQueueItemRestore] with (nolock)
order by ident desc
select top 1 @initident = ident  from [dbo].[BPAWorkQueueItemRestore] with (nolock)
order by ident 
select top 1 @currentident = ident from [dbo].[BPAWorkQueueItemCopy]
order by ident desc 
select @endident 'endident', @currentident'currentident',@initident'initident'

if @currentident = 0 or @currentident is null
begin
set @currentident = @initident - 1
end

select @endident 'endident', @currentident'currentident',@initident'initident'
while @currentident < @endident
begin
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
           ,[lockid]
		   ,[sla] 
		   ,[sladatetime]
		   ,[processname]
		   ,[issuggested]
		   )
SELECT top (@BatchSize) [id]
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
	  ,[sla] 
	  ,[sladatetime]
	  ,[processname]
	  ,[issuggested]
  FROM [dbo].[BPAWorkQueueItemRestore] 
  where [ident] > @currentident 
		   order by [ident] 
  set identity_insert [dbo].[BPAWorkQueueItemCopy] OFF
select top 1 @currentident = ident from [dbo].[BPAWorkQueueItemCopy]
order by ident desc  
end