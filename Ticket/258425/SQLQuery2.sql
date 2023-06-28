sp_who2 active

--select top 1
--sessionnumber,
--startdatetime
--from
--dbo.bpasession with (nolock)
--where datediff(dd,convert(date,startdatetime),convert(date,getdate())) = 30
--order by startdatetime

--select top 1 logid
--from
--dbo.BPASessionLog_NonUnicode with (nolock) order by logid desc

--select 148127523 - 101969524
--101969524
--select top 1*
--from
--dbo.[BPASessionLog_NonUnicodeRetain] with (nolock) order by logid desc--106436523

--select * from BPASession where sessionnumber = 19330