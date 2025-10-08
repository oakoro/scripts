DECLARE @startdate DATETIME = GETDATE()-14
select @startdate


;
WITH cte_process_log
AS
(
SELECT l.logid, s.startdatetime, p.name,
(ISNULL(DATALENGTH(l.[sessionnumber]), 0) 
+ISNULL(DATALENGTH(l.[stageid]), 0) 
+ISNULL(DATALENGTH(l.[stagename]), 0) 
+ISNULL(DATALENGTH(l.[stagetype]), 0) 
+ISNULL(DATALENGTH(l.[processname]), 0) 
+ISNULL(DATALENGTH(l.[pagename]), 0) 
+ISNULL(DATALENGTH(l.[objectname]), 0) 
+ISNULL(DATALENGTH(l.[actionname]), 0) 
+ISNULL(DATALENGTH(l.[result]), 0) 
+ISNULL(DATALENGTH(l.[resulttype]), 0) 
+ISNULL(DATALENGTH(l.[startdatetime]), 0) 
+ISNULL(DATALENGTH(l.[enddatetime]), 0)
+ISNULL(DATALENGTH(l.[attributexml]), 0) 
+ISNULL(DATALENGTH(l.[automateworkingset]), 0) 
+ISNULL(DATALENGTH(l.[enddatetime]), 0) 
+ISNULL(DATALENGTH(l.[targetappname]), 0) 
+ISNULL(DATALENGTH(l.[targetappworkingset]), 0) 
+ISNULL(DATALENGTH(l.[starttimezoneoffset]), 0) 
+ISNULL(DATALENGTH(l.[endtimezoneoffset]), 0) 
+ISNULL(DATALENGTH(l.[attributesize]), 0))  [data_size]

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

