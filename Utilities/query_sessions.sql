SELECT r.session_id,s.host_name,s.program_name,c.connect_time,c.last_read,c.last_write,r.start_time,r.status,r.command,r.wait_type,r.total_elapsed_time,t.*
FROM sys.dm_exec_requests AS r join sys.dm_exec_connections AS c on r.session_id = c.session_id
join sys.dm_exec_sessions AS s on s.session_id = c.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
where r.session_id <> 95
--select top 2* from sys.dm_exec_requests
--select top 2* from sys.dm_exec_connections
--select top 2* from sys.dm_exec_sessions