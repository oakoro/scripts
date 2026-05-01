-- ;with cte_1
-- AS
-- (
-- select stepname,count(*) 'RecordCount' from BPC.MaintenanceJobLog
-- GROUP BY stepname
-- HAVING count(*) > 1
-- )
-- select a.* from BPC.MaintenanceJobLog a join cte_1 b on a.stepname = b.stepname
-- ORDER BY a.startdatetime

select *,DATEDIFF(SECOND,startdatetime,enddatetime)'RunTimeSec',Duration/60 'DurationMin' from BPC.MaintenanceJobLog
ORDER BY startdatetime