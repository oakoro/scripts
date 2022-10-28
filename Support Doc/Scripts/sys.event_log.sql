select * from sys.event_log
where event_type like '%fail%'
ORDER by start_time DESC
