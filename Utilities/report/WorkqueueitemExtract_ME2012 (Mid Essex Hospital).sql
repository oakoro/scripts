select top 2* from BPAWorkQueueItem
select top 2* from dbo.BPAWorkQueue

--[R] UBRN Information Extraction - Extract
--[R] UBRN Information Extraction - Extract
select top 20 
q.name 'Queuename',
i.status,
i.attempt,
i.loaded,
i.completed,
case 
when i.exception is null then 'No Exception'
else 'Exception'
end 'exception',
case 
when i.exceptionreason is null then 'No Exception'
else i.exceptionreason
end 'exceptionreason',
i.deferred,
i.worktime,
i.data,
s.sessionnumber,
i.attemptworktime,
i.finished,
i.exceptionreasontag,
i.lastupdated
from dbo.BPAWorkQueueItem i with (nolock) join dbo.BPAWorkQueue q with (nolock) 
on i.queueid = q.id
join dbo.BPASession s with (nolock) on s.sessionid = i.sessionid
where q.name = '[R] UBRN Information Extraction - Extract' and i.exceptionreason is not null