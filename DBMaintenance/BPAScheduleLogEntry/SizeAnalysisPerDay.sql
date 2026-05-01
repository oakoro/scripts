
select  cast(entrytime as date)'date', count(*)'RowCount' from dbo.BPAScheduleLogEntry
GROUP BY cast(entrytime as date)
ORDER BY cast(entrytime as date)