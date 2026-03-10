select * from sys.tables where [type] = 'U' and name like '%Temp%'

select count(*) from BPAScheduleLogEntry_Temp

-- sp_whoisactive

-- drop TABLE BPAAuditEvents_Temp,BPAProcess_Temp,BPAScheduleLog_Temp,BPAWorkQueueItem_Temp,BPAWorkQueueItemTag_Temp,BPAScheduleLogEntry_Temp

