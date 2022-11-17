select percent_complete,blocking_session_id,* from sys.dm_exec_requests where status not in ('background','sleeping')

SELECT 
 end_time AS [EndTime]
  , (SELECT Max(v) FROM (VALUES (avg_cpu_percent), (avg_data_io_percent), (avg_log_write_percent)) AS value(v)) AS [AvgDTU_Percent]  
  , ((dtu_limit)*((SELECT Max(v) FROM (VALUES (avg_cpu_percent), (avg_data_io_percent), (avg_log_write_percent)) AS value(v))/100.00)) AS [AvgDTUsUsed]
  , dtu_limit AS [DTULimit]
FROM sys.dm_db_resource_stats

--select *  FROM sys.dm_db_resource_stats