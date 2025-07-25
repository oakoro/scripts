--select id,queueid,loaded,finished from dbo.BPAWorkQueueItem with (nolock)
--where cast(loaded as date) = '2025-07-08'
--order by finished


--8244
declare @i int = 0
while @i < 10
begin
DELETE top (500) FROM dbo.BPAWorkQueueItem 
WHERE queueid = '3CD2D300-937B-44EB-A099-0EBA42DE4C6B' AND DATEPART(year,CAST(finished AS DATE)) = 2025 AND DATEPART(MONTH,CAST(finished AS DATE)) = 7 AND DATEPART(WEEK,CAST(finished AS DATE)) = 28 AND DATEPART(DAY,CAST(finished AS DATE)) = 8
set @i = @i  + 1
end

--select * from [dbo].[BPAWorkQueue] where id = '3CD2D300-937B-44EB-A099-0EBA42DE4C6B'