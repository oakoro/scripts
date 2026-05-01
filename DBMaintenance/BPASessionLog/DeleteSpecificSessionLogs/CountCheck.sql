select DB_NAME()

 SELECT count(*) FROM dbo.BPASessionLog_NonUnicode with (nolock)
    WHERE sessionnumber in (8474,8476)
-- ;with cte_delete_sessionlog
-- AS
-- (
--     SELECT count(*) FROM dbo.BPASessionLog_NonUnicode
--     WHERE sessionnumber in (8474,8476)
-- )
-- DELETE from cte_delete_sessionlog