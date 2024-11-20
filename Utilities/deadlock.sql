--SELECT 
--	#OfDeadlockEvents = format(sum(event_count),'#,#')
--FROM
--	sys.event_log 
--WHERE 
--	event_type = 'deadlock'

	select * FROM
	sys.event_log 
WHERE event_type = 'deadlock' order by 3 desc


WITH CTE AS (
SELECT 
    CAST(event_data AS XML)  AS [target_data_XML]
FROM 
    sys.fn_xe_telemetry_blob_target_read_file('dl', null, null, null)
)
SELECT 
    target_data_XML.value('(/event/@timestamp)[1]', 'DateTime2') AS Timestamp,
    target_data_XML.query('/event/data[@name=''xml_report'']/value/deadlock') AS deadlock_xml,
    target_data_XML.query('/event/data[@name=''database_name'']/value').value('(/value)[1]', 'nvarchar(100)') AS db_name
FROM CTE