sp_who2 active
--select * from sys.dm_exec_input_buffer(69,null)
select * from sys.dm_exec_requests where session_id > 50 and status not in ('background','sleeping')