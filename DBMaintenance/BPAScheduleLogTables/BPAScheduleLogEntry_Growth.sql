with cte
as
(
select  id,entrytime from dbo.BPAScheduleLogEntry with (nolock)
where datediff(dd,getdate(),entrytime) >= -14
)
select cast(entrytime as date) 'Date', count(id) 'RowCount' from cte
group by cast(entrytime as date)
order by [Date]


--select object_name(object_id)'TableName',sum(rows)'RowCount' from sys.partitions
--where object_name(object_id) in ('BPVGroupedResources',
--'BPAScheduleLog',
--'BPAScheduleLogEntry',
--'BPACaseLock',
--'BPASchedule',
--'BPAGroupResource',
--'BPAGroup',
--'BPATask',
--'BPATasksession',
--'BPACalendar',
--'BPANonWorkingDay') and index_id in (0,1)
--group by object_name(object_id) 

select  cast(instancetime as date) 'Date',count(*) 'RowCount' from dbo.BPAScheduleLog with (nolock)
where datediff(dd,getdate(),instancetime) >= -14
group by cast(instancetime as date)
order by [Date]