/****SPECIFY CHECK DURATION******/
DECLARE @days INT = 1


/****CALCULATE START TIME******/
DECLARE @now DATETIME = GETDATE() 
DECLARE @defaultStartDate SMALLDATETIME
SET @defaultStartDate =  DATEADD(DAY,-@days,@now) 

DECLARE @tblevent TABLE (
	event INT IDENTITY (1,1) PRIMARY KEY,
	startdatetime DATETIME,
	enddatetime DATETIME,
	duration INT
)

DECLARE @tbleventSummary TABLE (
	event INT IDENTITY (1,1) PRIMARY KEY,
	startDate smallDATETIME,
	concurrentrun INT
)

;WITH cte_raw
AS
(
SELECT 
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

INSERT @tblevent
SELECT 
startdatetime,enddatetime,DATEDIFF(mi,startdatetime,enddatetime)'duration' FROM  cte_raw ORDER BY startdatetime


SELECT * FROM @tblevent
ORDER BY startdatetime



DECLARE @firstRow INT, @lastRow INT, @eventStartDate smalldatetime, @eventEndDate smalldatetime
SELECT @firstRow = MIN(event), @lastRow = MAX(event)  FROM @tblevent

SELECT @firstRow, @lastRow


WHILE (@firstRow <= @lastRow)
BEGIN
SELECT TOP 1 @eventEndDate = enddatetime,@eventStartDate = startdatetime  FROM @tblevent WHERE event = @firstRow

insert into @tbleventSummary(startDate,concurrentrun)
SELECT @eventStartDate,COUNT(*) FROM @tblevent WHERE startdatetime <= @eventStartDate and enddatetime >= @eventEndDate

SELECT @firstRow = MIN(event) FROM @tblevent WHERE event > @firstRow

END
select max(concurrentrun) from @tbleventSummary

select * from @tbleventSummary order by concurrentrun desc



