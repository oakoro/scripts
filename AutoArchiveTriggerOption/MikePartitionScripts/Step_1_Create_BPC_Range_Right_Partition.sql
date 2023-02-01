 /****** Object:  Index [PK_BPASessionLog_NonUnicode]    Script Date: 9/7/2022 3:39:45 PM ******/
ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest] DROP CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest] WITH ( ONLINE = OFF )
GO

/*** Create Right Range Partition with 8 Partitions - first and last are empty per best practice and Hold 6 weeks of data ***/ 
CREATE PARTITION FUNCTION pflogid (BIGINT)
AS RANGE Right FOR VALUES (1,2,3,4,5,6,7,2147483647)

/*** Create Schema for the Right Range Partition - this would normally merge the separate tables ***/ 
CREATE PARTITION SCHEME pslogid AS PARTITION pflogid
ALL TO ([PRIMARY])

/****** Recreate PK/Cluster Index Object:  Index [PK_BPASessionLog_NonUnicode_PartitionTest]    Script Date: 9/7/2022 3:32:40 PM ******/
ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON pslogid (logid)
GO

DROP INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
GO

/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber]    Script Date: 01/02/2023 12:52:19 ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON  pslogid (logid)
GO

-------------------------

--CREATE UNIQUE CLUSTERED INDEX PK_bpsessionlogPartitionTest
--    ON [dbo].[bpsessionlogPartitionTest] (logid)
--    WITH (DROP_EXISTING = ON)
--    ON ps_primarykey(logid)
--GO

--ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest_NCI] DROP CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest_NCI] WITH ( ONLINE = OFF )
--GO
--ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest_NCI] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicode_PartitionTest_NCI] PRIMARY KEY CLUSTERED 
--(
--	[logid] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON pslogid_test (logid)
--GO
/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber]    Script Date: 01/02/2023 12:50:11 ******/
/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber]    Script Date: 01/02/2023 12:52:19 ******/
--DROP INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest_NCI]
--GO

--/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber]    Script Date: 01/02/2023 12:52:19 ******/
--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_PartitionTest_NCI]
--(
--	[sessionnumber] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON  pslogid_test (logid)
--GO



