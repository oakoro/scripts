--[ARCH].[BPASessionLog_NonUnicodeOATest
--create partition function PF_dynamicBPASessionLogPartition(bigint) as range right for values()	
--create partition scheme PS_dynamicBPASessionLogPartition as partition PF_dynamicBPASessionLogPartition all to ([primary])

/****** Object:  Index [PK_BPASessionLog_NonUnicode2]    Script Date: 19/04/2023 10:30:41 ******/
--ALTER TABLE [ARCH].[BPASessionLog_NonUnicodeOATest] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicodeTest2] PRIMARY KEY CLUSTERED 
--(
--	[logid] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

--/****** Object:  Index [Index_BPASessionLog_NonUnicode2_sessionnumber]    Script Date: 19/04/2023 10:31:24 ******/
--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicodeTest2_sessionnumber] ON [ARCH].[BPASessionLog_NonUnicodeOATest]
--(
--	[sessionnumber] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

--CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_NonUnicodeTest2]
--    ON [ARCH].[BPASessionLog_NonUnicodeOATest](logid)
--    WITH (DROP_EXISTING = ON)
--    ON PS_dynamicBPASessionLogPartition (logid)

--DROP INDEX [Index_BPASessionLog_NonUnicodeTest2_sessionnumber] ON [ARCH].[BPASessionLog_NonUnicodeOATest]
--GO

--/****** Object:  Index [Index_BPASessionLog_NonUnicode_PartitionTest_NCI_sessionnumber]    Script Date: 01/02/2023 12:52:19 ******/
--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicodeTest2_sessionnumber] ON [ARCH].[BPASessionLog_NonUnicodeOATest]
--(
--	[sessionnumber] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON  PS_dynamicBPASessionLogPartition (logid)
--GO

--USE [RPA-Development-Broken]
--GO

--INSERT INTO [ARCH].[BPASessionLog_NonUnicodeOATest]
--           ([sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset])
-- select top 250 [sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset]
--from [dbo].[BPASessionLog_NonUnicode_Broken]           
--GO

--declare @nextPartitionID int
--select @nextPartitionID = IDENT_CURRENT('[ARCH].[BPASessionLog_NonUnicodeOATest]')
--select @nextPartitionID 'NextPartiton'

----select * from [ARCH].[BPASessionLog_NonUnicodeOATest] or

-----Test if partitiopn already exist and create the next partiton
--if not exists(
--select prv.value
--from sys.partition_functions as pf
--join sys.partition_range_values as prv on pf.function_id = prv.function_id
--where pf.name = 'PF_dynamicBPASessionLogPartition' and prv.value = @nextPartitionID
--)
--begin
--alter partition scheme PS_dynamicBPASessionLogPartition next used [primary];
--alter partition function PF_dynamicBPASessionLogPartition() split range(@nextPartitionID);
--end
--else
--begin
--Print 'Partition already exists';
--end