DECLARE @Now DATETIME = GETDATE();
DECLARE @Days INT = 7;
declare @eventdate date, @count int, @int int, @topevent date
declare @events table (
startdatetime date,
enddatetime date
)
declare @eventtable table (
eventDate date,
concurrentEvents int
)

insert @events
SELECT cast(ISNULL(startdatetime,@Now) as date) AS startdatetime,
           cast(ISNULL(enddatetime, @Now) as date) AS enddatetime
    FROM dbo.BPASession with (nolock)
    WHERE
        -- Sessions where either start or end is within the last @Days days
        (
            startdatetime >= DATEADD(DAY, -@Days, @Now)
            OR enddatetime >= DATEADD(DAY, -@Days, @Now)
        )

--select COUNT(*) from  @events
--select * from  @events order by startdatetime
--select top 1 @topevent = startdatetime from @events order by startdatetime
--select @topevent

--select * from @events 
--where (startdatetime = '2025-04-13' and enddatetime = '2025-04-13')
--or
--(startdatetime = '2025-04-13' and enddatetime <> '2025-04-13')

--select count(*)'records' from @events 
--where (startdatetime = '2025-04-13' and enddatetime = '2025-04-13')
--or
--(startdatetime = '2025-04-13' and enddatetime <> '2025-04-13')

set @int = 0
select @count = COUNT(distinct startdatetime) from @events 
while (@count > @int)
begin
select top 1 @topevent = startdatetime from @events order by startdatetime

insert @eventtable
select @topevent as eventdate, count(*) as eventcount from @events 
where startdatetime = @topevent or enddatetime = @topevent;

delete @events where startdatetime = @topevent;
set @int = @int + 1
end

select * from @eventtable
select SUM(concurrentEvents)'TotalCount',MAX(concurrentEvents)'PeakConcurrentSessionsInLastXDays' from @eventtable

/**************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--DECLARE @Now DATETIME = GETDATE();
--DECLARE @Days INT = 30;

WITH FilteredSessions
AS (SELECT ISNULL(startdatetime,@Now) AS startdatetime,
           ISNULL(enddatetime, @Now) AS enddatetime
    FROM dbo.BPASession
    WHERE
        -- Sessions where either start or end is within the last @Days days
        (
            startdatetime >= DATEADD(DAY, -@Days, @Now)
            OR enddatetime >= DATEADD(DAY, -@Days, @Now)
        )
)
,
EventPoints
AS (SELECT startdatetime AS event_time,
           +1 AS event_value
    FROM FilteredSessions
    UNION ALL
    SELECT enddatetime AS event_time,
           -1 AS event_value
    FROM FilteredSessions)
,
RunningTotals
AS (SELECT event_time,
           SUM(event_value) OVER (ORDER BY event_time
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                 ) AS concurrent_sessions
    FROM EventPoints)
SELECT MAX(concurrent_sessions) AS PeakConcurrentSessionsInLastXDays
FROM RunningTotals;






