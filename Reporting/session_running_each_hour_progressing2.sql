DECLARE @minDateTime AS DATETIME;
DECLARE @maxDateTime AS DATETIME;
DECLARE @count int, @int int, @session int

DECLARE @timetbl TABLE (
sessionnumber int,
temp_startdatetime datetime,
temp_enddatetime datetime
)

DECLARE @timeraw TABLE (Dates datetime)

SET NOCOUNT ON
--DECLARE @sessiontable TABLE (sessionnumber int)

--SET @minDateTime = '2014-01-13 02:00:00';
--SET @maxDateTime = '2014-12-31 14:00:00';

--INSERT @sessiontable SELECT DISTINCT sessionnumber FROM dbo.BPASession

--SELECT @count = COUNT(*) FROM @sessiontable

INSERT @timetbl(sessionnumber,temp_startdatetime,temp_enddatetime)
select  sessionnumber,startdatetime, isnull(enddatetime,getdate()) from dbo.BPASession 

SELECT @count = COUNT(*) FROM @timetbl

WHILE @count > 0
BEGIN
SELECT TOP 1 @session =  sessionnumber, @minDateTime =temp_startdatetime, @maxDateTime = temp_enddatetime FROM @timetbl ;
WITH Dates_CTE
     AS (SELECT @minDateTime AS Dates 
         UNION ALL
         SELECT Dateadd(hh, 1, Dates)
         FROM   Dates_CTE
         WHERE  Dates < @maxDateTime)
insert @timeraw
SELECT Dates
FROM   Dates_CTE
OPTION (MAXRECURSION 0) 
DELETE @timetbl WHERE sessionnumber = @session;
SET @count = @count - 1
END

select * from @timeraw
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

