SELECT DB_NAME(database_id)'DBName', *
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
ORDER BY 5 DESC;