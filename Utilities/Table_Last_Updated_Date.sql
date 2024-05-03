SELECT t.object_id [ObjectId],
       s.name [Schema],
       t.name [TableName],
       MAX(us.last_user_update) [LastUpdate]
FROM sys.dm_db_index_usage_stats us
    JOIN sys.tables t
        ON t.object_id = us.object_id
    JOIN sys.schemas s
        ON s.schema_id = t.schema_id
WHERE us.database_id = DB_ID()
--AND t.object_id = OBJECT_ID('YourSchemaName.TableName') --Filter By Table
GROUP BY t.object_id,
         s.name,
         t.name
ORDER BY MAX(us.last_user_update) DESC;