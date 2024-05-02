/* Create and populate [BPC].[adf_watermark] Table */

SET NOCOUNT ON
--Create table
IF (OBJECT_ID(N'[BPC].[adf_watermark]',N'U')) IS NULL
BEGIN
CREATE TABLE [BPC].[adf_watermark](
	[tablename] [varchar](50) NULL,
	[deltacolumn] [varchar](50) NULL,
	[last_processed_date] [datetime] NULL,
	[logid] [bigint] NULL
) ON [PRIMARY];
END

--Populate or update table  
  DECLARE @waterMarkTables TABLE (
  [tblName] VARCHAR(50),
  [deltacolumn] VARCHAR(50),
  [last_processed_date] [datetime]
  )

  INSERT @waterMarkTables([tblName],[deltacolumn],[last_processed_date])
  VALUES ('BPASessionLog_NonUnicode','logid','1900-01-01'),('BPASessionLog_Unicode','logid','1900-01-01'),
		 ('BPAWorkQueueItem','finished','1900-01-01'),('BPAAuditEvents','eventdatetime','1900-01-01');


INSERT [BPC].[adf_watermark]  ([tablename], [deltacolumn], [last_processed_date])
SELECT [tblName], [deltacolumn], [last_processed_date]
FROM @waterMarkTables b
WHERE NOT EXISTS (SELECT [tablename] FROM [BPC].[adf_watermark] a WHERE a.[tablename] = b.[tblName]);

IF EXISTS (SELECT 1  FROM [BPC].[adf_watermark] WHERE [tablename] IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode'))
BEGIN
UPDATE [BPC].[adf_watermark] 
SET [logid] = 0
WHERE [tablename] IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')
AND [last_processed_date] = '1900-01-01 00:00:00.000' AND  [logid] IS NULL
END

SET NOCOUNT OFF