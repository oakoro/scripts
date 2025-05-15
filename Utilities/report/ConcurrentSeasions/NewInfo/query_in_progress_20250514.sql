with cte_1
as
(
SELECT sessionnumber, startdatetime, isnull(enddatetime,GETDATE()) enddatetime
    FROM   dbo.BPASession
    WHERE  startdatetime >= '2025-05-13 08:22:21.247'
    AND    startdatetime <  '2025-05-14 08:22:21.247'
	--AND statusid in (0,1,7)
),

cte_2
as
(
SELECT startdatetime, isnull(enddatetime,GETDATE()) enddatetime
    FROM   dbo.BPASession
    WHERE  enddatetime >= '2025-05-13 08:22:21.247'
    AND    startdatetime <= (SELECT max(enddatetime) As max_endtime FROM cte_1)
	)
SELECT cte_1.sessionnumber, count(*) AS count_overlaps
--cte_1.*

FROM   cte_1
LEFT   JOIN cte_2 ON cte_1.startdatetime <= cte_2.enddatetime
             AND cte_1.enddatetime >= cte_2.startdatetime
GROUP  BY cte_1.sessionnumber
ORDER  BY sessionnumber ;


select * from dbo.BPASession where sessionnumber IN (78937,78938)