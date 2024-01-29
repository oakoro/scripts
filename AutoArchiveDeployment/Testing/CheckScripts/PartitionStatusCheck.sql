IF EXISTS (SELECT * FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode') and i.index_id = 1
)
BEGIN
SELECT @@SERVERNAME as 'DBServer', DB_NAME() as 'DBName', 'Done' as'PartitionStatus'
END
ELSE
SELECT @@SERVERNAME as 'DBServer', DB_NAME() as 'DBName', 'Not Done' as'PartitionStatus'




