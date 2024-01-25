with 
cte_1
as
(
select  
s.sessionnumber 'Session No', s.startdatetime 'Start',s.enddatetime 'End', 
p.name 'Process',st.description 'Status', r.name as 'Started From',
u.username 'Windows User'
from 
[dbo].[BPASession] s join dbo.BPAProcess p on s.processid = p.processid 
join dbo.BPAStatus st on s.statusid = st.statusid
join dbo.BPAResource r on r.resourceid = s.starterresourceid 
join dbo.BPAUser u on s.starteruserid = u.userid 
),
cte_2
as
(select  
s.sessionnumber, r.name as 'Run On'
from 
[dbo].[BPASession] s join dbo.BPAProcess p on s.processid = p.processid 
join dbo.BPAStatus st on s.statusid = st.statusid
join dbo.BPAResource r on r.resourceid = s.runningresourceid 
)
select * from cte_1 a join cte_2 b on a.[Session No] = b.sessionnumber

--select * from 
--[dbo].[BPASession]

------select top 2* from dbo.BPAResource
--select * from dbo.BPAUser where userid = '9C7393BA-315F-4254-998A-30A0B08503F9'