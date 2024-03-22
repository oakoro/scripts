select object_name(m.object_id)'SP_Name',p.create_date,
len(definition)'SP_Length',
datalength(definition)'SP_Size_Byte' from [sys].[all_sql_modules] m join sys.procedures p on m.object_id = p.object_id
where substring(ltrim(object_name(m.object_id)),1,5) in ('aasp_','adfsp') and p.create_date > getdate()-6
order by SP_Name


