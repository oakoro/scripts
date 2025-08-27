
declare @sessionnumber bigint,@retaindays tinyint = 7;

with get_oldest_session_to_retain
as
(
select
sessionnumber,
startdatetime
from
dbo.bpasession with (nolock)
where datediff(dd,convert(date,startdatetime),convert(date,getdate())) = @retaindays
)
select top 1 @sessionnumber = sessionnumber from get_oldest_session_to_retain
order by startdatetime 
 
--select @sessionnumber

select top 1 logid
from
dbo.BPASessionLog_NonUnicode with (nolock)
where sessionnumber = @sessionnumber
order by logid