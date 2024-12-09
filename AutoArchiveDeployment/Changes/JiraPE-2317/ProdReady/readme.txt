Update [BPC].[adf_configtable]
Execute 4_create_and_populate_adf_configtable_table.sql

Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Main\4_create_and_populate_adf_configtable_table.sql

Update [BPC].[adf_watermark]
Execute 3_adf_watermark_table.sql

Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Main\3_adf_watermark_table.sql

Deploy Stored procedures
aasp_copyDataDelta
Execute 14_create_aasp_copyDataDelta_SP.sql
Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Main\14_create_aasp_copyDataDelta_SP.sql

aasp_getCopyDatesDelta
Execute 15_create_aasp_getCopyDatesDelta_SP.sql
Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Main\15_create_aasp_getCopyDatesDelta_SP.sql

aasp_Update_adf_watermark_delta
Execute 16_create_aasp_Update_adf_watermark_delta_SP.sql

Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Main\16_create_aasp_Update_adf_watermark_delta_SP.sql

Remove tables with delta copy from [BPC].[adf_configtable]
Execute 4_1_remove_tables_with_deltacopy_from_adfconfigtable.sql
Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Cleanup\4_1_remove_tables_with_deltacopy_from_adfconfigtable.sql

Grant read access on tables to Azure Data Factory
Execute 17_grant_read_access_to_tables.sql
Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\SQL\Cleanup\17_grant_read_access_to_tables.sql 


Deploy Pipeline in Azure Data Factory
Create Global Parameters

Name: deltabatchsize
Value: 10000 

Create deltaTableCopy pipeline
Deploy deltaTableCopy.zip
Path:
BluePrismCloud-AutoArchive\AutoArchiveBuild\deltatablecopy\ADF\deltaTableCopy.zip


Disable WQI_Finished_Incremental_Pipeline activity on WQI_Finished_Incremental_Pipeline