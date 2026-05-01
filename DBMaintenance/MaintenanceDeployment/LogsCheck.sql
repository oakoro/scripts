select * from [BPC].[MaintenanceJobHistoryLog] where startdatetime > '2026-03-12 00:02:49.6000000'
select * from [BPC].[MaintenanceJobLog] where startdatetime > '2026-03-12 00:02:49.6000000'
select * from [BPC].[MaintenanceJobRowCountLog] where rundate > '2026-03-13'


--delete from [BPC].[MaintenanceJobHistoryLog] where startdatetime between '2026-03-12 00:02:49.6000000' and '2026-03-13 15:06:46.7700000'
--delete from [BPC].[MaintenanceJobLog] where startdatetime between '2026-03-12 00:02:49.6000000' and '2026-03-13 15:06:47.0633333'
--delete from [BPC].[MaintenanceJobRowCountLog] where rundate = '2026-03-13 15:06:46.863'

--select * from  BPC.MaintenanceItems;