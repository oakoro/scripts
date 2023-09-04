with cte_raw
as
(select  [logid],[result],
[attributexml],
isnull(datalength([result]), 1)[resultSize],
isnull(datalength([attributexml]), 1) [attributexmlSize],
ROW_NUMBER() over (order by logid) as rowNo
from BPASessionLog_NonUnicode with (nolock)
where logid between 11800000 and 12533546
)
select * from cte_raw where rowNo between 611000 and 611488
order by rowNo 

