IF EXISTS (SELECT 1 FROM SYS.tables WHERE name = 'adf_watermark' AND SCHEMA_NAME(SCHEMA_ID) = 'BPC')
begin
update [BPC].[adf_watermark]
set deltacolumn = 'logid'
where tablename in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode');

update [BPC].[adf_watermark]
set deltacolumn = 'finished'
where tablename in ('BPAWorkQueueItem');
end

