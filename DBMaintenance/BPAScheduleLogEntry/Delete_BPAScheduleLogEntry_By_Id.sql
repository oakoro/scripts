--select top 1* from dbo.BPAScheduleLogEntry with (nolock) where entrytime > '2025-06-01 00:00:00.883'


--select top 1* from dbo.BPAScheduleLogEntry with (nolock) order by id

--delete dbo.BPAScheduleLogEntry
--where id < 3000000

declare @lastid bigint = 270636847, @curid bigint

select top 1 @curid = id from dbo.BPAScheduleLogEntry order by id
--select @curid

while @curid < 270636847
begin
delete top(200) dbo.BPAScheduleLogEntry
where id >= @curid
set @curid = @curid + 200
end