DECLARE @partitionBoundary SYSNAME, @startDate DATETIME

/**Identify last partition boundary**/
SELECT TOP 1 @partitionBoundary = 
		CONVERT(NVARCHAR(20),r.value)  
		FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE i.type = 1 AND t.name = 'BPASessionLog_NonUnicode' AND r.boundary_id IS NOT NULL
ORDER BY r.boundary_id DESC

/**Identify partiton boundary date**/
SELECT @startDate = startdatetime FROM dbo.BPASessionLog_NonUnicode WITH (NOLOCK) WHERE logid = @partitionBoundary

/**Identify top logging processes**/
;
WITH cte_process_log
AS
(
SELECT l.logid, s.startdatetime, p.name
FROM dbo.BPASessionLog_NonUnicode l WITH (NOLOCK)
JOIN dbo.BPASession s WITH (NOLOCK) ON l.sessionnumber = s.sessionnumber
JOIN dbo.BPAProcess p WITH (NOLOCK) ON p.processid = s.processid
WHERE s.startdatetime > @startdate 
)
SELECT [name] 'ProcessName', COUNT(logid) 'SessionLogging' from cte_process_log
GROUP BY [name]
ORDER BY SessionLogging DESC






