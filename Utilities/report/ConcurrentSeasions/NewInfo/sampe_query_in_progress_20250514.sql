select * from [dbo].[BPAResource] where processesrunning = 1
select * from dbo.BPASession where statusid in (0,1,7)
--select * from dbo.BPAStatus


select * from dbo.BPASession where statusid in (0,1,7)

SELECT sessionnumber, startdatetime, isnull(enddatetime,GETDATE()) enddatetime
    FROM   dbo.BPASession
    WHERE  startdatetime >= '2025-05-13 0:0'
    AND    startdatetime <  '2025-05-14 0:0'

SELECT startdatetime, isnull(enddatetime,GETDATE()) enddatetime
    FROM   dbo.BPASession
    WHERE  enddatetime >= '2025-05-14 0:0'
    AND    startdatetime <= (SELECT max(enddatetime) As max_endtime FROM x)

--WITH x AS (
--    SELECT sid, starttime, endtime
--    FROM   dbo.BPASession
--    WHERE  starttime >= '2025-05-13 0:0'
--    AND    starttime <  '2025-05-14 0:0'
--    ), y AS (
--    SELECT starttime, endtime
--    FROM   calls_nov
--    WHERE  endtime >= '2011-11-02 0:0'
--    AND    starttime <= (SELECT max(endtime) As max_endtime FROM x)
--    )
--SELECT x.sid, count(*) AS count_overlaps
--FROM   x
--LEFT   JOIN y ON x.starttime <= y.endtime
--             AND x.endtime >= y.starttime
--GROUP  BY 1
--ORDER  BY 2 DESC;