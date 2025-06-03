/****SPECIFY CHECK DURATION******/
DECLARE @days INT = 1


/****CALCULATE START TIME******/
DECLARE @now DATETIME = GETDATE() 
DECLARE @defaultStartDate SMALLDATETIME
SET @defaultStartDate =  DATEADD(DAY,-@days,@now) 

SELECT @defaultStartDate

DECLARE @tblevent TABLE (
	event INT IDENTITY (1,1) PRIMARY KEY,
	--sessionnumber BIGINT,
	startdatetime DATETIME,
	enddatetime DATETIME,
	duration INT
)

DECLARE @tbleventSummary TABLE (
	event INT IDENTITY (1,1) PRIMARY KEY,
	concurrentrun INT
)

;WITH cte_raw
AS
(
SELECT 
--sessionnumber,
CONVERT(SMALLDATETIME,startdatetime) 'startdatetime1',
CASE
WHEN startdatetime < @defaultStartDate THEN @defaultStartDate
ELSE CONVERT(SMALLDATETIME,startdatetime)
END AS 'startdatetime',
CONVERT(SMALLDATETIME,ISNULL(enddatetime,dateadd(SECOND,ISNULL(s.endtimezoneoffset,0),@now)))'enddatetime'
FROM dbo.BPASession s WITH (NOLOCK) 
WHERE enddatetime IS NULL OR 
startdatetime >= DATEADD(DAY, -@days, @now)

)
--SELECT * FROM cte_raw


INSERT @tblevent
SELECT 
--sessionnumber,
startdatetime,enddatetime,DATEDIFF(mi,startdatetime,enddatetime)'duration' FROM  cte_raw ORDER BY startdatetime


SELECT * FROM @tblevent
ORDER BY startdatetime



DECLARE @firstRow INT, @lastRow INT, @eventStartDate smalldatetime, @eventEndDate smalldatetime
SELECT @firstRow = MIN(event), @lastRow = MAX(event)  FROM @tblevent

SELECT @firstRow, @lastRow
SELECT TOP 1 @eventEndDate = enddatetime,@eventStartDate = startdatetime  FROM @tblevent WHERE event = 89--@firstRow --ORDER BY enddatetime
select @eventStartDate, @eventEndDate

SELECT COUNT(*) FROM @tblevent WHERE startdatetime <= @eventStartDate and enddatetime >= @eventEndDate
SELECT * FROM @tblevent WHERE startdatetime <= @eventStartDate and enddatetime >= @eventEndDate

WHILE (@firstRow <= @lastRow)
BEGIN
SELECT TOP 1 @eventEndDate = enddatetime,@eventStartDate = startdatetime  FROM @tblevent WHERE event = @firstRow

insert into @tbleventSummary
--SELECT COUNT(*) FROM @tblevent WHERE startdatetime <= @eventStartDate
--SELECT COUNT(*) FROM @tblevent WHERE startdatetime = @eventStartDate and  enddatetime <= @eventEndDate
SELECT COUNT(*) FROM @tblevent WHERE startdatetime <= @eventStartDate and enddatetime >= @eventEndDate

SELECT @firstRow = MIN(event) FROM @tblevent WHERE event > @firstRow

END
select * from @tbleventSummary
----SELECT @eventdate  --2025-06-02 11:55:00.000

----SELECT * FROM @tblevent ORDER BY enddatetime


