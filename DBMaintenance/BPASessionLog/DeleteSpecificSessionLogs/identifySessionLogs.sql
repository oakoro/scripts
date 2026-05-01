select DB_NAME();--1479404
with cte_ini
AS
(
select s.sessionnumber ,
DATEPART(MONTH,s.startdatetime)'Month',
DATEPART(YEAR,s.startdatetime)'year',
s.startdatetime ,p.name 'processname'
from dbo.BPASession s join dbo.BPAProcess p on s.processid = p.processid
WHERE DATEPART(MONTH,s.startdatetime) = 3 and DATEPART(YEAR,s.startdatetime) = 2026
and p.name = 'Attendance reporting, including LTS'
--ORDER by  [year], [Month],sessionnumber
)

SELECT COUNT(logid) FROM 
dbo.BPASessionLog_NonUnicode l join cte_ini i on l.sessionnumber = i.sessionnumber


-- select top 2* from dbo.BPAProcess
-- where name like '%Attendance reporting, including LTS'