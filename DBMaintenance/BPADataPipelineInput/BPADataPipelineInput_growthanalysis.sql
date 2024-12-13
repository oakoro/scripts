--select top 1* from dbo.BPADataPipelineInput with (nolock) order by inserttime desc--2024-07-01 12:04:06.547 25040.38

--select top 1* from dbo.BPASessionLog_NonUnicode with (nolock) order by logid--2023-06-07 21:15:42.480 29115.10
--select * from dbo.BPASession with (nolock) where sessionnumber = 6 --2023-06-07 21:15:41.870

--Dev

with cte
as
(
select
inserttime,DATALENGTH(EVENTDATA)'eventdataSize',DATALENGTH(publisher)'publisherSize'
from dbo.BPADataPipelineInput with (nolock)
),
cte_1
as
(
select 
CONVERT(date,inserttime)'Date',DATEPART(MM,inserttime)'Month',DATEPART(WEEK,inserttime)'Week',
(sum(eventdataSize)+sum(publisherSize))'TotalDataSize'
from cte
group by CONVERT(date,inserttime),DATEPART(MM,inserttime),DATEPART(WEEK,inserttime)
)
select Month, SUM(TotalDataSize)/1024/1024'TotalDataSize_MB'
from cte_1
group by Month
order by Month