SELECT object_name(so.object_id) AS ObjectName,
total_pages / 128. AS SpaceUsed_MB,
p.partition_id,
p.object_id,
p.index_id,
p.partition_number,
p.rows,
p.data_compression_desc
FROM sys.partitions AS p
JOIN sys.allocation_units AS au ON p.partition_id = au.container_id
JOIN sys.objects as so ON p.object_id = so.object_id
WHERE so.type = 'U'
	AND object_name(so.object_id) LIKE '%TransactionHistoryOke%'
ORDER BY ObjectName;