sp_who2 active
go
--select * from sys.dm_exec_input_buffer(77,null)
select * from sys.dm_exec_requests where session_id > 50 and status not in ('background','sleeping')
go
sp_whoisactive
go
--select size*8/1024 from sysfiles where [name] <> 'log'

--kill 77