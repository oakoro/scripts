--select * from [dbo].[BPAProcess] where name = 'Wiltshire Council - Manage Post Box SPO GRAPH API v2'

with cte_1
as
(
select 
logid,
l.stagename,
l.objectname,
l.processname,
isnull(datalength(l.[result]), 1)[result] , 
isnull(datalength(l.[attributexml]), 1) [attributexml]
from 
dbo.BPASession s with (nolock) join dbo.BPASessionLog_NonUnicode l with (nolock) on s.sessionnumber = l.sessionnumber
join dbo.BPAProcess p with (nolock) on p.processid = s.processid
where p.name = 'Wiltshire Council - Manage Post Box SPO GRAPH API v2' --and CAST(s.startdatetime as date) = '2024-09-30'
)
select --objectname, 
stagename, 
(sum([result])+sum([attributexml]))/1024/1024'StorageUsed' from cte_1
group by --objectname 
stagename
order by StorageUsed desc
