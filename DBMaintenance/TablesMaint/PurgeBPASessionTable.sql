
declare @enddatetime DATETIME = DATEADD(D,-30,GETDATE())

select @enddatetime

declare @sessiontokeeep TABLE (snum bigint)

insert @sessiontokeeep
select distinct sessionnumber
from dbo.BPASessionLog_NonUnicode
UNION
select distinct sessionnumber
from dbo.BPAWorkQueueItem i JOIN dbo.BPASession s on i.sessionid = s.sessionid

-- SELECT *
-- from BPASession s LEFT JOIN @sessiontokeeep l 
-- on s.sessionnumber = l.snum
-- where snum is NULL
-- AND enddatetime is NOT NULL and enddatetime <  @enddatetime
-- ORDER BY enddatetime DESC

-- DELETE s
-- from BPASession s LEFT JOIN @sessiontokeeep l 
-- on s.sessionnumber = l.snum
-- where snum is NULL
-- AND enddatetime is NOT NULL and enddatetime <  @enddatetime

