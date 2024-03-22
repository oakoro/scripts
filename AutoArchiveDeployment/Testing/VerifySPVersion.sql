SELECT OBJECT_NAME(object_id)'SP_Name',
SUBSTRING(definition,CHARINDEX('@version',definition)+9,8)'Version'
FROM [sys].[all_sql_modules] 
WHERE CHARINDEX('@version',definition) <> 0 and SUBSTRING(LTRIM(OBJECT_NAME(object_id)),1,5) in ('aasp_','adfsp')

