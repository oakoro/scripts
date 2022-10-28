select 
			ObjectSchema = OBJECT_SCHEMA_NAME(s.object_id)
			,ObjectName = object_name(s.object_id) 
			,s.object_id
			,s.stats_id
			,StatsName = s.name
			,sp.last_updated
			,sp.rows
			,sp.rows_sampled
			,sp.modification_counter
			, i.type
			, i.type_desc
			,0 as SkipStatistics
		into #statsBefore
		from sys.stats s cross apply sys.dm_db_stats_properties(s.object_id,s.stats_id) sp 
		left join sys.indexes i on sp.object_id = i.object_id and sp.stats_id = i.index_id
		where OBJECT_SCHEMA_NAME(s.object_id) != 'sys' --and /*Modified stats or Dummy mode*/(isnull(sp.modification_counter,0)>0 or @mode='dummy')
		order by sp.last_updated asc


		select * from #statsBefore a
		join 
		(SELECT Table_Name,Table_Schema, Index_Name,IndexSizeKB, COALESCE(LastScan,LastSeek,LastLookup) 'LastUsed'
FROM (
SELECT OBJECT_NAME(IX.OBJECT_ID) Table_Name
	   ,SCHEMA_NAME(TBL.schema_id) Table_Schema	
	   ,IX.name AS Index_Name
	   ,IX.type_desc Index_Type
	   ,SUM(PS.[used_page_count]) * 8 IndexSizeKB
	   ,IXUS.user_seeks AS NumOfSeeks
	   ,IXUS.user_scans AS NumOfScans
	   ,IXUS.user_lookups AS NumOfLookups
	   ,IXUS.user_updates AS NumOfUpdates
	   ,IXUS.last_user_seek AS LastSeek
	   ,IXUS.last_user_scan AS LastScan
	   ,IXUS.last_user_lookup AS LastLookup
	   ,IXUS.last_user_update AS LastUpdate
FROM sys.indexes IX
INNER JOIN sys.tables TBL ON IX.object_id = TBL.object_id
INNER JOIN sys.dm_db_index_usage_stats IXUS ON IXUS.index_id = IX.index_id AND IXUS.OBJECT_ID = IX.OBJECT_ID
INNER JOIN sys.dm_db_partition_stats PS on PS.object_id=IX.object_id AND PS.index_id = IX.index_id
WHERE OBJECTPROPERTY(IX.OBJECT_ID,'IsUserTable') = 1
GROUP BY OBJECT_NAME(IX.OBJECT_ID) ,SCHEMA_NAME(TBL.schema_id),IX.name ,IX.type_desc ,IXUS.user_seeks ,IXUS.user_scans ,IXUS.user_lookups,IXUS.user_updates ,IXUS.last_user_seek ,IXUS.last_user_scan ,IXUS.last_user_lookup ,IXUS.last_user_update
)LIST
WHERE COALESCE(LastScan,LastSeek,LastLookup)  IS NOT NULL AND IndexSizeKB > 0 AND Index_Name IS NOT NULL )
 b on a.ObjectName = b.Table_Name
 order by last_updated desc
 
 drop table #statsBefore