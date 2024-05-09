select top 1* from dbo.BPASession;
select top 1* from dbo.BPASessionLog_NonUnicode

;with cte_1
as
(
select s.sessionnumber,CAST(s.startdatetime as date)'Date', l.logid,datalength(l.result)'resultszie',datalength(l.attributexml)'xmlsize' from dbo.BPASession s with (nolock) join dbo.BPASessionLog_NonUnicode l with (nolock) 
on s.sessionnumber = l.sessionnumber
)
select [Date],count(logid)'RecordNo', sum(resultszie)'resultszie',sum(xmlsize)'xmlsize' from cte_1 group by [Date] order by [Date]
