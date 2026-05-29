SELECT sp.stats_id, 
	object_name(stat.object_id)'tablename',
       stat.name 'statname', 
       filter_definition, 
       last_updated, 
       rows, 
       rows_sampled, 
       steps, 
       unfiltered_rows,
       modification_counter,
		user_created,
		auto_created
FROM sys.stats AS stat
		join sys.tables tab on stat.object_id = tab.object_id
     CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
where tab.type = 'U'
order by last_updated desc

--select * from sys.indexes