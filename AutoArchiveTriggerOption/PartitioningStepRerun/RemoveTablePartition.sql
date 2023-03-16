/****** Object:  Index [PK_BPASessionLog_NonUnicode_PartitionTest]    Script Date: 21/02/2023 12:32:50 ******/
ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest] DROP CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [PK_BPASessionLog_NonUnicode_PartitionTest]    Script Date: 21/02/2023 12:32:51 ******/
ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO



/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber]    Script Date: 21/02/2023 12:33:10 ******/
DROP INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
GO

/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber]    Script Date: 21/02/2023 12:33:10 ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO



