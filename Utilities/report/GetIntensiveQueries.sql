/*
	Top 20 IO Intensive Queries
*/
;with high_io_queries as
(
    select top 20 
        query_hash, 
        sum(total_logical_reads + total_logical_writes) io
    from sys.dm_exec_query_stats 
    where query_hash <> 0x0
    group by query_hash
    order by sum(total_logical_reads + total_logical_writes) desc
)
select TOP 20 @@servername as servername,
    coalesce(db_name(st.dbid), db_name(cast(pa.value AS INT)), 'Resource') AS [DatabaseName],
    coalesce(object_name(ST.objectid, ST.dbid), '<none>') as [object_name],
    qs.query_hash,
    qs.total_logical_reads + total_logical_writes as total_io,
    qs.execution_count,
    cast((total_logical_reads + total_logical_writes) / (execution_count + 0.0) as money) as average_io,
    io as total_io_for_query,
    SUBSTRING(ST.TEXT,(QS.statement_start_offset + 2) / 2,
        (CASE 
            WHEN QS.statement_end_offset = -1  THEN LEN(CONVERT(NVARCHAR(MAX),ST.text)) * 2
            ELSE QS.statement_end_offset
            END - QS.statement_start_offset) / 2) as sql_text,
    qp.query_plan
from sys.dm_exec_query_stats qs WITH (NOLOCK)
INNER JOIN high_io_queries fq WITH (NOLOCK)
    on fq.query_hash = qs.query_hash
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan (qs.plan_handle) qp
OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa
where pa.attribute = 'dbid'
order by fq.io desc,
    fq.query_hash,
    qs.total_logical_reads + total_logical_writes desc
option (recompile);
GO

/*
	Top 20 CPU Intensive Queries
*/
;with high_cpu_queries as
(
    select top 20 
        query_hash, 
        sum(total_worker_time) cpuTime
    from sys.dm_exec_query_stats 
    where query_hash <> 0x0
    group by query_hash
    order by sum(total_worker_time) desc
)
select TOP 20 @@servername as server_name,
    coalesce(db_name(st.dbid), db_name(cast(pa.value AS INT)), 'Resource') AS [DatabaseName],
    coalesce(object_name(ST.objectid, ST.dbid), '<none>') as [object_name],
    qs.query_hash,
    qs.total_worker_time as cpu_time,
    qs.execution_count,
    cast(total_worker_time / (execution_count + 0.0) as money) as average_CPU_in_microseconds,
    cpuTime as total_cpu_for_query,
    SUBSTRING(ST.TEXT,(QS.statement_start_offset + 2) / 2,
        (CASE 
            WHEN QS.statement_end_offset = -1  THEN LEN(CONVERT(NVARCHAR(MAX),ST.text)) * 2
            ELSE QS.statement_end_offset
            END - QS.statement_start_offset) / 2) as sql_text,
    qp.query_plan
from sys.dm_exec_query_stats qs WITH (NOLOCK)
INNER JOIN high_cpu_queries hcq WITH (NOLOCK)
    on hcq.query_hash = qs.query_hash
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan (qs.plan_handle) qp
OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa
where pa.attribute = 'dbid'
order by hcq.cpuTime desc,
    hcq.query_hash,
    qs.total_worker_time desc
option (recompile);
GO

/*
	Top 20 Queries By Elapsed Time
*/
;with long_queries as
(
    select top 20 
        query_hash, 
        sum(total_elapsed_time) elapsed_time
    from sys.dm_exec_query_stats 
    where query_hash <> 0x0
    group by query_hash
    order by sum(total_elapsed_time) desc
)
select TOP 20 @@servername as server_name,
    coalesce(db_name(st.dbid), db_name(cast(pa.value AS INT)), 'Resource') AS [DatabaseName],
    coalesce(object_name(ST.objectid, ST.dbid), '<none>') as [object_name],
    qs.query_hash,
    qs.total_elapsed_time,
    qs.execution_count,
    cast(total_elapsed_time / (execution_count + 0.0) as money) as average_duration_in_microseconds,
    elapsed_time as total_elapsed_time_for_query,
    SUBSTRING(ST.TEXT,(QS.statement_start_offset + 2) / 2,
        (CASE 
            WHEN QS.statement_end_offset = -1  THEN LEN(CONVERT(NVARCHAR(MAX),ST.text)) * 2
            ELSE QS.statement_end_offset
            END - QS.statement_start_offset) / 2) as sql_text,
    qp.query_plan
from sys.dm_exec_query_stats qs
INNER JOIN long_queries lq
    on lq.query_hash = qs.query_hash
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_query_plan (qs.plan_handle) qp
outer apply sys.dm_exec_plan_attributes(qs.plan_handle) pa
where pa.attribute = 'dbid'
order by lq.elapsed_time desc,
    lq.query_hash,
    qs.total_elapsed_time desc
option (recompile);
GO

/*
	Top 20 Most frequent Queries
*/
;with frequent_queries as
(
    select top 20 
        query_hash, 
        sum(execution_count) executions
    from sys.dm_exec_query_stats 
    where query_hash <> 0x0
    group by query_hash
    order by sum(execution_count) desc
)
select TOP 20 @@servername as server_name,
    coalesce(db_name(st.dbid), db_name(cast(pa.value AS INT)), 'Resource') AS [DatabaseName],
    coalesce(object_name(ST.objectid, ST.dbid), '<none>') as [object_name],
    qs.query_hash,
    qs.execution_count,
    executions as total_executions_for_query,
    SUBSTRING(ST.TEXT,(QS.statement_start_offset + 2) / 2,
        (CASE 
            WHEN QS.statement_end_offset = -1  THEN LEN(CONVERT(NVARCHAR(MAX),ST.text)) * 2
            ELSE QS.statement_end_offset
            END - QS.statement_start_offset) / 2) as sql_text,
    qp.query_plan
from sys.dm_exec_query_stats qs WITH (NOLOCK)
INNER JOIN frequent_queries fq WITH (NOLOCK)
    on fq.query_hash = qs.query_hash
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan (qs.plan_handle) qp
OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa
where pa.attribute = 'dbid'
order by fq.executions desc,
    fq.query_hash,
    qs.execution_count desc
option (recompile);
GO