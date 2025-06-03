declare @hr int = 1
declare @startdate datetime, @startthreshold datetime

select @startdate = DATEADD (HOUR , -@hr , GETDATE() )
select @startdate,GETDATE()




;with cte_sessions
as
(
SELECT sessionnumber,p.name 'processname',starttimezoneoffset
    FROM   dbo.BPASession s with (nolock) join dbo.BPAProcess p with (nolock) on s.processid = p.processid
    WHERE  startdatetime >= @startdate or enddatetime is null
 
)

,

cte_activities
as
(
select sl.sessionnumber,FORMAT(sl.startdatetime,'yyyy-MM-dd HH:mm:ss')'startdatetime',
FORMAT(DATEADD(MINUTE, -(s.starttimezoneoffset/60),sl.startdatetime),'yyyy-MM-dd HH:mm:ss')'startdatetime-Adj',
s.processname from [dbo].[BPASessionLog_NonUnicode] sl with (nolock) join cte_sessions s
on sl.sessionnumber = s.sessionnumber
where sl.startdatetime >  @startdate
 
)
--select * from cte_activities
,




cte_process_count
as
(
select [startdatetime-Adj],processname,count(*)'processCount' from cte_activities
group by [startdatetime-Adj],processname
),
cte_concurrent_sessions
as
(
--select startdatetime, processname, processCount, rank() over(partition by startdatetime order by processname desc )'Rank' from cte_process_count
select [startdatetime-Adj], processname, processCount from cte_process_count
)
--select * from cte_concurrent_sessions
,
cte_current_session_summary
as
(
select [startdatetime-Adj], count(processname)'concurrentsessions' from cte_concurrent_sessions
group by [startdatetime-Adj]
having count(processname) > 1
)
select MAX(concurrentsessions) from cte_current_session_summary
--cte_ConcurrentSessions
--as
--(
--select FORMAT(startdatetime,'yyyy-MM-dd HH:mm:ss')'startdatetime',count(*) 'concurrentsessions' from cte_activities
--group by startdatetime
--)
--select * from cte_ConcurrentSessions order by startdatetime
----select max(concurrentsessions) 'PeakConcurrentSessions' from cte_ConcurrentSessions


--select top 1 logid,sessionnumber ,startdatetime from [dbo].[BPASessionLog_NonUnicode] with (nolock) order by logid desc

--select GETutcDATE()

--select top 1 sessionnumber ,startdatetime,enddatetime, endtimezoneoffset,starttimezoneoffset from dbo.BPASession order by sessionnumber desc
----dateadd(SECOND,s.starttimezoneoffset,@now))


--select * from dbo.BPASession with (nolock) where sessionnumber = 75150