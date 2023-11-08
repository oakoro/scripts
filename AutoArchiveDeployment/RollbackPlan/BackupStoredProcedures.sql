--select * from sys.procedures where SCHEMA_NAME(schema_id) = 'BPC'

select definition from [sys].[all_sql_modules] 
where object_id in 
(select object_id from sys.procedures where SCHEMA_NAME(schema_id) = 'BPC')
 