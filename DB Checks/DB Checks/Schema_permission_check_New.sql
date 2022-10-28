select * from sys.all_views
where name = 'aavw_Get_Sessionnumber_BPASessionLog_NonUnicode'
order by create_date

--SELECT * FROM fn_my_permissions('BPC', 'SCHEMA')


SELECT state_desc
    ,permission_name
    ,'ON'
    ,class_desc
    ,SCHEMA_NAME(11)
    ,'TO'
    ,USER_NAME(grantee_principal_id)
FROM sys.database_permissions AS PERM
JOIN sys.database_principals AS Prin
    ON PERM.major_ID = Prin.principal_id
        AND class_desc = 'SCHEMA'
WHERE major_id = SCHEMA_ID('BPC')
    AND grantee_principal_id = user_id('BPC-DataFactory-f3elkjli27eli')


	--select * from sys.database_principals