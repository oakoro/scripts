select * from BPC.adf_watermark

delete BPC.adf_watermark
where tablename in ('BPAAuditEvents','BPAScheduleLog','BPAScheduleLogEntry','BPASession')