select top 1* from dbo.BPASessionLog_NonUnicode with (nolock) order by logid

select sessionnumber,startdatetime from dbo.BPASession
where datediff(dd,startdatetime,getdate()) = 60
order by startdatetime --97709

select count(*) from dbo.BPASessionLog_NonUnicode with (nolock)
where logid > 47913892 --14327097

