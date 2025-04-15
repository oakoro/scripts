DECLARE @now DATETIME = GETDATE();
DECLARE @days INT = 7;
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
SELECT cast(ISNULL(startdatetime,@now) AS DATE) AS startdatetime,
           cast(ISNULL(enddatetime, @now) AS DATE) AS enddatetime
    FROM dbo.BPASession with (nolock)
    WHERE
        -- Sessions where either start or end is within the last @days days
        (
            startdatetime >= DATEADD(DAY, -@days, @now)
            OR enddatetime >= DATEADD(DAY, -@days, @now)
        )

--select COUNT(*) from  @events

--select top 1 @topevent = startdatetime from @events order by startdatetime
--select @topevent

--select * from @events where startdatetime = '2025-04-09' or enddatetime = '2025-04-09' 

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

select * from @eventtable
order by eventDate