/****** Object:  Table [dbo].[BPASessionLog_NonUnicode_PartitionTest]    Script Date: 01/02/2023 13:09:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionnumber] [int] NOT NULL,
	[stageid] [uniqueidentifier] NULL,
	[stagename] [varchar](128) NULL,
	[stagetype] [int] NULL,
	[processname] [varchar](128) NULL,
	[pagename] [varchar](128) NULL,
	[objectname] [varchar](128) NULL,
	[actionname] [varchar](128) NULL,
	[result] [varchar](max) NULL,
	[resulttype] [int] NULL,
	[startdatetime] [datetime] NULL,
	[enddatetime] [datetime] NULL,
	[attributexml] [varchar](max) NULL,
	[automateworkingset] [bigint] NULL,
	[targetappname] [varchar](32) NULL,
	[targetappworkingset] [bigint] NULL,
	[starttimezoneoffset] [int] NULL,
	[endtimezoneoffset] [int] NULL,
	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
 CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
)
GO

ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest]  WITH CHECK ADD  CONSTRAINT [FK_BPASessionLog_NonUnicode_PartitionTest_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber])
GO

ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest] CHECK CONSTRAINT [FK_BPASessionLog_NonUnicode_PartitionTest_BPASession]
GO

/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber]    Script Date: 01/02/2023 13:10:00 ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

