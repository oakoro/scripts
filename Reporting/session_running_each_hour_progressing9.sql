DECLARE @minDateTime AS DATETIME;
DECLARE @maxDateTime AS DATETIME;
DECLARE @count int, @int int, @session int
declare @period_length_days     as int      = 30

DECLARE @timetbl TABLE (
sessionnumber int,
temp_startdatetime datetime,
temp_enddatetime datetime
)

DECLARE @timeraw TABLE (Dates datetime,sessionnumber int )

SET NOCOUNT ON


INSERT @timetbl(sessionnumber,temp_startdatetime,temp_enddatetime)
select  sessionnumber,startdatetime, isnull(enddatetime,getdate()) from dbo.BPASession 
WHERE DATEDIFF(DD,startdatetime,GETDATE()) <= @period_length_days 

--SELECT * FROM @timetbl ORDER BY temp_startdatetime DESC

SELECT @count = COUNT(*) FROM @timetbl

WHILE @count > 0
BEGIN
SELECT TOP 1 @session =  sessionnumber, @minDateTime =temp_startdatetime, @maxDateTime = temp_enddatetime FROM @timetbl ;
IF stuff(convert(varchar(20),@minDateTime,121),15,19,'00:00') <> stuff(convert(varchar(20),@maxDateTime,121),15,19,'00:00')
	BEGIN
	WITH Dates_CTE  
     AS (SELECT @minDateTime AS Dates 
         UNION ALL
         SELECT    Dateadd(HH, 1, Dates)
         FROM   Dates_CTE
         WHERE  Dates < @maxDateTime)
	insert @timeraw([Dates],sessionnumber)
	SELECT Dates,@session
	FROM   Dates_CTE
	OPTION (MAXRECURSION 0) 
	END
	ELSE
	BEGIN
	insert @timeraw([Dates],sessionnumber)
	VALUES(@minDateTime,@session)
	END
DELETE @timetbl WHERE sessionnumber = @session;
SET @count = @count - 1
END

--SELECT * from @timeraw 

select  stuff(convert(varchar(20),dates,121),15,19,'00:00')'startdatetime2', 
DATEPART(hh,dates)'Hour',DATEPART(dd,dates)'Day', DATEPART(ww,dates)'Week',DATEPART(yy,dates)'Year',
ROW_NUMBER() over (partition by DATEPART(yy,dates) order by DATEPART(yy,dates),DATEPART(ww,dates) ,DATEPART(dd,dates), DATEPART(hh,dates) asc ) AS RowNum
from @timeraw 
