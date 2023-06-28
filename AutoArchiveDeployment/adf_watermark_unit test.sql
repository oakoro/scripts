CREATE TABLE [BPC].[adf_watermark](
	[tablename] [varchar](50) NULL,
	[deltacolumn] [varchar](50) NULL,
	[last_processed_date] [datetime] NULL,
	[logid] bigint NULL,
	[createdTS] [datetime] NOT NULL DEFAULT (getdate()) 
) ON [PRIMARY]
GO
SELECT * FROM [BPC].[adf_watermark]

--INSERT [BPC].[adf_watermark]([tablename],[deltacolumn],[logid])
--VALUES ('BPASessionlog_NonUnicode','logid',170219650)

--INSERT [BPC].[adf_watermark]([tablename],[deltacolumn],[last_processed_date])
--VALUES ('BPAWorkQueueItem','finished','2023-06-08 23:37:28.790')



--TRUNCATE TABLE [BPC].[adf_watermark]
