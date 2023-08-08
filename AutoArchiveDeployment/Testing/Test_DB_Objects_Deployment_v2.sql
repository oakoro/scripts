declare @BPC sysname,@adf_configtable sysname,
		@adf_watermark sysname,@aasp_create_New_Sessionlog_partition sysname,
		@aasp_Update_adf_watermark_WQI sysname, @aasp_delete_copied_Sessionlog_partition sysname,
		@aasp_manage_BPASessionlogpartitions sysname, @adfsp_get_maxlogid sysname,
		@adfsp_get_minlogid sysname, @adfsp_get_sessionlog_data sysname, @adfsp_update_watermark_sessionlog sysname,
		@Populate_adf_configtable sysname, @Populate_adf_watermark sysname, @ADF_Managed_Identity sysname

declare @checklist table (
CheckName sysname,
Type sysname,
Status sysname default 'Unknown'
)

declare @check table (
CheckName sysname
)

insert @checklist(CheckName,Type)
values('BPC','Schema'),
	  ('adf_configtable','U'),
	  ('adf_watermark','U'),
	  ('aasp_create_New_Sessionlog_partition','P'),
	  ('aasp_Update_adf_watermark_WQI','P'),
	  ('aasp_delete_copied_Sessionlog_partition','P'),
	  ('aasp_manage_BPASessionlogpartitions','P'),
	  ('adfsp_get_maxlogid','P'),
	  ('adfsp_get_minlogid','P'),
	  ('adfsp_get_sessionlog_data','P'),
	  ('adfsp_update_watermark_sessionlog','P')



;
with cte_schema
as
(
select name from sys.schemas where name = 'BPC'
),
cte_tables
as
(
select name from sys.tables where schema_name(schema_id) = 'BPC'
),
cte_storedprocs
as
(
select name from sys.procedures where schema_name(schema_id) = 'BPC'
)
insert @check
select name from cte_schema
union
select name from cte_tables
union
select name from cte_storedprocs

update l
set status = 'Successful'
from @checklist l join @check c on l.CheckName = c.CheckName
where status = 'Unknown'


if (select count(*) from bpc.adf_configtable) > 0
begin
insert @checklist
values('Populate adf_configtable','Initialize Table','Successful')
end
else
insert @checklist
values('Populate adf_configtable','Initialize Table','Failed')

if (select count(*) from bpc.adf_watermark) > 0
begin
insert @checklist
values('Populate adf_watermark','Initialize Table','Successful')
end
else
insert @checklist
values('Populate adf_watermark','Initialize Table','Failed')

if exists (select name from sys.database_principals where name like 'BPC-DataFactory%')  
begin
insert @checklist
values('ADF Managed Identity','ADF User','Successful')
end
else
insert @checklist
values('ADF Managed Identity','ADF User','Failed')


--select * from @checklist

select @BPC = Status  from @checklist where CheckName = 'BPC'
select @adf_configtable = Status  from @checklist where CheckName = 'adf_configtable'
select @adf_watermark = Status  from @checklist where CheckName = 'adf_watermark'
select @aasp_create_New_Sessionlog_partition= Status  from @checklist where CheckName = 'aasp_create_New_Sessionlog_partition'
select @aasp_Update_adf_watermark_WQI= Status  from @checklist where CheckName = 'aasp_Update_adf_watermark_WQI'
select @aasp_delete_copied_Sessionlog_partition = Status  from @checklist where CheckName = 'aasp_delete_copied_Sessionlog_partition'
select @aasp_manage_BPASessionlogpartitions = Status  from @checklist where CheckName = 'aasp_manage_BPASessionlogpartitions'
select @adfsp_get_maxlogid = Status  from @checklist where CheckName = 'adfsp_get_maxlogid'
select @adfsp_get_minlogid = Status  from @checklist where CheckName = 'adfsp_get_minlogid'
select @adfsp_get_sessionlog_data = Status  from @checklist where CheckName = 'adfsp_get_sessionlog_data'
select @adfsp_update_watermark_sessionlog = Status  from @checklist where CheckName = 'adfsp_update_watermark_sessionlog'
select @Populate_adf_configtable = Status  from @checklist where CheckName = 'Populate adf_configtable'
select @Populate_adf_watermark = Status  from @checklist where CheckName = 'Populate adf_watermark'
select @ADF_Managed_Identity  = Status  from @checklist where CheckName = 'ADF Managed Identity'

select @BPC 'BPC',@adf_configtable 'Config_Table',@adf_watermark 'Watermark_Table',@aasp_create_New_Sessionlog_partition 'New_Sessionlog_partition_SP',
	   @aasp_Update_adf_watermark_WQI 'Update_adf_watermark_WQI_SP',@aasp_delete_copied_Sessionlog_partition 'Delete_copied_Sessionlog_partition_SP',
	   @aasp_manage_BPASessionlogpartitions 'Manage_BPASessionlogpartitions_SP', @adfsp_get_maxlogid 'Get_maxlogid_SP',@adfsp_get_minlogid 'Get_minlogid_SP',
	   @adfsp_get_sessionlog_data 'Get_sessionlog_data_SP', @adfsp_update_watermark_sessionlog 'Update_watermark_sessionlog_SP',
	   @Populate_adf_configtable 'Populate_configtable', @Populate_adf_watermark 'Populate_watermark', @ADF_Managed_Identity 'ADF_Managed_Identity_Created'

