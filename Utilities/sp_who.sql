sp_who2 active
go
--select * from sys.dm_exec_input_buffer(96,null)
select percent_complete,blocking_session_id,wait_type,* from sys.dm_exec_requests where session_id > 50 and status not in ('background','sleeping')
go
sp_whoisactive
go
--select * from dbo.DBMaintenance --where tableName =  'BPASessionLog_NonUnicode'
--ORDER BY frag desc
--select size*8/1024 from sysfiles where [name] <> 'log'

--select * from sys.dm_db_wait_stats order by wait_time_ms desc

--select * from sys.partitions where OBJECT_NAME(object_id) = 'BPASession'

--select count(*) from dbo.usrWQIDeleted --order by year-- desc, month desc, week desc, day desc
--go
--select * from dbo.usrWQIDeleted with (nolock) 
----where queueID <> '6B6D92A9-87BD-4B24-9F9E-A8CB9FAA5FDE'
--order by year desc, month desc, week desc, day desc

--Check Resource Usage
--select top 10* from sys.dm_exec_query_stats
--order by total_worker_time desc, total_elapsed_time desc,execution_count desc

--select * from sys.dm_exec_sql_text(0x06000100A4A9B70F901D3F969601000001000000000000000000000000000000000000000000000000000000)

SELECT t.*
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE session_id > 50




