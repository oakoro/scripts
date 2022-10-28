select * from [sys].[dm_tran_database_transactions]
select * from [sys].[dm_tran_active_transactions]
select * from [sys].[dm_tran_locks]
select * from sys.dm_exec_requests where status not in ('background')
select * from sys.dm_exec_session_wait_stats
select * from sys.dm_exec_sessions