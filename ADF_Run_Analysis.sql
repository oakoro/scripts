--select * from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode]


--with cte_1
--as
--(
--select runId,convert(date,createdTS)'RunDate',datediff(SECOND,executionStarttime,executionEndtime)'DurationInSecs'  from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode]
--)
--select distinct RunDate, SUM(DurationInSecs)'TotalRuninSecsPerDay', 
--AVG(DurationInSecs)'AvgRunInSecPerDay',
--MAX(DurationInSecs)'MaxRunInSecPerDay'
--from cte_1
--group by RunDate
--order by TotalRuninSecsPerDay desc


with cte_1
as
(
select runId,convert(date,createdTS)'RunDate',datediff(SECOND,executionStarttime,executionEndtime)'DurationInSecs'  from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode]
)
,cte_2
as
(
select distinct RunDate, SUM(DurationInSecs)'TotalRuninSecsPerDay', 
AVG(DurationInSecs)'AvgRunInSecPerDay',
MAX(DurationInSecs)'MaxRunInSecPerDay'
from cte_1
group by RunDate
)
select max(TotalRuninSecsPerDay/60/60), avg(TotalRuninSecsPerDay/60/60) from cte_2