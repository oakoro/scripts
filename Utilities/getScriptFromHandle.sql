--SELECT s.login_time,s.host_name, t.*,r.*
--FROM sys.dm_exec_requests AS r join sys.dm_exec_sessions s on r.session_id = s.session_id
--CROSS APPLY sys.dm_exec_sql_text(0x020000009d5f1c1e554b54ec0ae5e6362aef6a1e6143c86c0000000000000000000000000000000000000000) AS t
--order by login_time desc

--select * from sys.dm_exec_sessions

--GBAZCOIO1

SELECT  s.login_time,s.host_name,s.session_id, t.*,r.*
FROM sys.dm_exec_requests AS r join sys.dm_exec_sessions s on r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t