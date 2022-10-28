select * from sys.event_log_ex

select distinct database_name, max(start_time)'LastDateAccessed',min(start_time)'OldestDateAccessed' from sys.event_log_ex
where event_type = 'connection_successful'
group by database_name
order by LastDateAccessed desc