with cte_1
as
(
select Date, isnull(DocumentCount,0) as DocumentCount,isnull(PageCount,0) as PageCount
from [dbo].[EventLog] with (nolock)
)
select 
CONVERT(Date,Date) as 'Date',
SUM(DocumentCount) as 'DocumentCountPerDay',
SUM(PageCount) as 'PageCountPerDay' 
from cte_1
group by CONVERT(Date,Date)
order by Date