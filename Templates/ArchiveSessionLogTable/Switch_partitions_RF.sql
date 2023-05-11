--sp_rename 'BPASessionLog_NonUnicodeCopy', 'BPASessionLog_NonUnicodeCopy_Keep3Mths'
--alter table [dbo].[BPASessionLog_NonUnicode] switch to [dbo].[BPASessionLog_NonUnicodeCopy]
--alter table [dbo].[BPASessionLog_NonUnicodeRetain] switch to [dbo].[BPASessionLog_NonUnicode]
--sp_rename 'BPASessionLog_NonUnicode1', 'BPASessionLog_NonUnicode'
--drop table [dbo].[BPASessionLog_NonUnicodeCopy] 
--drop table [dbo].[BPASessionLog_NonUnicodeRetain] 



