--alter table [dbo].[BPASessionLog_NonUnicode] switch to [dbo].[BPASessionLog_NonUnicodeCopy]
--alter table [dbo].[BPASessionLog_NonUnicodeRetain] switch to [dbo].[BPASessionLog_NonUnicode]
--select count(*) from [dbo].[BPASessionLog_NonUnicodeCopy]
--select count(*) from [dbo].[BPASessionLog_NonUnicodeRetain]
--select count(*) from [dbo].[BPASessionLog_NonUnicode]
--drop table [dbo].[BPASessionLog_NonUnicodeCopy],[dbo].[BPASessionLog_NonUnicodeRetain]
dbcc shrinkdatabase ([RPA-Production])



dbcc shrinkfile(data_0)