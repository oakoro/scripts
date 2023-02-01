/*** Truncate BPASessionLog_NonUnicode_Stage table in case previous truncation failed or was delayed ***/
truncate table [dbo].[BPASessionLog_NonUnicode_PartitionTest_STAGING];
GO

/*** Switch (Move) the data in Partition 2 to the BPASessionLog_NonUnicode_Stage table ***/
ALTER TABLE [dbo].[BPASessionLog_NonUnicode_PartitionTest] SWITCH PARTITION 9 TO [dbo].[BPASessionLog_NonUnicode_PartitionTest_STAGING];
GO
select count(*) from [dbo].[BPASessionLog_NonUnicode_PartitionTest_STAGING]
go


