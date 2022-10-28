SELECT --25100189 - 25098587
s.Name AS SchemaName,
t.Name AS TableName,
p.rows AS RowCounts,
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB

FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN SYS.filegroups fg ON i.data_space_id = fg.data_space_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name, s.Name, p.Rows,fg.name
ORDER BY RowCounts desc,
s.Name, t.Name
GO

--select 26734867 - 25311400

/*
dbo	BPASessionLog_NonUnicodeCopy	37285200	188289.63	636.02	188925.64
dbo	BPASessionLog_NonUnicode1	37285200	188289.63	636.02	188925.64
dbo	BPASessionLog_NonUnicode	37285200	188289.63	636.02	188925.64
dbo	BPASessionLog_NonUnicodeReplica	280273139	277052.00	49.80	277101.80
*/