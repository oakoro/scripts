select @@SERVERNAME'DBServer',* from [BPC].[MaintenanceJobHistoryLog] where startdatetime > '2026-03-12 00:02:49.6000000'
select @@SERVERNAME'DBServer',* from [BPC].[MaintenanceJobLog] where startdatetime > '2026-03-12 00:02:49.6000000'
select @@SERVERNAME'DBServer',* from [BPC].[MaintenanceJobRowCountLog] where rundate > '2026-03-13'