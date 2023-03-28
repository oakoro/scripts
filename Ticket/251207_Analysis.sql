--[dbo].[BPASessionLog_NonUnicode]

select * from BPASession with (nolock)
where datediff(dd,startdatetime,getdate()) < 8 --and enddatetime is null
order by startdatetime desc

--select Top 2* from BPASessionLog_NonUnicode order by logid desc

--select datediff(dd,'2023-03-02 20:23:40.803',getdate())

select * from BPASessionLog_NonUnicode
where sessionnumber = 660362
order by logid --94245071

select count(*) from BPASessionLog_NonUnicode with (nolock)
where logid > 94245070 --937702