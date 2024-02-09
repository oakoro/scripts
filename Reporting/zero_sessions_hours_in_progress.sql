DECLARE @periodLengthDays INT = 30

DECLARE @startDateTime DATETIME,@endDateTime DATETIME, 
		@minDateTime DATETIME, @maxDateTime AS DATETIME, 
		@count INT, @int INT, @session INT
		
SELECT @startDateTime = dateadd(day,-@periodLengthDays,max(startdatetime)), 
@endDateTime = max(startdatetime) FROM dbo.BPASession WITH (NOLOCK)


/***Create holding tables***/
DECLARE @sessions_in TABLE (
sessionnumber INT,
temp_startdatetime DATETIME,
temp_enddatetime DATETIME
)

DECLARE @sessionTime TABLE (sessionDate DATETIME,sessionnumber INT )

DECLARE @calender TABLE (
	recid INT IDENTITY(1,1), 
    cal_datetime DATETIME, 
    cal_year INT, 
    cal_month TINYINT, 
    cal_day TINYINT,
	cal_weekday TINYINT,
    cal_hour TINYINT)

/***Capture sessions within date range ****/
INSERT @sessions_in(sessionnumber,temp_startdatetime,temp_enddatetime) 
SELECT  sessionnumber,startdatetime,ISNULL(enddatetime,@endDateTime) FROM dbo.BPASession 
WHERE DATEDIFF(DD,startdatetime,GETDATE()) <= @periodLengthDays;

/***Capture long running sessions but outside date range with run status Running, Stopping Warning ****/
INSERT @sessions_in(sessionnumber,temp_startdatetime,temp_enddatetime)
SELECT  sessionnumber,startdatetime,enddatetime FROM dbo.BPASession 
WHERE DATEDIFF(DD,startdatetime,GETDATE()) > @periodLengthDays AND enddatetime IS NULL AND statusid IN (1,7,8);


/***Reset start and end date for long running sessions***/
UPDATE @sessions_in
SET temp_startdatetime = @startDateTime, temp_enddatetime = @endDateTime
WHERE temp_enddatetime IS NULL;


/***Generate session dates***/
SELECT @count = COUNT(*) FROM @sessions_in

WHILE @count > 0
BEGIN
SELECT 
TOP 1 @session =  sessionnumber, @minDateTime = temp_startdatetime, 
@maxDateTime = temp_enddatetime FROM @sessions_in ;
--Check if startdate and enddate are within same hour
IF STUFF(CONVERT(VARCHAR(20),@minDateTime,121),15,19,'00:00') <> STUFF(CONVERT(VARCHAR(20),@maxDateTime,121),15,19,'00:00')
	BEGIN
	WITH Dates_CTE  
     AS (SELECT @minDateTime AS Dates 
         UNION ALL
         SELECT    DATEADD(HH, 1, Dates)
         FROM   Dates_CTE
         WHERE  Dates < @maxDateTime)
	INSERT @sessionTime(sessionDate,sessionnumber)
	SELECT Dates,@session FROM Dates_CTE
	OPTION (MAXRECURSION 0) 
	END
	ELSE
	BEGIN
	INSERT @sessionTime(sessionDate,sessionnumber)
	VALUES(@minDateTime,@session)
	END
DELETE @sessions_in WHERE sessionnumber = @session;
SET @count = @count - 1
END

/***Populate calendar table 
loop from start date to end date, by adding 1 hour each cycle, 
until start date equals end date ***/

WHILE @startDateTime <> @endDateTime 
BEGIN
INSERT INTO @calender 
SELECT 
STUFF(CONVERT(VARCHAR(20),@startDateTime,121),15,19,'00:00')
,DATEPART(YEAR,@startDateTime)
,DATEPART(MONTH,@startDateTime)
,DATEPART(DAY,@startDateTime)
,DATEPART(WEEKDAY,@startDateTime)
,DATEPART(HOUR,@startDateTime)
        
SET @startDateTime = DATEADD(HOUR,1,@startDateTime)
END

/***Generate final report***/
;WITH cte_ExtractReport
AS
(
SELECT  
sessionnumber,
STUFF(CONVERT(VARCHAR(20),sessionDate,121),15,19,'00:00')'startdatetime2', 
DATEPART(HH,sessionDate)'Hour',
DATEPART(DD,sessionDate)'Day', 
DATEPART(WW,sessionDate)'Week',
DATEPART(YY,sessionDate)'Year',
ROW_NUMBER() over (partition by DATEPART(YY,sessionDate) ORDER BY DATEPART(WW,sessionDate) ,DATEPART(DD,sessionDate), DATEPART(HH,sessionDate) ASC ) AS RowNum
FROM @sessionTime 
)
SELECT a.cal_datetime'Daytime',
CASE
WHEN a.cal_weekday = 1 THEN 'Sunday'
WHEN a.cal_weekday = 2 THEN 'Monday'
WHEN a.cal_weekday = 3 THEN 'Tuesday'
WHEN a.cal_weekday = 4 THEN 'Wednesday'
WHEN a.cal_weekday = 5 THEN 'Thursday'
WHEN a.cal_weekday = 6 THEN 'Friday'
WHEN a.cal_weekday = 7 THEN 'Saturday'
END
AS 'Weekday',
a.cal_hour 'Hour', ISNULL(startdatetime2,'No session') 'ProductionDate',
COUNT(RowNum) 'TotalSession'
FROM @calender a LEFT JOIN cte_ExtractReport b on a.cal_datetime = b.startdatetime2
GROUP BY a.cal_datetime,a.cal_weekday,a.cal_hour, ISNULL(startdatetime2,'No session')
HAVING COUNT(RowNum)  = 0 
ORDER BY Daytime



