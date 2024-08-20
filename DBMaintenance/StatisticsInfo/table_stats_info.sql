SELECT stats.name AS StatisticsName,
OBJECT_SCHEMA_NAME(stats.object_id) AS SchemaName,
OBJECT_NAME(stats.object_id) AS TableName,
[rows] AS [Rows],
last_updated AS LastUpdated, 
rows_sampled as [NumberofSamplingrows], modification_counter,
(rows_sampled * 100)/rows AS SamplePercent,
persisted_sample_percent PersistedSamplePercent
FROM sys.stats
INNER JOIN sys.stats_columns sc
ON stats.stats_id = sc.stats_id AND stats.object_id = sc.object_id
INNER JOIN sys.all_columns ac
ON ac.column_id = sc.column_id AND ac.object_id = sc.object_id
CROSS APPLY sys.dm_db_stats_properties(stats.object_id, stats.stats_id) dsp
where OBJECT_SCHEMA_NAME(stats.object_id) <> 'sys'