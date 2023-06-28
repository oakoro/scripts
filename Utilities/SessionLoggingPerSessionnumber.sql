--select convert(date,startdatetime) as 'Date', count(*) as 'NumberofSessions' from dbo.BPASession with (nolock)
--group by convert(date,startdatetime)
--order by convert(date,startdatetime) desc

with cte
as
(
select sessionnumber, convert(date,startdatetime) 'startdatetime'
from dbo.BPASession with (nolock)
where convert(date,startdatetime) > '2023-03-31'
)
select a.sessionnumber,a.startdatetime, count(b.logid) 'RecordCount' from cte a join BPASessionLog_NonUnicode b on a.sessionnumber = b.sessionnumber
group by a.sessionnumber,a.startdatetime
order by a.startdatetime 