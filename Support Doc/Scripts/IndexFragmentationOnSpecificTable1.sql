SELECT OBJECT_NAME( a.object_id)'TableName', name 'IndexName', avg_fragmentation_in_percent

FROM sys.dm_db_index_physical_stats (

       DB_ID(N'RPA-Development')

     , OBJECT_ID('dbo.BPASessionLog_NonUnicode')

     , NULL

     , NULL

     , NULL) AS a

JOIN sys.indexes AS b

ON a.object_id = b.object_id AND a.index_id = b.index_id
order by TableName

--alter index all on [dbo].[BPASessionLog_NonUnicode] rebuild