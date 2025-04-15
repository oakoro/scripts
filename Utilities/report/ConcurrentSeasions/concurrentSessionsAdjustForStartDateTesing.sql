DECLARE @now DATETIME = GETDATE();
DECLARE @days INT = 7;
declare @eventdate date, @count int, @int int, @topevent date

select dateadd(DAY,-@days,getdate())

declare @events table (
sessionnum bigint,
startdatetime1 datetime,
enddatetime1 datetime,
startdatetime date,
enddatetime date
)
declare @eventtable table (
eventDate date,
concurrentEvents int
)

insert @events
SELECT sessionnumber,startdatetime,enddatetime,
case 
when cast(ISNULL(startdatetime,@now) AS DATE) < cast(getdate() AS DATE) then cast(dateadd(DAY,-@days,getdate()) AS DATE) 
else cast(ISNULL(startdatetime,@now) AS DATE)
end as startdatetime,
           cast(ISNULL(enddatetime, @now) AS DATE) AS enddatetime
    FROM dbo.BPASession with (nolock)
    WHERE
        -- Sessions where either start or end is within the last @days days
        (
            startdatetime >= DATEADD(DAY, -@days, @now)
            OR enddatetime >= DATEADD(DAY, -@days, @now)
        )
select * from  @events order by startdatetime1 

