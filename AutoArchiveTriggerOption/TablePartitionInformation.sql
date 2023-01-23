SELECT
    t.name AS [Table],
    i.name AS [Index],
    i.type_desc,
    i.is_primary_key,
    ps.name AS [Partition Scheme],
	pf.name AS [Partition Function]
FROM sys.tables t
INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    AND i.type IN (0,1)
INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions pf
	ON ps.function_id = pf.function_id
