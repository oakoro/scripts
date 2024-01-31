--select top 1* from dbo.BPASession
--go
--select top 100* from dbo.BPASessionLog_NonUnicode with (nolock) --where startdatetime is null

--select top 10000 logid,sessionnumber,startdatetime, DATEPART(weekday,startdatetime),DATEPART(dd,startdatetime), DATEPART(WW,startdatetime), DATEPART(HH,startdatetime) from dbo.BPASessionLog_NonUnicode with (nolock)

--select logid, DATEPART(hh,l.startdatetime)'Hour', ROW_NUMBER() over (partition by DATEPART(mm,l.startdatetime) order by DATEPART(dd,l.startdatetime)) AS RowNum
--from dbo.BPASessionLog_NonUnicode  l with (nolock) join dbo.BPASession s with (nolock) on l.sessionnumber = s.sessionnumber

--with cte_raw
--as
--(
--select logid, l.startdatetime,DATEPART(hh,l.startdatetime)'Hour',DATEPART(dd,l.startdatetime)'Day', DATEPART(ww,l.startdatetime)'Week',
--ROW_NUMBER() over (partition by DATEPART(ww,l.startdatetime) order by DATEPART(dd,l.startdatetime), DATEPART(hh,l.startdatetime) asc ) AS RowNum
--from dbo.BPASessionLog_NonUnicode  l with (nolock) join dbo.BPASession s with (nolock) on l.sessionnumber = s.sessionnumber
--)
--select Hour,day,Week ,count(RowNum)'NumOfSessionlogs' from cte_raw 
--group by Hour,day,Week 
--order by Week, day, Hour
--go

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