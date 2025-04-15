DECLARE @Now DATETIME = GETDATE();
DECLARE @Days INT = 7;
declare @eventdate date, @count int, @int int, @topevent date
declare @events table (
startdatetime date,
enddatetime date
)
declare @eventtable table (
eventDate date,
concurrentEvents int
)

insert @events
SELECT 
case 
when cast(ISNULL(startdatetime,@Now) as date) < cast(dateadd(DAY,-@Days,getdate()) as date)  then cast(dateadd(DAY,-@Days,getdate()) as date) 
else cast(ISNULL(startdatetime,@Now) as date)
end as startdatetime,
           cast(ISNULL(enddatetime, @Now) as date) AS enddatetime
    FROM dbo.BPASession with (nolock)
    WHERE
        
        (
            startdatetime >= DATEADD(DAY, -@Days, @Now)
            OR enddatetime >= DATEADD(DAY, -@Days, @Now)
        )



set @int = 0
select @count = COUNT(distinct startdatetime) from @events 
while (@count > @int)
begin
select top 1 @topevent = startdatetime from @events order by startdatetime

insert @eventtable
select @topevent as eventdate, count(*) as eventcount from @events 
where startdatetime = @topevent or enddatetime = @topevent;

delete @events where startdatetime = @topevent;
set @int = @int + 1
end

select MAX(concurrentEvents)'PeakConcurrentSessionsInLastXDays',MIN(concurrentEvents)'BottomConcurrentSessionsInLastXDays' from @eventtable
