select name,create_date,modify_date from sys.procedures 
where SCHEMA_NAME(schema_id) = 'BPC' and create_date > '2025-01-01'
order by create_date desc

select * from BPC.adf_configtable

select * from BPC.adf_watermark