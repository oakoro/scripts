SELECT 
TOP 10
TableName,
indexName,
SUM(rows)'RowCounts', 
SUM(total_pages)'TotalPages',
SUM(used_pages)'UsedPages',
SUM(data_pages)'DataPages',
SUM(total_pages)*8/1024'TotalSpaceMB',
SUM(used_pages)*8/1024'UsedSpaceMB',
SUM(data_pages)*8/1024'DataSpaceMB'
FROM (
SELECT t.name TableName,i.name indexName,rows,SUM(total_pages) total_pages,SUM(used_pages) used_pages,
SUM(data_pages) data_pages
FROM sys.allocation_units a 
JOIN sys.partitions p on a.container_id = p.partition_id
JOIN sys.tables t on t.object_id = p.object_id
JOIN sys.indexes i on t.OBJECT_ID = i.object_id
WHERE 
    t.NAME NOT LIKE 'dt%' AND
    i.OBJECT_ID > 255 AND   
    i.index_id <= 1
group by t.name,i.name, rows
)a
GROUP BY TableName,indexName
ORDER BY TotalPages DESC
GO
