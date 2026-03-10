select top 1* from dbo.BPASession;
select top 1* from dbo.BPASessionLog_NonUnicode

;with cte_1
as
(
select s.sessionnumber,CAST(s.startdatetime as date)'Date', l.logid from dbo.BPASession s with (nolock) join dbo.BPASessionLog_NonUnicode l with (nolock) 
on s.sessionnumber = l.sessionnumber
)
,
cte_2
as
(select [Date],count(logid)'RecordNo' from cte_1 group by [Date] --order by [Date]
)
-- select SUM(RecordNo) from cte_2 where  DATEDIFF(dd,GETDATE(),[Date]) > -90
SELECT 
DATEPART(YEAR,[Date]) 'Year',
DATEPART(MONTH,[Date]) 'Month',
SUM(RecordNo) 'RecordCount'
from cte_2
GROUP BY
DATEPART(YEAR,[Date]) ,
DATEPART(MONTH,[Date]) 
ORDER BY [Year], [Month]

--select DATEADD(dd,-60,GETDATE())
--select DATEDIFF(dd,GETDATE(),'2024-02-08')
--select CAST(GETDATE() as date) --2024-02-08 13:09:19.640


