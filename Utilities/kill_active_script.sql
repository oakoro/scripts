DECLARE @kill VARCHAR(8000) = '';
SELECT @kill = @kill + 'killed ' + CONVERT(varchar(5), r.session_id) + ';'
FROM sys.dm_exec_requests AS r
     INNER JOIN sys.dm_exec_sessions AS s
         ON r.session_id = s.session_id
WHERE r.session_id > 50

print (@kill);