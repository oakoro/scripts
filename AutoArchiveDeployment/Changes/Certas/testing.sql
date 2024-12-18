select * from BPC.adf_configtable order by sourcetable 
select * from BPC.adf_watermark

--update BPC.adf_watermark
--set last_processed_date = '1900-01-01 00:00:00.000'
--where tablename in ('BPAAuditEvents','BPAScheduleLog','BPAScheduleLogEntry','BPASession')
--"2024-12-17T00:31:03.547Z",
--2024-12-17 11:01:06.480 new

--update BPC.adf_watermark
--set last_processed_date = '2024-12-17T00:31:03.547Z'
--where tablename = 'BPAWorkQueueItem'

--update BPC.adf_watermark
--set logid = 125116279
--where tablename = 'BPASessionLog_NonUnicode'
--126322952
--125116279