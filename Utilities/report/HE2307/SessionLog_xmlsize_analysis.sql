declare @startdate datetime = getdate()-1
declare @startdate1 datetime = getdate()-21

;with cte_1
as
(
select s.sessionnumber,CAST(s.startdatetime as date)'Date', l.logid,datalength(l.result)'resultsize',datalength(l.attributexml)'xmlsize' from dbo.BPASession s with (nolock) join dbo.BPASessionLog_NonUnicode l with (nolock) 
on s.sessionnumber = l.sessionnumber
where s.startdatetime > '2024-08-31'--between @startdate1 and @startdate
)
,
cte_2
as
(
select [Date],count(logid)'RecordNo', sum(resultsize)'resultsize',sum(xmlsize)'xmlsize' from cte_1 group by [Date] --order by [Date]
)
select [Date],RecordNo, (resultsize+xmlsize)/1024/1024 'StorageUsed_MB' from cte_2 order by [Date]
