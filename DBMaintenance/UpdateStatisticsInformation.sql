SELECT 
  sh.[name] as [schema_name], 
  so.[name] as [table_name], 
  pr.[rows] as [table_rows], 
  st.[name] as [stats_name], 
  st.[stats_id], 
  STRING_AGG(cl.[name], ', ') WITHIN GROUP (
    ORDER BY 
      st.[stats_id] ASC
  ) as [column_name], 
  st.[auto_created], 
  st.[is_incremental], 
  st.[is_temporary], 
  st.[filter_definition], 
  sp.[last_updated], 
  sp.[rows],
  sp.[rows_sampled], 
  CAST(
    (
      sp.[rows_sampled] * 1.00 / sp.[rows] * 1.00
    )* 100 as decimal(8, 2)
  ) as [pct_sampled], 
  sp.[persisted_sample_percent], 
  sp.[modification_counter] as [row_modification_counter], 
  CASE         WHEN cp.[compatibility_level] <= 120 THEN CAST(
    500 + (0.2 * sp.[rows]) AS integer
  )         WHEN cp.[compatibility_level] > 120 
  AND (
    500 + (0.2 * sp.[rows])
  ) < (
    SQRT(1000 * sp.[rows])
  ) THEN CAST(
    500 + (0.2 * sp.[rows]) AS integer
  )         ELSE CAST(
    SQRT(1000 * sp.[rows]) AS integer
  )       END [row_modification_threshold] 
FROM 
  sys.stats st   
  JOIN sys.stats_columns sc ON st.[object_id] = sc.[object_id] 
  AND st.[stats_id] = sc.[stats_id]   
  JOIN sys.columns cl ON sc.[object_id] = cl.[object_id] 
  AND sc.[column_id] = cl.[column_id]   
  JOIN sys.objects so ON so.[object_id] = st.[object_id]   
  JOIN sys.schemas sh ON so.[schema_id] = sh.[schema_id]   
  JOIN (
    SELECT 
      [object_id], 
      SUM([rows]) [rows] 
    FROM 
      sys.partitions         
    WHERE 
      [index_id] IN (0, 1) 
    GROUP BY 
      [object_id]
  ) pr ON so.[object_id] = pr.[object_id]   CROSS APPLY sys.dm_db_stats_properties(st.[object_id], st.[stats_id]) sp   CROSS 
  JOIN (
    SELECT 
      [compatibility_level] 
    FROM 
      sys.databases 
    WHERE 
      database_id = db_id()
  ) cp 
GROUP BY 
  sh.[name], 
  so.[name], 
  pr.[rows], 
  st.[name], 
  st.[stats_id], 
  st.[auto_created], 
  st.[is_incremental], 
  st.[is_temporary], 
  st.[filter_definition], 
  sp.[last_updated], 
  sp.[modification_counter], 
  sp.[rows], 
  sp.[rows_sampled], 
  sp.[persisted_sample_percent], 
  cp.[compatibility_level] 
ORDER BY 
  sh.[name], 
  so.[name], 
  st.[stats_id]