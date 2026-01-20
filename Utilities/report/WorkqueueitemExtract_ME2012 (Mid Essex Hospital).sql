-- select top 2* from BPAWorkQueueItem
--select * from dbo.BPAWorkQueue where name like '%eRS%'

-- select distinct status from dbo.BPAWorkQueueItem


--[R] DOB - eRS to DocPub and Careflow
--[R] DOL - eRS to Lorenzo Upload
--[R] DOS - eRS to Careflow and Southend Upload

select  
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
where q.name 
IN
(
-- '[R] DOB - eRS to DocPub and Careflow'
-- '[R] DOL - eRS to Lorenzo Upload'
'[R] DOS - eRS to Careflow and Southend Upload'
)

and finished is NULL


--and i.exceptionreason is not null