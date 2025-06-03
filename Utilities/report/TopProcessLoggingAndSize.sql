declare @startdate datetime = getdate()-30
--declare @startdate1 datetime = getdate()-14
;
with cte_process_log
as
(
select l.logid, s.startdatetime, p.name,
isnull(datalength(l.[result]), 1)[result] , 
isnull(datalength(l.[attributexml]), 1) [attributexml]
from dbo.BPASessionLog_NonUnicode l with (nolock)
join dbo.BPASession s with (nolock) on l.sessionnumber = s.sessionnumber
join dbo.BPAProcess p with (nolock) on p.processid = s.processid
where s.startdatetime > @startdate
--where s.startdatetime between @startdate1 and @startdate --'2024-07-15 11:02:18.097'
)
select [name] 'ProcessName', count(logid) 'SessionLogging', (SUM([result])+SUM([attributexml]))/1024/1024 'Size_MB' from cte_process_log
group by [name]
order by SessionLogging desc

