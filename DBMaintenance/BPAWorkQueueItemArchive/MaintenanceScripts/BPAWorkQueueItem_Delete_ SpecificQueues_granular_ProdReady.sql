SET NOCOUNT ON
--Set 1 to print out delete script
DECLARE @print BIT = 0

--EXEMPTED QUEUES
DECLARE @exemptedqueue TABLE ([name] NVARCHAR(255));

--Populate values with exempted queues
INSERT @exemptedqueue
VALUES('')



--DEFINE QUEUE RETENTION
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;

SET @DaysToKeep = 30;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);

IF (OBJECT_ID('usrWQIDeleted','U')) IS NOT NULL
BEGIN
TRUNCATE TABLE dbo.usrWQIDeleted
END
ELSE
BEGIN
CREATE TABLE dbo.usrWQIDeleted (
	queueID UNIQUEIDENTIFIER NOT NULL,
	year SMALLINT,
	month TINYINT ,
	week TINYINT ,
	day SMALLINT 
)
END

IF (OBJECT_ID('tempdb..#QueuesToInclude','U')) IS NOT NULL
BEGIN
DROP TABLE #QueuesToInclude
END

CREATE TABLE #QueuesToInclude(
	queueID UNIQUEIDENTIFIER NOT NULL,
    queueName NVARCHAR(255) NOT NULL,
	finished DATETIME,
	created AS CAST(finished AS DATE),
	year AS DATEPART(YEAR,CAST(finished AS DATE)),
	month AS DATEPART(MONTH,CAST(finished AS DATE)),
	week AS DATEPART(WEEK,CAST(finished AS DATE)),
	day AS DATEPART(DAY,CAST(finished AS DATE))
)

DECLARE @QueuesToInclude TABLE(
	queueID UNIQUEIDENTIFIER NOT NULL,
	year SMALLINT,
	month TINYINT ,
	week TINYINT ,
	day SMALLINT ,
	recordCount INT)

INSERT #QueuesToInclude(queueID,queueName,finished)
SELECT  i.queueid, q.name, i.finished 
FROM dbo.BPAWorkQueueItem i WITH (NOLOCK) 
JOIN dbo.BPAWorkQueue q WITH (NOLOCK) ON i.queueid = q.id
WHERE i.finished IS NOT NULL AND i.finished < @Threshold AND 
q.name NOT IN 
(SELECT name FROM @exemptedqueue)

INSERT @QueuesToInclude(queueID,year,mONth,week,day,recordCount)
SELECT queueID,year,mONth,week,day,count(*) FROM #QueuesToInclude
GROUP BY queueID,year,mONth,week,day


--select queueID,sum(recordCount) from @QueuesToInclude group by queueID 
--select * from @QueuesToInclude

DECLARE @Year SMALLINT,@MONth TINYINT, @Week TINYINT, @Day TINYINT,
		@QueueToDelete UNIQUEIDENTIFIER,@Str NVARCHAR(400),@COUNT INT

SELECT @COUNT = COUNT(*) FROM @QueuesToInclude
WHILE (@COUNT > 0)
BEGIN

SELECT TOP 1 @QueueToDelete = queueid, @Year = year, @MONth = month,
	@Week= week,@Day = day
FROM 
@QueuesToInclude ORDER BY year,month,week,day

SET @Str = 'DELETE FROM dbo.BPAWorkQueueItem WHERE queueid = '''+CONVERT(NVARCHAR(50),@QueueToDelete) + ''''
	+' AND DATEPART(year,CAST(finished AS DATE)) = ' +CONVERT(NVARCHAR(10),@Year) +' AND DATEPART(MONTH,CAST(finished AS DATE)) = ' +CONVERT(NVARCHAR(10),@MONth)
	+' AND DATEPART(WEEK,CAST(finished AS DATE)) = ' +CONVERT(NVARCHAR(10),@Week) +' AND DATEPART(DAY,CAST(finished AS DATE)) = ' +CONVERT(NVARCHAR(10),@Day)

IF @print = 1
BEGIN
PRINT (@Str)
END
ELSE
BEGIN
EXEC (@Str)
END

INSERT dbo.usrWQIDeleted(queueID,year,month,week,day)
VALUES(@QueueToDelete ,@Year ,@MONth , @Week , @Day)

DELETE @QueuesToInclude 
WHERE queueid = @QueueToDelete AND year = @Year AND mONth = @MONth 
		AND week = @Week AND day = @Day

SET @count = @count - 1
END

IF (SELECT 1 FROM @QueuesToInclude) IS NULL
PRINT 'Purge completed successfully'

/*Delete in batches of 25,000 BPATag records that are not associated with a work queue item*/
  DELETE T
    FROM BPATag AS T
    LEFT JOIN BPAWorkQueueItemTag AS IT
        ON T.id = IT.tagid
    WHERE IT.tagid IS NULL;
