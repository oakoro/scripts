--select * from [dbo].[BPACaseLock]

select * from (
select 
id,ident,
datalength(isnull([loaded],getdate()))[loaded],
datalength(isnull([completed],getdate()))[completed],
datalength(isnull([exception],getdate()))[exception],
datalength(isnull([deferred],getdate()))[deferred],
datalength(isnull([finished],getdate()))[finished]
from BPAWorkQueueItem
)a
where [loaded] <> 8 or [completed] <> 8 or [exception] <> 8 or [deferred] <> 8 or [finished] <> 8