with cte_sessionlog_grouping
as
(
select logid, l.startdatetime,DATEPART(hh,l.startdatetime)'Hour',DATEPART(dd,l.startdatetime)'Day', DATEPART(ww,l.startdatetime)'Week',DATEPART(yy,l.startdatetime)'Year',
ROW_NUMBER() over (partition by DATEPART(yy,l.startdatetime) order by DATEPART(yy,l.startdatetime),DATEPART(ww,l.startdatetime) ,DATEPART(dd,l.startdatetime), DATEPART(hh,l.startdatetime) asc ) AS RowNum
from dbo.BPASessionLog_NonUnicode  l with (nolock) join dbo.BPASession s with (nolock) on l.sessionnumber = s.sessionnumber
)
select Hour,day,Week ,Year,count(RowNum)'NumOfSessionlogs' from cte_sessionlog_grouping 
group by Hour,day,Week,Year
order by Year, Week, day, Hour
go

