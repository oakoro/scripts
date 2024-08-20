sp_who2 active

select * from [sys].[event_log_ex] where event_type in ('connection_failed','deadlock') and database_name = 'RPA-Production'
order by start_time desc

select distinct event_type from [sys].[event_log_ex] 

/*
connection_failed
connection_successful
deadlock
*/