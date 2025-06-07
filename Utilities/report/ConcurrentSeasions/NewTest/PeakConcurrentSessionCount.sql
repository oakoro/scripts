/*****SPECIFY PERIOD TO CHECK IN HOURS ***************************/
DECLARE @period_hr INT = 1
/*****************************************************************/


DECLARE @startdate DATETIME

SELECT @startdate = DATEADD (HOUR , -@period_hr , GETDATE() )

DECLARE @peakstr NVARCHAR(50) = 'PeakConcurrentSessionsInLast-'+CONVERT(CHAR(1),@period_hr)+'-Hours'


;WITH cte_sessions_info
AS
(
SELECT 
sessionnumber,
p.name 'processname',
starttimezoneoffset
FROM   dbo.BPASession s WITH (NOLOCK) JOIN dbo.BPAProcess p WITH (NOLOCK) 
ON s.processid = p.processid
WHERE DATEADD(MINUTE, -(starttimezoneoffset/60),startdatetime) >= @startdate 
OR enddatetime IS NULL
),

cte_sessions_activities
AS
(
SELECT sl.sessionnumber,
FORMAT(DATEADD(MINUTE, -(s.starttimezoneoffset/60),sl.startdatetime),'yyyy-MM-dd HH:mm:ss')'startdatetime',
s.processname 
FROM [dbo].[BPASessionLog_NonUnicode] sl WITH (NOLOCK) JOIN cte_sessions_info s
ON sl.sessionnumber = s.sessionnumber
WHERE DATEADD(MINUTE, -(s.starttimezoneoffset/60),sl.startdatetime) >=  @startdate
),
cte_distinct_process
AS
(
SELECT startdatetime,processname FROM cte_sessions_activities
GROUP BY startdatetime,processname
),
cte_current_session_summary
AS
(
SELECT startdatetime, COUNT(processname)'concurrentsessions' FROM cte_distinct_process
GROUP BY startdatetime
HAVING COUNT(processname) > 1
)
SELECT @peakstr+' = ' + CONVERT(NVARCHAR(5),ISNULL(MAX(concurrentsessions),0))'PeakConcurrentSessions' FROM cte_current_session_summary
