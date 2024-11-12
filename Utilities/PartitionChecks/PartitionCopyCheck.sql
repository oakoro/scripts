select * from BPC.adf_watermark;

SELECT p.partition_number,
       SUM(u.total_pages) * 8/1024 AS Total_Reserved_Mb,
       SUM(u.used_pages) * 8/1024 AS Used_Space_Mb,
         MAX(p.rows) AS RowsCount
FROM sys.allocation_units AS u
JOIN sys.partitions AS p ON u.container_id = p.hobt_id
JOIN sys.tables AS t ON p.object_id = t.object_id
WHERE OBJECT_NAME(t.object_id) = 'BPASessionLog_NonUnicode'
GROUP BY p.partition_number      
ORDER BY partition_number

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
WHERE i.type = 1 AND t.name = 'BPASessionLog_NonUnicode' 
ORDER BY p.partition_number ASC;