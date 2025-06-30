drop table if exists #BPAScheduleLogEntry ;

create table #BPAScheduleLogEntry (
id bigint,
entrytime datetime
)
create nonclustered index noncl_BPASchLogEntry_entrytime on #BPAScheduleLogEntry (entrytime);


insert #BPAScheduleLogEntry(id,entrytime)
select top 50000000 id, entrytime from BPAScheduleLogEntry with (nolock) 
where id > 290049927
order by id -- 306,001,643

select max(id) 'MaxID' from #BPAScheduleLogEntry

;
with cte
as
(
select cast(entrytime as date) as entrytime, count(id) 'recdCount' from #BPAScheduleLogEntry
group by entrytime
)
select entrytime, sum(recdCount) from cte
group by entrytime
order by entrytime