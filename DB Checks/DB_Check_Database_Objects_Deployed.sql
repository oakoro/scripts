/*Get database objects deployed */
select @@SERVERNAME'serverName',DB_NAME()'dbName',
name, SCHEMA_NAME(schema_id)'schemaName',type_desc,create_date,modify_date 
from sys.objects where type not in ('S','IT','SQ') and SCHEMA_NAME(schema_id) = 'BPC'
order by name