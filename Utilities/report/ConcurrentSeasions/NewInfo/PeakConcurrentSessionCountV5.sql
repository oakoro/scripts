declare @hr int = 2
declare @startdate datetime, @startthreshold datetime

select @startdate = DATEADD (HOUR , -@hr , GETDATE() )
select @startdate,GETDATE()




;with cte_sessions
as
(
SELECT sessionnumber, startdatetime, isnull(enddatetime,GETDATE()) enddatetime
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
select startdatetime,count(*) 'concurrentsessions' from cte_activities
group by startdatetime
)
select max(concurrentsessions) 'PeakConcurrentSessions' from cte_ConcurrentSessions
