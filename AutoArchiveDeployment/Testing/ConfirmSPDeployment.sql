
declare @aasp_create_New_Sessionlog_partition sysname,
		@aasp_Update_adf_watermark_WQI sysname, @aasp_delete_copied_Sessionlog_partition sysname,
		@aasp_manage_BPASessionlogpartitions sysname, @adfsp_get_maxlogid sysname,
		@adfsp_get_minlogid sysname, @adfsp_get_sessionlog_data sysname, @adfsp_update_watermark_sessionlog sysname
		

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

select  @aasp_Update_adf_watermark_WQI'aasp_Update_adf_watermark_WQI',
		@aasp_create_New_Sessionlog_partition'aasp_create_New_Sessionlog_partition',
		@aasp_delete_copied_Sessionlog_partition'aasp_delete_copied_Sessionlog_partition',
		@aasp_manage_BPASessionlogpartitions'aasp_manage_BPASessionlogpartitions',
		@adfsp_get_maxlogid'adfsp_get_maxlogid',
		@adfsp_get_minlogid'adfsp_get_minlogid',
		@adfsp_get_sessionlog_data'adfsp_get_sessionlog_data',
		@adfsp_update_watermark_sessionlog'adfsp_update_watermark_sessionlog',
		@aasp_create_New_Sessionlog_partition'aasp_create_New_Sessionlog_partition'
