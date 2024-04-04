SELECT t.object_id AS ObjectID,p.partition_number,
       OBJECT_NAME(t.object_id) AS ObjectName,
       SUM(u.total_pages) * 8 AS Total_Reserved_kb,
       SUM(u.used_pages) * 8 AS Used_Space_kb,
       u.type_desc AS TypeDesc,
       MAX(p.rows) AS RowsCount
FROM sys.allocation_units AS u
JOIN sys.partitions AS p ON u.container_id = p.hobt_id
JOIN sys.tables AS t ON p.object_id = t.object_id
WHERE OBJECT_NAME(t.object_id) = 'BPASessionLog_NonUnicode'
GROUP BY t.object_id,p.partition_number,
         OBJECT_NAME(t.object_id),
         u.type_desc
ORDER BY Used_Space_kb DESC,
         ObjectName;
GO

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

GO

SELECT
part.partition_number,
sum(alloc.total_pages/128) AS TotalTableSizeInMB,
sum(alloc.used_pages/128) AS UsedSizeInMB,
sum(alloc.data_pages/128) AS OtherDataSizeInMB
FROM sys.allocation_units AS alloc
INNER JOIN sys.partitions AS part ON alloc.container_id = CASE WHEN alloc.type in(1,3) THEN part.hobt_id ELSE part.partition_id END
LEFT JOIN sys.indexes AS idx ON idx.object_id = part.object_id AND idx.index_id = part.index_id
where part.object_id = object_id('BPASessionLog_NonUnicode')
group by partition_number

GO

select * FROM sys.allocation_units
select distinct partition_number, rows from sys.partitions where OBJECT_NAME(object_id) = 'BPASessionLog_NonUnicode'