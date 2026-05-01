-- For Memory bottleneck
SELECT *
FROM sys.dm_os_memory_clerks
ORDER BY pages_kb DESC;