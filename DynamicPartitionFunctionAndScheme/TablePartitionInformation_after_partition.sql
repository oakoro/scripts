select db_name()+' database in '+@@servername +' after partition'as 'SessionlogPartitionStatus'
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
    --AND i.type IN (0,1)
INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions pf
	ON ps.function_id = pf.function_id


	SELECT 
    t.name AS [Table], 
    i.name AS [Index], 
    p.partition_number,
    f.name 'FunctionName',
    r.boundary_id, 
    r.value AS [Boundary Value] ,
	p.rows
	FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE --i.type = 1 AND 
t.name IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')
ORDER BY t.name ,p.partition_number ASC;
