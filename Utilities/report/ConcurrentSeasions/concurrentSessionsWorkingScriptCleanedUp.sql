DECLARE @now DATETIME = GETDATE(), @days INT = 7, @eventDate DATE, @count INT, @int INT, @topEvent DATE

DECLARE @events TABLE (
startdatetime DATE,
enddatetime DATE
)

DECLARE @eventTable TABLE (
eventDate DATE,
concurrentEvents INT
)

INSERT @events
SELECT 
CASE 
WHEN CAST(ISNULL(startdatetime,@now) AS DATE) < CAST(DATEADD(DAY,-@days,GETDATE()) AS DATE)  
THEN CAST(DATEADD(DAY,-@days,GETDATE()) AS DATE) 
ELSE CAST(ISNULL(startdatetime,@now) AS DATE)
END AS startdatetime,
           cast(ISNULL(enddatetime, @now) AS DATE) AS enddatetime
    FROM dbo.BPASession WITH (NOLOCK)
    WHERE
        
        (
            startdatetime >= DATEADD(DAY, -@days, @now)
            OR enddatetime >= DATEADD(DAY, -@days, @now)
        )



SET @int = 0
SELECT @count = COUNT(DISTINCT startdatetime) FROM @events 
WHILE (@count > @int)
BEGIN
SELECT TOP 1 @topevent = startdatetime FROM @events ORDER BY startdatetime

INSERT @eventtable
SELECT @topevent , COUNT(*)  FROM @events 
WHERE startdatetime = @topevent OR enddatetime = @topevent;

DELETE @events WHERE startdatetime = @topevent;
SET @int = @int + 1
END

SELECT MAX(concurrentEvents)'PeakConcurrentSessionsInLastXDays',MIN(concurrentEvents)'BottomConcurrentSessionsInLastXDays' FROM @eventtable
