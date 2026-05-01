-- For CPU bottleneck
select top 10 creation_time, last_execution_time, execution_count, total_elapsed_time, total_worker_time,
total_physical_reads, total_logical_reads, total_rows,total_grant_kb ,DB_NAME(dbid)'DBName', text
from sys.dm_exec_query_stats qs cross apply sys.dm_exec_sql_text(qs.plan_handle) st
ORDER BY total_worker_time DESC