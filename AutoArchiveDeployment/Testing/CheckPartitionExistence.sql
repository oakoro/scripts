BEGIN
IF EXISTS(SELECT 1 FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id) 
SELECT @@SERVERNAME AS ServerName, 'Partitioned' AS 'PartitionStatus'
else
SELECT @@SERVERNAME AS ServerName, 'Not Partitioned' AS 'PartitionStatus'
END
