EXECUTE AS USER = 'BPC_RPA_ReadOnly';

--SELECT
--sc.name 'SchemaName'
--,ob.name 'TableName'
--,i.name 'IndexName'
--,partition_number 'PartitionNo' 
--,avg_fragmentation_in_percent 'PercentFragmentation'
--FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') st
--JOIN sys.objects ob on st.object_id = ob.object_id
--JOIN sys.schemas as sc ON sc.schema_id = ob.schema_id
--JOIN sys.indexes i on i.object_id = ob.object_id and i.type = st.index_id
--WHERE avg_fragmentation_in_percent > 10.0 AND st.index_id > 0 AND page_count > 500
--SELECT *
--FROM fn_my_permissions('HumanResources.Employee', 'OBJECT')
--ORDER BY subentity_name, permission_name;

select top 1* from dbo.BPAAlertEvent;

REVERT;
GO

--SELECT * FROM fn_my_permissions('BPC_RPA_ReadOnly', 'USER');
--GO

--GRANT VIEW DATABASE STATE TO [BPC_RPA_ReadOnly]; 

--select * from sys.database_principals where name = 'BPC_RPA_ReadOnly'
--select * from sys.database_permissions where grantee_principal_id = 11