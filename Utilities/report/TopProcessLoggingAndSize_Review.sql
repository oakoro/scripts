DECLARE @startdate DATETIME = GETDATE()-7


;
WITH cte_process_log
AS
(
SELECT l.logid, s.startdatetime, p.name,
(ISNULL(DATALENGTH(l.[result]), 0) + ISNULL(DATALENGTH(l.[attributexml]), 0)) [data_size]
FROM dbo.BPASessionLog_NonUnicode l WITH (NOLOCK)
JOIN dbo.BPASession s WITH (NOLOCK) ON l.sessionnumber = s.sessionnumber
JOIN dbo.BPAProcess p WITH (NOLOCK) ON p.processid = s.processid
WHERE s.startdatetime > @startdate

)
SELECT [name] [ProcessName], 
SUM([data_size])/1024/1024 [Data_size_MB]
FROM cte_process_log
GROUP BY [name]
ORDER BY [Data_size_MB] desc

