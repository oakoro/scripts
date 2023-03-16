--with cte
--as
--(
--select top 3000000* from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--order by logid desc
--)
--select top 1* from cte order by logid

--select * from BPASession 
----where startdatetime > '2023-02-10'
--order by --sessionnumber,
--startdatetime desc--,enddatetime 

--select  * from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--where sessionnumber = 209622
--order by logid --desc --848393371

--select top 1* from [dbo].[BPASessionLog_NonUnicodeRetain] with (nolock)
--order by logid 

--select top 1* from [dbo].[BPASessionLog_NonUnicodeRetain] with (nolock)
--order by logid desc

--select top 1* from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--order by logid desc

--select *  from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--where sessionnumber = 209622 and logid < 848393715

alter index Index_queueid on BPAWorkQueueItem rebuild
