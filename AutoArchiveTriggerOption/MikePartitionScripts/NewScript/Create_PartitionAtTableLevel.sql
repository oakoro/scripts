
CREATE TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTableLevel](
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
 CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTableLevel] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)--WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [pslogid_test]([logid])
GO

ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTableLevel]  WITH CHECK ADD  CONSTRAINT [FK_BPASessionLog_NonUnicode_PartitionTableLevel_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber])
GO

ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTableLevel] CHECK CONSTRAINT [FK_BPASessionLog_NonUnicode_PartitionTableLevel_BPASession]
GO


/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTableLevel_sessionnumber]    Script Date: 01/02/2023 11:49:10 ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_PartitionTableLevel_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTableLevel]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [pslogid_test]([logid])
GO


/*
The filegroup 'PRIMARY' specified for the clustered index 'PK_BPASessionLog_NonUnicode_PartitionTableLevel' was used for table 'dbo.BPASessionLog_NonUnicode_PartitionTableLevel' even though partition scheme 'pslogid_test' is specified for it.

Completion time: 2023-02-01T11:52:49.9510462+00:00
*/