select top 20* from dbo.BPAAuditEvents with (nolock) --where gTgtProcID is not null
where gTgtProcID in (select processid from dbo.BPAProcess with (nolock))
select top 1* from dbo.BPAProcess with (nolock)
--where processid = 'B5B48B05-9B66-4D08-9306-8FB34609F7EA'

select eventdatetime,eventid,sNarrative,comments,EditSummary,
p.name,p.name
from 
dbo.BPAAuditEvents e with (nolock)
join dbo.BPAProcess p with (nolock) 
on e.gTgtProcID = p.processid
order by eventdatetime