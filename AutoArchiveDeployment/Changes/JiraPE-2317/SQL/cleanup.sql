select * from BPC.adf_watermark

--delete BPC.adf_watermark
--where tablename in ('BPAAuditEvents','BPAScheduleLog','BPAScheduleLogEntry','BPASession')


select * from sys.procedures order by create_date desc

--drop proc bpc.aasp_getCopyDatesDelta3