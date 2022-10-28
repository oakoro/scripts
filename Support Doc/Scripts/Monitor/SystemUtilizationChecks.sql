exec sp_whoisactive;

--create table #systemUtilization (
--AVG_CPU_Util_Percent decimal(10,6),
--Max_CPU_Util_Percent decimal(10,6),
--AVG_Data_IO_Percent decimal(10,6),
--MAX_Data_IO_Percent decimal(10,6),
--AVG_Log_Write_IO_Throughput_Util_Percent decimal(10,6),
--MAX_Log_Write_IO_Throughput_Util_Percent decimal(10,6),
--AVG_Memory_Usage_Percent decimal(10,6),
--MAX_Memory_Usage_Percent decimal(10,6)
--)
--INSERT #systemUtilization
SELECT    
    AVG(avg_cpu_percent) AS 'Average CPU Utilization In Percent',   
    MAX(avg_cpu_percent) AS 'Maximum CPU Utilization In Percent',   
    AVG(avg_data_io_percent) AS 'Average Data IO In Percent',   
    MAX(avg_data_io_percent) AS 'Maximum Data IO In Percent',   
    AVG(avg_log_write_percent) AS 'Average Log Write I/O Throughput Utilization In Percent',   
    MAX(avg_log_write_percent) AS 'Maximum Log Write I/O Throughput Utilization In Percent',   
    AVG(avg_memory_usage_percent) AS 'Average Memory Usage In Percent',   
    MAX(avg_memory_usage_percent) AS 'Maximum Memory Usage In Percent'
FROM sys.dm_db_resource_stats; 
--SELECT * FROM #systemUtilization ORDER BY Max_CPU_Util_Percent
--DROP TABLE #systemUtilization;
SELECT end_time,   
  (SELECT Max(v)    
   FROM (VALUES (avg_cpu_percent), (avg_data_io_percent), (avg_log_write_percent)) AS    
   value(v)) AS [avg_DTU_percent]   
FROM sys.dm_db_resource_stats; 

select * 
from [sys].[dm_db_resource_stats]
order by end_time desc;


