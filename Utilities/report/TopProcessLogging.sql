declare @startdate datetime = getdate()-30
;
with cte_process_log
as
(
select l.logid, s.startdatetime, p.name
from dbo.BPASessionLog_NonUnicode l 
join dbo.BPASession s on l.sessionnumber = s.sessionnumber
join dbo.BPAProcess p on p.processid = s.processid
where s.startdatetime > @startdate --'2024-07-15 11:02:18.097'
)
select [name] 'ProcessName', count(logid) 'SessionLogging' from cte_process_log
group by [name]
order by SessionLogging desc
