/*****SPECIFY PERIOD TO CHECK IN HOURS ***************************/
DECLARE @period_hr INT = 2
/*****************************************************************/


DECLARE @startdate DATETIME

SELECT @startdate = DATEADD (HOUR , -@period_hr , GETDATE() )

select @startdate, GETDATE()

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
SELECT sessionnumber,startdatetime
 FROM [dbo].[BPASessionLog_NonUnicode]  WITH (NOLOCK)
WHERE startdatetime >=  @startdate
),

cte_sessions_activities_summary
AS
(
SELECT sl.sessionnumber,
FORMAT(DATEADD(MINUTE, -(s.starttimezoneoffset/60),sl.startdatetime),'yyyy-MM-dd HH:mm:ss')'startdatetime',
s.processname 
FROM cte_sessions_activities sl WITH (NOLOCK) JOIN cte_sessions_info s
ON sl.sessionnumber = s.sessionnumber
WHERE DATEADD(MINUTE, -(s.starttimezoneoffset/60),sl.startdatetime) >=  @startdate
),

cte_process_count
AS
(
SELECT startdatetime,processname,COUNT(*)'processCount' FROM cte_sessions_activities_summary
GROUP BY startdatetime,processname
),

cte_concurrent_sessions
AS
(
SELECT startdatetime, processname, processCount FROM cte_process_count
),

cte_current_session_summary
AS
(
SELECT startdatetime, COUNT(processname)'concurrentsessions' FROM cte_concurrent_sessions
GROUP BY startdatetime
HAVING COUNT(processname) > 1
)
SELECT ISNULL(MAX(concurrentsessions),0)'PeakConcurrentSessions' FROM cte_current_session_summary
