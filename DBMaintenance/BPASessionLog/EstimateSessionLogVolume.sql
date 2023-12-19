declare @minSessionNo int, @maxSessionNo int, @minLogid bigint
select @minSessionNo = min(sessionnumber)--, @maxSessionNo = max(sessionnumber)--convert(nvarchar(20),s.startdatetime,3)
from dbo.BPASession with (nolock)
where DATEDIFF(dd,startdatetime,GETDATE()) < 60

select @minSessionNo

select top 1 @minLogid =  logid from dbo.BPASessionLog_NonUnicode with (nolock) 
where sessionnumber = @minSessionNo
order by logid

select count(*) from dbo.BPASessionLog_NonUnicode with (nolock) 
where logid > @minLogid
