SET NOCOUNT ON


--EXEMPTED QUEUES
DECLARE @exemptedqueue TABLE ([name] NVARCHAR(255));

--Populate values with exempted queues
INSERT @exemptedqueue
VALUES('')



--DEFINE QUEUE RETENTION
DECLARE @DaysToKeep INT;
DECLARE @Threshold DATETIME;

SET @DaysToKeep = 0;
SET @Threshold = CONVERT(DATE, GETDATE() - @DaysToKeep);

select @Threshold

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
	queueName NVARCHAR(255) NOT NULL,
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

INSERT @QueuesToInclude(queueID,queueName,year,mONth,week,day,recordCount)
SELECT queueID,queueName,year,mONth,week,day,count(*) FROM #QueuesToInclude
GROUP BY queueID,queueName,year,mONth,week,day


--select queueID,sum(recordCount) from @QueuesToInclude group by queueID 
select * from @QueuesToInclude order by queueID,year,mONth

select queueName,year,SUM(recordCount)'recordCount' from @QueuesToInclude
group by queueName,year