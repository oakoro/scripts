select top 20* from BPASessionLog_NonUnicode with (nolock)
order by logid-- desc

--2021-08-11 19:33:52.567

select * from BPASession with (nolock)
where enddatetime is null and datediff(dd,startdatetime,GETDATE()) < 35
order by startdatetime desc, sessionnumber desc



select logid from BPASessionLog_NonUnicode with (nolock)
where sessionnumber = 21368