declare @startdate datetime = getdate()-1
--declare @startdate1 datetime = getdate()-14
;
with cte_process_log
as
(
select l.logid, s.startdatetime, p.name,
isnull(datalength(l.[result]), 1)[result] , 
isnull(datalength(l.[attributexml]), 1) [attributexml]
from dbo.BPASessionLog_NonUnicode l 
join dbo.BPASession s on l.sessionnumber = s.sessionnumber
join dbo.BPAProcess p on p.processid = s.processid
where s.startdatetime > @startdate
--where s.startdatetime between @startdate1 and @startdate --'2024-07-15 11:02:18.097'
)
select [name] 'ProcessName', count(logid) 'SessionLogging', SUM([result])/1024/1024 'Result_XML_MB',SUM([attributexml])/1024/1024 'Attributexml_MB' from cte_process_log
group by [name]
order by SessionLogging desc
