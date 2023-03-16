select * from BPASession where startdatetime > '2023-03-07 00:00' order by startdatetime desc,enddatetime desc --196065

--select 
--top 1* 
--from BPASessionLog_NonUnicode
--where sessionnumber = 195912 
--order by logid --611387595

--alter table [dbo].[BPASessionLog_NonUnicode1] switch to [dbo].[BPASessionLog_NonUnicodeCopy]
--alter table [dbo].[BPASessionLog_NonUnicodeRetain] switch to [dbo].[BPASessionLog_NonUnicode1]
--drop table [dbo].BPASessionLog_NonUnicodeRetain
--drop table [dbo].BPASessionLog_NonUnicodeCopy