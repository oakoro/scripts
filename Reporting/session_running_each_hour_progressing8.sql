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
--DECLARE @sessiontable TABLE (sessionnumber int)

--SET @minDateTime = '2014-01-13 02:00:00';
--SET @maxDateTime = '2014-12-31 14:00:00';

--INSERT @sessiontable SELECT DISTINCT sessionnumber FROM dbo.BPASession

--SELECT @count = COUNT(*) FROM @sessiontable

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
         SELECT Dateadd(MI, 30, Dates)
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

select sessionnumber, COUNT(*) from @timeraw 
GROUP BY sessionnumber
HAVING COUNT(*) > 1
--WHILE @count > 0
--BEGIN
--SELECT TOP 1 @session =  sessionnumber FROM @sessiontable
----print @session

--select  @minDateTime =startdatetime, @maxDateTime = enddatetime from dbo.BPASession
--where sessionnumber = @session ;
--INSERT @timetbl(sessionnumber,temp_startdatetime,temp_enddatetime)
--VALUE (@session,@minDateTime, @maxDateTime)
--DELETE @sessiontable WHERE sessionnumber = @session;
--SET @count = @count - 1
--END

--select  @minDateTime =startdatetime, @maxDateTime = enddatetime from dbo.BPASession
--where sessionnumber = 10789
--;
--WITH Dates_CTE
--     AS (SELECT @minDateTime AS Dates
--         UNION ALL
--         SELECT Dateadd(hh, 1, Dates)
--         FROM   Dates_CTE
--         WHERE  Dates < @maxDateTime)
--SELECT *
--FROM   Dates_CTE
--OPTION (MAXRECURSION 0) 

--select  top 2 sessionnumber,startdatetime,enddatetime from dbo.BPASession order by startdatetime

