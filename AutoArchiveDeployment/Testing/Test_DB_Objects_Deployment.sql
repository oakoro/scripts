declare @checklist table (
CheckName sysname,
Type sysname,
Status sysname default 'Fail'
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
where status = 'Fail'


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


select * from @checklist
