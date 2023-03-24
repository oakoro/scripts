with cte_process
as
(
select p.name AS 'ProcessName', count(s.sessionnumber) AS 'SessionCount' from BPAProcess p with (nolock) 
join BPASession s with (nolock) on p.processid = s.processid
group by p.name
)

, cte_session
as
(
select p.name AS 'ProcessName', COUNT(l.sessionnumber) AS 'SessionLogCount' from BPASession s with (nolock) 
	join BPASessionLog_NonUnicode l with (nolock) on s.sessionnumber = l.sessionnumber
	join BPAProcess p ON s.processid = p.processid
	group by p.name
)
select p.ProcessName,p.SessionCount,s.SessionLogCount from cte_process p join cte_session s on p.ProcessName = s.ProcessName
order by p.ProcessName