with cte_storedprocs
as
(
select name,
case 
 when modify_date > create_date then modify_date
 else create_date
end as updatedDate
from sys.procedures where schema_name(schema_id) = 'BPC'
)
select 
name,
UpdatedDate,
case 
when CHARINDEX('@version',definition) <> '0' then SUBSTRING(definition,CHARINDEX('@version',definition)+9,8)
when CHARINDEX('@version',definition) = '0' then '0'
end AS 'Version'
from cte_storedprocs p join [sys].[all_sql_modules] m on p.name = OBJECT_NAME(m.object_id)
