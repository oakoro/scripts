
SELECT [entrytime], SUM([terminationreason]) FROM (
SELECT  CAST([entrytime] AS DATE) [entrytime],
    ISNULL(DATALENGTH([terminationreason]),0) [terminationreason]
     
  FROM [dbo].[BPAScheduleLogEntry]

) LIST
GROUP BY [entrytime]
ORDER BY [entrytime]


