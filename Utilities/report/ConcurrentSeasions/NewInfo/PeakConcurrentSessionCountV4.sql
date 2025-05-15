declare @hr int = 2
declare @startdate datetime, @startthreshold datetime
--select @startdate = DATEADD (DAY , -@min , GETDATE() )
select @startdate = DATEADD (HOUR , -@hr , GETDATE() )
select @startdate,GETDATE()




;
with cte_active
as
(
SELECT sessionnumber, startdatetime, isnull(enddatetime,GETDATE()) enddatetime
    FROM   dbo.BPASession
    WHERE  startdatetime >= @startdate
    --AND    startdatetime <  GETDATE()
	AND statusid IN (0,1,7)
),
cte_notactive
as
(
SELECT sessionnumber, startdatetime, isnull(enddatetime,GETDATE()) enddatetime
    FROM   dbo.BPASession
    WHERE  startdatetime >= @startdate
    --AND    startdatetime <  GETDATE()
	AND statusid NOT IN (0,1,7) 
),
cte_combined
as
(
SELECT * FROM cte_active
union
SELECT * FROM cte_notactive
),
--select * from cte_combined order by sessionnumber
cte_activities
as
(
select sessionnumber,startdatetime from [dbo].[BPASessionLog_NonUnicode] with (nolock)
where sessionnumber in (select sessionnumber from cte_combined) 
and startdatetime >  @startdate
)
--select * from cte_activities
,
cte_activities_actual
as
(
select distinct sessionnumber, cast(startdatetime as smalldatetime) startdatetime from cte_activities
),
cte_ConcurrentSessions
as
(
select startdatetime,count(*) 'concurrentsessions' from cte_activities_actual
group by startdatetime
)
select max(concurrentsessions) 'PeakConcurrentSessions' from cte_ConcurrentSessions
