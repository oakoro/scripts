select * from BPC.adf_watermark

--delete BPC.adf_watermark
--where tablename in ('BPAAuditEvents','BPAScheduleLog','BPAScheduleLogEntry','BPASession')


select * from sys.procedures order by create_date desc

--drop proc bpc.aasp_getCopyDatesDelta3




--;with bpasession_upd
--as
--(
--select top 10* from dbo.BPASession
--where enddatetime is null
--)
--update bpasession_upd
--set enddatetime = GETDATE()

--BPAAuditEvents	eventdatetime	2021-07-16 21:21:25.780	NULL
--BPASession	enddatetime	2024-11-20 16:36:12.017	NULL