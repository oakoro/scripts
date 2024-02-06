select top 20 sessionnumber,processid, name,startdatetime,
case
when convert(varchar(12),SessionRunDurationInSeconds) is null then 'in progress'
else convert(varchar(12),SessionRunDurationInSeconds)
end 'SessionRunDurationInSeconds'
from (
select  sessionnumber,s.processid , p.name,s.startdatetime,
datediff(SECOND,s.startdatetime,s.enddatetime)'SessionRunDurationInSeconds'

from BPASession s with (nolock) join BPAProcess p with (nolock)
on s.processid = p.processid
) a
--where SessionRunDurationInSeconds is null
order by startdatetime desc