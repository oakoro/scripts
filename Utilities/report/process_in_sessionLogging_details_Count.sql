with cte_sl
as
(
SELECT  [logid]
      , [sessionnumber]
       FROM [dbo].[BPASessionLog_NonUnicode] with (nolock)
  where logid > 8994895
  ),
cte_s
as
(select sessionnumber, p.name
from dbo.BPASession s  with (nolock) join dbo.BPAProcess p  with (nolock) on s.processid = p.processid
)
,
cte_combine
as
(
SELECT b.name
		, [logid]
  FROM cte_sl a join cte_s b on a.sessionnumber = b.sessionnumber
  )
 select 
 name,
 COUNT(logid) Record
 from
 cte_combine
 group by name
 