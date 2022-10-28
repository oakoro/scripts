SELECT 
DB_NAME(database_id)'DBName',sum(num_of_reads)'num_of_reads',sum(io_stall_read_ms)'io_stall_read_ms',
sum(io_stall)'io_stall'
FROM sys.dm_io_virtual_file_stats(Null, Null)
group by DB_NAME(database_id)
order by num_of_reads desc