--select *  FROM sys.dm_db_index_usage_stats

--select * from sys.event_log_ex



select 
OBJECT_NAME(object_id)'ObjectName',
max(COALESCE(last_user_seek,last_user_scan,last_user_lookup,last_user_update)) AS 'LastDateAccessed',
min(COALESCE(last_user_seek,last_user_scan,last_user_lookup,last_user_update)) AS 'OldestDateAccessed'
FROM sys.dm_db_index_usage_stats
group by OBJECT_NAME(object_id)


select max(LastDateAccessed)'LastDateAccessed' from (
select 
case
when last_user_update is null then
COALESCE(last_user_seek,last_user_scan,last_user_lookup)
else last_user_update
end
AS 'LastDateAccessed'
FROM sys.dm_db_index_usage_stats
)a



select convert(varchar(20),COALESCE(last_user_seek,last_user_scan,last_user_lookup,last_user_update),103) AS 'LastDateAccessed'
FROM sys.dm_db_index_usage_stats
order by LastDateAccessed



