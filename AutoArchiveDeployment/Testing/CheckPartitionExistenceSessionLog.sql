--SELECT 1 FROM sys.indexes i     
--			INNER JOIN sys.partition_schemes ps   
--			ON i.data_space_id = ps.data_space_id
--WHERE OBJECT_NAME(object_id) in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')


BEGIN
IF EXISTS(SELECT 1 FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')) 
SELECT @@SERVERNAME AS ServerName, 'Partitioned' AS 'PartitionStatus'
else
SELECT @@SERVERNAME AS ServerName, 'Not Partitioned' AS 'PartitionStatus'
END