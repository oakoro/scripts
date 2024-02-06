DECLARE @minDateTime AS DATETIME;
DECLARE @maxDateTime AS DATETIME;

SET @minDateTime = '2014-01-13 02:00:00';
SET @maxDateTime = '2014-12-31 14:00:00';

;
WITH Dates_CTE
     AS (SELECT @minDateTime AS Dates
         UNION ALL
         SELECT Dateadd(hh, 1, Dates)
         FROM   Dates_CTE
         WHERE  Dates < @maxDateTime)
SELECT *
FROM   Dates_CTE
OPTION (MAXRECURSION 0) 