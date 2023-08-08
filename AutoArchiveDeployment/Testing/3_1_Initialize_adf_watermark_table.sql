  /****** Initialize watermark table - [BPC].[adf_watermark] ******/

IF EXISTS (SELECT 1 FROM SYS.tables WHERE name = 'adf_watermark' AND SCHEMA_NAME(SCHEMA_ID) = 'BPC')
  BEGIN
	IF (SELECT COUNT(*) FROM [BPC].[adf_watermark]) = 0
	BEGIN
	INSERT [BPC].[adf_watermark] ([tablename])
	VALUES ('BPASessionLog_NonUnicode'),('BPASessionLog_Unicode'),('BPAWorkQueueItem');

	UPDATE [BPC].[adf_watermark] 
	SET [deltacolumn] = 'logid', [last_processed_date] = '1900-01-01',[logid] = 0
	WHERE [tablename] IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')

	UPDATE [BPC].[adf_watermark] 
	SET [deltacolumn] = 'finished', [last_processed_date] = '1900-01-01'
	WHERE [tablename] IN ('BPAWorkQueueItem')
	END
   END
 
IF (SELECT COUNT(*) FROM bpc.adf_watermark) > 0
	SELECT 'SUCCESS' AS 'STATUS_OUTPUT'
	ELSE
	SELECT 'FAILED' AS 'STATUS_OUTPUT'


