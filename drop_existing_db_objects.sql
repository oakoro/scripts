select * from sys.all_objects where SCHEMA_NAME(schema_id) = 'BPC'
and datepart(year,create_date) = '2023'

--drop table BPC.adf_configtable,BPC.adf_watermark
--drop proc 
--BPC.adfsp_get_maxlogid,
--BPC.adfsp_get_minlogid,
--BPC.adfsp_get_sessionlog_data,
--BPC.aasp_Update_adf_watermark_WQI,
--BPC.adfsp_update_watermark_sessionlog,
--BPC.aasp_create_New_Sessionlog_partition,
--BPC.aasp_delete_copied_Sessionlog_partition,
--BPC.aasp_manage_BPASessionlogpartitions