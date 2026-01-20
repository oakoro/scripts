with cte 
as
(
select top 2500 s.sessionnumber, s.startdatetime,s.enddatetime,p.name as ProcessName,
r.name as ResourceName, sl.result
from dbo.BPASessionLog_NonUnicode sl with (nolock)
join dbo.BPASession s on sl.sessionnumber = s.sessionnumber
join dbo.BPAResource r on s.runningresourceid = r.resourceid
join dbo.BPAProcess p on s.processid = p.processid
where sl.result like '%ERROR%'
order by sl.logid desc
)
select * from cte 

/*
WEAZCOPVW1
WEAZCOPVW10
WEAZCOPVW11
WEAZCOPVW14
WEAZCOPVW15
WEAZCOPVW19
WEAZCOPVW2
WEAZCOPVW20
WEAZCOPVW24
WEAZCOPVW3
WEAZCOPVW38
WEAZCOPVW39
WEAZCOPVW50
WEAZCOPVW54
WEAZCOPVW56
WEAZCOPVW8

ProcessName
CMA Keying Off Invoice 2.0
PC - LDS_Extend training deadlines for users on leave_All
Polling Queue Process - Finance
Polling Queue Process - Projects
SharePoint dashboard list updates
*/