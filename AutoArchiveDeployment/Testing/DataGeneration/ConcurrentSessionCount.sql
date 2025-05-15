SELECT TOP 1 startDatetime, sessionCount'maxConcurrentCount' FROM (
SELECT  
FORMAT(startdatetime,'yyyy-MM-dd HH:mm')'startDatetime',
COUNT(*)'sessionCount'
FROM [dbo].[sessionCount]
GROUP BY FORMAT(startdatetime,'yyyy-MM-dd HH:mm')
)a
ORDER BY sessionCount DESC