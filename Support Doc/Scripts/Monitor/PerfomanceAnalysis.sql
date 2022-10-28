--select count(*) from WhoIsActive --116
--select count(*) from DBA_dm_db_resource_stats_Hist --627

--select top 1* from WhoIsActive order by collection_time desc
--select top 1* from DBA_dm_db_resource_stats_Hist order by end_time desc

--SELECT    
--    AVG(avg_cpu_percent) AS 'Average CPU Utilization In Percent',   
--    MAX(avg_cpu_percent) AS 'Maximum CPU Utilization In Percent',   
--    AVG(avg_data_io_percent) AS 'Average Data IO In Percent',   
--    MAX(avg_data_io_percent) AS 'Maximum Data IO In Percent',   
--    AVG(avg_log_write_percent) AS 'Average Log Write I/O Throughput Utilization In Percent',   
--    MAX(avg_log_write_percent) AS 'Maximum Log Write I/O Throughput Utilization In Percent',   
--    AVG(avg_memory_usage_percent) AS 'Average Memory Usage In Percent',   
--    MAX(avg_memory_usage_percent) AS 'Maximum Memory Usage In Percent'
--FROM DBA_dm_db_resource_stats_Hist; 
select
format(convert(datetime,end_time,22),'yyyy-MM-dd HH:mm:00')'MonitoringPeriodInMins',
avg(avg_cpu_percent)'avg_cpu_percent',avg(avg_data_io_percent)'avg_data_io_percent',
avg(avg_log_write_percent)'avg_log_write_percent',avg(avg_instance_cpu_percent)'avg_instance_cpu_percent',
avg(avg_instance_memory_percent)'avg_instance_memory_percent'
from DBA_dm_db_resource_stats_Hist with (nolock)
where format(convert(datetime,end_time,22),'yyyy-MM-dd HH:mm:00') > '2022-05-10 10:14:00'
group by format(convert(datetime,end_time,22),'yyyy-MM-dd HH:mm:00')
order by format(convert(datetime,end_time,22),'yyyy-MM-dd HH:mm:00') desc

select start_time,collection_time,session_id,blocking_session_id,sql_text,wait_info,CPU,writes,reads,physical_reads,
tempdb_allocations,tempdb_current,status from WhoIsActive with (nolock)
--where wait_info not like '%WAITFOR%' and wait_info is not null and collection_time > '2022-05-10 10:14:00'
--and start_time between '2022-04-12 11:13:05.170' and '2022-04-12 11:20:05.170'
--and blocking_session_id <> -5 and blocking_session_id is not null
order by collection_time desc , start_time desc

/*[dbo].[BPASessionLog_NonUnicode]
Performance graph showing impact of normal production activities on session log copy pipelines
'2022-04-12 09:57:05.170' and '2022-04-12 10:51:05.170' --- data contention causing numerous blocking due to slow refresh of pipeline control control table
Issue resolved by implementing indexed view 

exception
2022-04-12 11:13:05.170' and '2022-04-12 11:20:05.170'
due to yielding CPU to normal production session log update

short transient spike - due to concurrent running of over 200 and less than 200 pipelines. This situation can be controlled by separating each pipeline run
*/
--select * from  DBA_dm_db_resource_stats_Hist 
--where end_time > '2022-04-26 10:40:54.243'
--order by end_time