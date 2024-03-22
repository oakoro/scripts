declare @aasp_create_New_Sessionlog_partition sysname,
		@aasp_Update_adf_watermark_WQI sysname, @aasp_delete_copied_Sessionlog_partition sysname,
		@aasp_manage_BPASessionlogpartitions sysname, @adfsp_get_maxlogid sysname,
		@adfsp_get_minlogid sysname, @adfsp_get_sessionlog_data sysname, @adfsp_update_watermark_sessionlog sysname,
		@aasp_create_new_partition_BPASessionlog sysname
		

declare @check table (
CheckName sysname,
UpdatedDate datetime,
Version varchar(20)
)

;
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
insert @check(CheckName,UpdatedDate,Version)
select 
name,
UpdatedDate,
case 
when CHARINDEX('@version',definition) <> '0' then SUBSTRING(definition,CHARINDEX('@version',definition)+9,8)
when CHARINDEX('@version',definition) = '0' then '0'
end AS 'Version'
from cte_storedprocs p join [sys].[all_sql_modules] m on p.name = OBJECT_NAME(m.object_id)

select * from @check

--select name,updatedDate from cte_storedprocs

--select 
--CheckName,
--UpdatedDate,
--case 
--when CHARINDEX('@version',definition) <> '0' then SUBSTRING(definition,CHARINDEX('@version',definition)+9,8)
--when CHARINDEX('@version',definition) = '0' then '0'
--end AS 'Version'
--from @check c join [sys].[all_sql_modules] m on c.CheckName = OBJECT_NAME(m.object_id)
