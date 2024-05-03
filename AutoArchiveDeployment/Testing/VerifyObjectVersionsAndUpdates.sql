SELECT OBJECT_NAME(object_id)'SP_Name',
SUBSTRING(definition,CHARINDEX('@version',definition)+9,8)'Version'
FROM [sys].[all_sql_modules] 
WHERE CHARINDEX('@version',definition) <> 0 and 
SUBSTRING(LTRIM(OBJECT_NAME(object_id)),1,5) in ('aasp_','adfsp')

go


declare @checklist table (
CheckName sysname,
Type sysname,
Status sysname default 'Unknown'
)

declare @check table (
CheckName sysname,
UpdatedDate datetime
)

;
with cte_schema
as
(
select name from sys.schemas where name = 'BPC'
),
cte_tables
as
(
select name,
case 
 when modify_date > create_date then modify_date
 else create_date
end as updatedDate
from sys.tables where schema_name(schema_id) = 'BPC'
),
cte_v
as
(
SELECT t.name [TableName], MAX(us.last_user_update) [LastUpdate]
FROM sys.dm_db_index_usage_stats us JOIN sys.tables t ON t.object_id = us.object_id
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name = 'BPC'
GROUP BY t.name
),
cte_table_c
as
(
select v.[TableName],
case
when v.[LastUpdate] > t.updatedDate then v.[LastUpdate]
else t.updatedDate
end as updatedDate
from cte_v v join cte_tables t on v.TableName = t.name
),		
cte_storedprocs
as
(
select name,
case 
 when modify_date > create_date then modify_date
 else create_date
end as updatedDate
from sys.procedures where schema_name(schema_id) = 'BPC'
)
insert @check(CheckName,UpdatedDate)
select name,Null from cte_schema
union
select [TableName],updatedDate from cte_table_c
union
select name,updatedDate from cte_storedprocs

select * from @check order by UpdatedDate desc