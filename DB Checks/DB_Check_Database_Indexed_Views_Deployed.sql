/*List of indexed views deployed */
if exists(select 1 from sys.views where schema_name(schema_id)= 'BPC')
begin
select @@SERVERNAME'SQLServer',DB_NAME()'DatabaseName',
schema_name(v.schema_id) as schema_name,
       v.name as view_name,
       i.name as index_name,
	   v.create_date
       from sys.views v
join sys.indexes i
     on i.object_id = v.object_id
     and i.index_id = 1
     and i.ignore_dup_key = 0
end
else 
select DB_NAME() + ' in '+ @@SERVERNAME +' does not have indexed view'