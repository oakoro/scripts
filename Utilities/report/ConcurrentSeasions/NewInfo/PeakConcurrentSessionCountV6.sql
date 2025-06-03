declare @hr int = 1
declare @startdate datetime, @startthreshold datetime

select @startdate = DATEADD (HOUR , -@hr , GETDATE() )
select @startdate,GETDATE()




;with cte_sessions
as
(
SELECT sessionnumber
    FROM   dbo.BPASession with (nolock)
    WHERE  startdatetime >= @startdate or enddatetime is null
 
)

,

cte_activities
as
(
select startdatetime from [dbo].[BPASessionLog_NonUnicode] with (nolock)
where sessionnumber in (select sessionnumber from cte_sessions) 
and startdatetime >  @startdate
),
cte_ConcurrentSessions
as
(
select FORMAT(startdatetime,'yyyy-MM-dd HH:mm:ss')'startdatetime',count(*) 'concurrentsessions' from cte_activities
group by startdatetime
)
select * from cte_ConcurrentSessions order by startdatetime
--select max(concurrentsessions) 'PeakConcurrentSessions' from cte_ConcurrentSessions


--select top 1 logid,sessionnumber ,startdatetime from [dbo].[BPASessionLog_NonUnicode] with (nolock) order by logid desc

--select GETutcDATE()

--select top 1 sessionnumber ,startdatetime,enddatetime, endtimezoneoffset,starttimezoneoffset from dbo.BPASession order by sessionnumber desc
----dateadd(SECOND,s.starttimezoneoffset,@now))