-- select * from sys.all_objects 
-- where SCHEMA_NAME(schema_id) = 'BPC' 
-- AND create_date > GETDATE() - 1
-- ORDER BY create_date --DESC

DECLARE @constraint TABLE (objName SYSNAME, pobjName SYSNAME)
 insert @constraint
 select name, OBJECT_NAME(parent_object_id) from sys.all_objects 
where SCHEMA_NAME(schema_id) = 'BPC' and [type] = 'D'
AND create_date > GETDATE() - 1

DECLARE @pkey TABLE (objName SYSNAME, pobjName SYSNAME)
 insert @pkey
 select name, OBJECT_NAME(parent_object_id)  from sys.all_objects 
where SCHEMA_NAME(schema_id) = 'BPC' and [type] = 'PK'
AND create_date > GETDATE() - 1

DECLARE @tables TABLE (objName SYSNAME)
 insert @tables
 select name from sys.all_objects 
where SCHEMA_NAME(schema_id) = 'BPC' and [type] = 'U'
AND create_date > GETDATE() - 1

DECLARE @procedure TABLE (objName SYSNAME)
 insert @procedure
 select name from sys.all_objects 
where SCHEMA_NAME(schema_id) = 'BPC' and [type] = 'P'
AND create_date > GETDATE() - 1


select 'ALTER TABLE BPC.'+pobjName +' DROP CONSTRAINT IF EXISTS '+objName+';'  from @constraint
select 'ALTER TABLE BPC.'+pobjName +' DROP CONSTRAINT IF EXISTS '+objName+';'  from @pkey
SELECT 'DROP TABLE IF EXISTS BPC.'+objName+';' FROM @tables
select 'DROP PROC IF EXISTS BPC.'+objName+';'  from @procedure





