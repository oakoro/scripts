/****** Create Table [BPC].[adf_watermark]******/
IF (OBJECT_ID(N'[BPC].[adf_watermark]',N'U')) IS NULL
BEGIN
CREATE TABLE [BPC].[adf_watermark](
	[tablename] [varchar](50) NULL,
	[deltacolumn] [varchar](50) NULL,
	[last_processed_date] [datetime] NULL,
	[logid] [bigint] NULL,
	[createdTS] [datetime] NOT NULL
) ON [PRIMARY]
END


