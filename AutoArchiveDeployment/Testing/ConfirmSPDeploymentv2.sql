declare @aasp_create_New_Sessionlog_partition sysname,
		@aasp_Update_adf_watermark_WQI sysname, @aasp_delete_copied_Sessionlog_partition sysname,
		@aasp_manage_BPASessionlogpartitions sysname, @adfsp_get_maxlogid sysname,
		@adfsp_get_minlogid sysname, @adfsp_get_sessionlog_data sysname, @adfsp_update_watermark_sessionlog sysname,
		@aasp_create_new_partition_BPASessionlog sysname
		

declare @check table (
CheckName sysname,
UpdatedDate datetime
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
insert @check(CheckName,UpdatedDate)
select name,updatedDate from cte_storedprocs

select @aasp_Update_adf_watermark_WQI = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'aasp_Update_adf_watermark_WQI'
select @aasp_create_New_Sessionlog_partition = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'aasp_create_New_Sessionlog_partition'
select @aasp_delete_copied_Sessionlog_partition = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'aasp_delete_copied_Sessionlog_partition'
select @aasp_manage_BPASessionlogpartitions = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'aasp_manage_BPASessionlogpartitions'
select @adfsp_get_maxlogid = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'adfsp_get_maxlogid'
select @adfsp_get_minlogid = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'adfsp_get_minlogid'
select @adfsp_get_sessionlog_data = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'adfsp_get_sessionlog_data'
select @adfsp_update_watermark_sessionlog = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'adfsp_update_watermark_sessionlog'
select @aasp_create_New_Sessionlog_partition = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'aasp_create_New_Sessionlog_partition'
select @aasp_create_new_partition_BPASessionlog = convert(nvarchar(20),UpdatedDate,20)  from @check where CheckName = 'aasp_create_new_partition_BPASessionlog'

select  isnull(@aasp_Update_adf_watermark_WQI,'Not Deployed')'aasp_Update_adf_watermark_WQI',
		isnull(@aasp_create_New_Sessionlog_partition,'Not Deployed')'aasp_create_New_Sessionlog_partition',
		isnull(@aasp_delete_copied_Sessionlog_partition,'Not Deployed')'aasp_delete_copied_Sessionlog_partition',
		isnull(@aasp_manage_BPASessionlogpartitions,'Not Deployed')'aasp_manage_BPASessionlogpartitions',
		isnull(@adfsp_get_maxlogid,'Not Deployed')'adfsp_get_maxlogid',
		isnull(@adfsp_get_minlogid,'Not Deployed')'adfsp_get_minlogid',
		isnull(@adfsp_get_sessionlog_data,'Not Deployed')'adfsp_get_sessionlog_data',
		isnull(@adfsp_update_watermark_sessionlog,'Not Deployed')'adfsp_update_watermark_sessionlog',
		isnull(@aasp_create_New_Sessionlog_partition,'Not Deployed')'aasp_create_New_Sessionlog_partition',
		isnull(@aasp_create_new_partition_BPASessionlog,'Not Deployed')'aasp_create_new_partition_BPASessionlog'
