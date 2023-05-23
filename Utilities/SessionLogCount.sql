select * from dbo.BPASession with (nolock) order by startdatetime desc

select convert(date,startdatetime)'Date', count(*)'SessionGenerated' from dbo.BPASession with (nolock)
where convert(date,startdatetime) in ('2023-05-22','2023-05-21','2023-05-20')
group by convert(date,startdatetime)
order by Date desc
go

with cte
as
(
select a.logid,a.sessionnumber,b.startdatetime 
from dbo.BPASessionLog_NonUnicode a join dbo.BPASession b on a.sessionnumber = b.sessionnumber
where convert(date,b.startdatetime) in ('2023-05-23','2023-05-22','2023-05-21','2023-05-20')
)
select convert(date,startdatetime)'Date', count(*)'LogidCount' from cte
where convert(date,startdatetime) in ('2023-05-23','2023-05-22','2023-05-21','2023-05-20')
group by convert(date,startdatetime)
order by Date desc 