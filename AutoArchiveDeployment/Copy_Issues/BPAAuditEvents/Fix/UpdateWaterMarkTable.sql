--Cambridge
select * from BPC.adf_watermark

select min(eventdatetime)  from dbo.BPAAuditEvents

select top 10*  from dbo.BPAAuditEvents with (nolock) where convert(varchar(20),eventdatetime,102) = '2024.05.31' order by eventdatetime
select top 2*  from dbo.BPAAuditEvents with (nolock) where convert(varchar(20),eventdatetime,102) < '2024.05.31' order by eventdatetime desc

--insert BPC.adf_watermark
--values('BPAAuditEvents','eventdatetime','2021-01-19 00:00:00.473',Null)2024-05-30 21:15:32.690

--update BPC.adf_watermark
--set last_processed_date = '2024-05-30 21:15:32.690'
--where tablename = 'BPAAuditEvents'

SELECT * 
FROM BPC.adf_configtable
WHERE sourcetable <> 'BPAAuditEvents';


select count(*) from dbo.BPAAuditEvents with (nolock) where eventdatetime > '2024-03-15 09:07:15.257'