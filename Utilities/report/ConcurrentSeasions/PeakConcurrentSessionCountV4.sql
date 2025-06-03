DECLARE @now DATETIME = GETDATE(), @days INT,@defaultDate DATETIME
DECLARE @int INT, @count INT ,@eventdate datetime

SET @days = 30

SET @defaultDate =  DATEADD(DAY,-@days,@now) 


DECLARE @tblevent TABLE (
	event INT IDENTITY (1,1) PRIMARY KEY,
	startdatetime DATETIME,
	enddatetime DATETIME,
	duration INT
)
DECLARE @tbleventSummary TABLE (
	eventdate DATETIME,
	concurrentrun INT
)


;WITH cte_raw
AS
(
SELECT 
CONVERT(SMALLDATETIME,ISNULL(startdatetime,@defaultDate))'startdatetime',
CONVERT(SMALLDATETIME,ISNULL(enddatetime,dateadd(SECOND,s.starttimezoneoffset,@now)))'enddatetime'
FROM dbo.BPASession s WITH (NOLOCK) 
WHERE enddatetime IS NULL OR 
startdatetime >= DATEADD(DAY, -@days, @now)

)

,
cte_data
AS
(
SELECT startdatetime,enddatetime,DATEDIFF(mi,startdatetime,enddatetime)'duration' from cte_raw 
)
INSERT INTO @tblevent
SELECT * FROM cte_data ORDER BY startdatetime


DECLARE @firstRow INT, @lastRow INT
SELECT @firstRow = MIN(event), @lastRow = MAX(event)  FROM @tblevent

SELECT @firstRow, @lastRow

WHILE (@firstRow <= @lastRow)
BEGIN
SELECT TOP 1 @eventdate = enddatetime FROM @tblevent WHERE event = @firstRow ORDER BY enddatetime

insert into @tbleventSummary
SELECT @eventdate, COUNT(*) FROM @tblevent WHERE enddatetime = @eventdate

SELECT @firstRow = MIN(event) FROM @tblevent WHERE event > @firstRow

END

SELECT MAX(concurrentrun)'PeakConcurrentSessionRun' from @tbleventSummary 





