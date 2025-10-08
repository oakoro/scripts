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





