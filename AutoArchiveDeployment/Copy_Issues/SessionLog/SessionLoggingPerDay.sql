--select convert(date,startdatetime) as 'Date', count(*) as 'NumberofSessions' from dbo.BPASession with (nolock)
--group by convert(date,startdatetime)
--order by convert(date,startdatetime) desc

with cte
as
(
select sessionnumber, convert(date,startdatetime) 'startdatetime'
from dbo.BPASession with (nolock)
where convert(date,startdatetime) > '2024-03-30'
)
,
cte_1
as
(
select a.sessionnumber,a.startdatetime,isnull(datalength(b.result), 1)[result] , 
isnull(datalength(b.attributexml), 1) [attributexml], count(b.logid) 'RecordCount' from cte a join BPASessionLog_NonUnicode b on a.sessionnumber = b.sessionnumber
group by a.sessionnumber,a.startdatetime, isnull(datalength(b.result), 1),isnull(datalength(b.attributexml), 1)
--order by a.startdatetime 
)
select startdatetime, sum(RecordCount)'RecordCount',sum(result)/1024'result_KB',sum(attributexml)/1024'attributexml_KB' from cte_1
group by startdatetime
order by startdatetime