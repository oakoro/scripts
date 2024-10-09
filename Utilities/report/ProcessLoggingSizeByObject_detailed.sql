select objectname, sum(result)/1024/1024[result],sum(attributexml)/1024/1024[attributexml] from (select 
--logid,
CAST(s.startdatetime as date)'Date',
objectname,
--l.stagename,
--l.objectname,
--l.processname,
sum(isnull(datalength(l.[result]), 1))[result] , 
sum(isnull(datalength(l.[attributexml]), 1)) [attributexml]

from 
dbo.BPASession s with (nolock) join dbo.BPASessionLog_NonUnicode l with (nolock) on s.sessionnumber = l.sessionnumber
join dbo.BPAProcess p with (nolock) on p.processid = s.processid
where p.name = 'Wiltshire Council - Manage Post Box SPO GRAPH API v2'
group by CAST(s.startdatetime as date),objectname
--order by Date,objectname;
)a
where [Date] > '2024-09-30'
group by objectname
order by [attributexml] desc


select stagename,sum(result)/1024/1024[result],sum(attributexml)/1024/1024[attributexml] from (
select 
--logid,
CAST(s.startdatetime as date)'Date',
stagename,
--l.objectname,
--l.processname,
sum(isnull(datalength(l.[result]), 1))[result] , 
sum(isnull(datalength(l.[attributexml]), 1)) [attributexml]

from 
dbo.BPASession s with (nolock) join dbo.BPASessionLog_NonUnicode l with (nolock) on s.sessionnumber = l.sessionnumber
join dbo.BPAProcess p with (nolock) on p.processid = s.processid
where p.name = 'Wiltshire Council - Manage Post Box SPO GRAPH API v2'
group by CAST(s.startdatetime as date),stagename
--order by Date,stagename
)b
where [Date] > '2024-09-30'
group by stagename
order by [attributexml] desc
