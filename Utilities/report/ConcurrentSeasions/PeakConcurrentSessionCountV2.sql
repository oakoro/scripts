DECLARE @now DATETIME = GETDATE(), @days INT,@defaultDate DATETIME
DECLARE @int INT, @count INT ,@eventdate datetime

SET @days = 30

SET @defaultDate =  DATEADD(DAY,-@days,@now) 
SELECT @defaultDate

IF (OBJECT_ID('dbo.#tblevent','U')) IS NULL
BEGIN
CREATE TABLE #tblevent (
	event INT IDENTITY(1,1) PRIMARY KEY,
	startdatetime DATETIME,
	enddatetime DATETIME,
	duration INT
)
END
--DECLARE @tblevent TABLE (
--	startdatetime DATETIME,
--	enddatetime DATETIME,
--	duration INT
--)
IF (OBJECT_ID('dbo.#tblevent','U')) IS NULL
BEGIN
CREATE TABLE #tbleventSummary (
	eventdate DATETIME,
	concurrentrun INT
)
END
--DECLARE @tbleventSummary TABLE (
--	eventdate DATETIME,
--	concurrentrun INT
--)


;WITH cte_raw
AS
(
SELECT 
FORMAT(ISNULL(startdatetime,@defaultDate),'yyyy-MM-dd HH:mm')'startdatetime',
FORMAT(ISNULL(enddatetime,dateadd(SECOND,s.starttimezoneoffset,@now)),'yyyy-MM-dd HH:mm')'enddatetime'
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
INSERT INTO #tblevent
SELECT * FROM cte_data ORDER BY startdatetime


SELECT @count = COUNT(*) FROM #tblevent 

SET @int = 0

WHILE (@count > @int)
BEGIN
SELECT TOP 1 @eventdate = enddatetime FROM #tblevent ORDER BY enddatetime

insert into #tbleventSummary
SELECT @eventdate, COUNT(*) FROM #tblevent WHERE enddatetime = @eventdate
SET @int = @int + 1
DELETE #tblevent WHERE enddatetime = @eventdate
END

SELECT MAX(concurrentrun)'PeakConcurrentSessionRun' from #tbleventSummary 

DROP TABLE #tbleventSummary, #tblevent;







