select  sessionnumber,s.processid , p.name,
--s.startdatetime,s.enddatetime,
isnull(datediff(SECOND,s.startdatetime,s.enddatetime),0) 'SessionRunDurationInSeconds',
case
when isnull(datediff(SECOND,s.startdatetime,s.enddatetime),0) < 1 then 'in progress'
else'completed'
end 'status'
--'SessionRunDurationInMinutes'
--case
--when s.enddatetime is not null then datediff(MM,s.startdatetime,s.enddatetime)
--else convert(char(11),'in progress')
--end 'SessionRunDurationInMinutes'
from BPASession s with (nolock) join BPAProcess p with (nolock)
on s.processid = p.processid
--where s.enddatetime is null