SELECT MAX(logid) from [dbo].[BPASessionLog_NonUnicode];
select top 2* from dbo.BPASession with (nolock) order by startdatetime desc;
select top 10* from [dbo].[BPASessionLog_NonUnicode] with (nolock) order by logid desc;