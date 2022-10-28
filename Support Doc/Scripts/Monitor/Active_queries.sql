--sp_who2 active



SELECT es.session_id, ib.event_info, es.status,er.blocking_session_id,
        es.cpu_time, memory_usage, es.logical_reads, es.writes, es.row_count
        total_elapsed_time, login_time, last_request_start_time, last_request_end_time
        host_name, program_name, login_name, es.open_transaction_count
FROM sys.dm_exec_sessions AS es 
JOIN sys.dm_exec_requests AS er ON es.session_id = er.session_id
CROSS APPLY sys.dm_exec_input_buffer(es.session_id, NULL) AS ib
WHERE es.session_id > 50 and es.status not in ('sleeping')