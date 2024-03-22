--select * from [sys].[all_sql_modules]

select substring(ltrim(object_name(object_id)),1,5),* from [sys].[all_sql_modules] --order by substring(ltrim(object_name(object_id)),1,4)
where substring(ltrim(object_name(object_id)),1,5) in ('aasp_','adfsp')

select object_name(object_id)'SP_Name',
len(definition)'SP_Length',
datalength(definition)'SP_Size_Byte' from [sys].[all_sql_modules] 
where substring(ltrim(object_name(object_id)),1,5) in ('aasp_','adfsp')
 