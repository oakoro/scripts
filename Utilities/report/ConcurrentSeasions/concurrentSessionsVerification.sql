DECLARE @Now DATETIME = GETDATE();
DECLARE @Days INT = 7;
declare @eventdate date, @count int, @int int, @topevent date

select * from (
SELECT sessionnumber,cast(ISNULL(startdatetime,@Now) as date) AS startdatetime,
           cast(ISNULL(enddatetime, @Now) as date) AS enddatetime
    FROM dbo.BPASession with (nolock)
    WHERE
        -- Sessions where either start or end is within the last @Days days
        (
            startdatetime >= DATEADD(DAY, -@Days, @Now)
            OR enddatetime >= DATEADD(DAY, -@Days, @Now)
        )
		--order by startdatetime,enddatetime

		)a
		where DATEDIFF(DAY,startdatetime,enddatetime) = 2 and DATEDIFF(DAY,startdatetime,enddatetime) is not null;


select *  FROM dbo.BPASession where sessionnumber in (746546,751357,746579,751479)

		--CO2106 (Coca Cola)


