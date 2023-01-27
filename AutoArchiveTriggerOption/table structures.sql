SELECT
    s.NAME AS 'schema'
    , o.NAME AS 'table'
    , CASE o.type
          WHEN 'v' THEN 'View'
          WHEN 'u' THEN 'Table'
          ELSE o.type
      END AS objecttype
    , i.NAME AS indexname
    , i.type_desc
    , p.data_compression_desc
    , ds.type_desc AS DataSpaceTypeDesc
    , p.partition_number
    , pf.NAME AS pf_name
    , ps.NAME AS ps_name
    , partitionds.NAME AS partition_fg
    , i.is_primary_key
    , p.rows
    , pst.UsedMB
FROM   sys.indexes i
       INNER JOIN sys.objects o
               ON o.object_id = i.object_id
       INNER JOIN sys.data_spaces ds
               ON DS.data_space_id = i.data_space_id
       LEFT JOIN sys.schemas s
              ON o.schema_id = s.schema_id
       LEFT JOIN sys.partitions p
              ON i.index_id = p.index_id
             AND i.object_id = p.object_id
       LEFT JOIN sys.destination_data_spaces dds
              ON i.data_space_id = dds.partition_scheme_id
             AND p.partition_number = dds.destination_id
       LEFT JOIN sys.data_spaces partitionds
              ON dds.data_space_id = partitionds.data_space_id
       LEFT JOIN sys.partition_schemes AS ps
              ON dds.partition_scheme_id = ps.data_space_id
       LEFT JOIN sys.partition_functions AS pf
              ON ps.function_id = pf.function_id
       INNER JOIN (SELECT
                       object_id
                       , index_id
                       , partition_id
                       , SUM(used_page_count) AS UsedPages
                       , CAST(((SUM(used_page_count) * 8.0) / 1024.0) AS NUMERIC(18, 2)) AS UsedMB
                   FROM   sys.dm_db_partition_stats
                   GROUP  BY
                      object_id
                      , index_id
                      , partition_id) AS pst
               ON p.index_id = pst.index_id
              AND p.object_id = pst.object_id
              AND p.partition_id = pst.partition_id
WHERE
    s.NAME NOT IN ('sys', 'cdc')
    AND o.NAME = 'bpsessionlogPartitionTest'
ORDER  BY
    s.NAME
    , o.NAME
    , i.NAME
    , p.partition_number
GO