DECLARE @Now DATETIME = GETDATE();
DECLARE @Days INT = 7;

with cte_1
as
(
SELECT sessionnumber,ISNULL(startdatetime,@Now) AS startdatetime,
           ISNULL(enddatetime, @Now) AS enddatetime
    FROM dbo.BPASession with (nolock)
    WHERE
        -- Sessions where either start or end is within the last @Days days
        (
            startdatetime >= DATEADD(DAY, -@Days, @Now)
            OR enddatetime >= DATEADD(DAY, -@Days, @Now)
        )

),
cte_2
as
(
select sessionnumber,cast(startdatetime as date)'startdatetime',cast(enddatetime as date)'enddatetime' from cte_1
--order by startdatetime
),
cte_3
as
(
select sessionnumber,startdatetime,enddatetime, datediff(day,startdatetime,enddatetime)'event' from cte_2
--order by startdatetime
)
--select startdatetime, count(*) 'eventdate' from cte_3
--where event = 0
--group by startdatetime
--order by startdatetime
select enddatetime, count(*) 'eventdate' from cte_3
where event <> 0
group by enddatetime
order by enddatetime

