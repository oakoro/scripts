DROP INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
GO

/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber]    Script Date: 01/02/2023 12:52:19 ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON  pslogid (logid)
GO

