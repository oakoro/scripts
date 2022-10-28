select sessionnumber,p.name'ProcessName',r.name'ResourceName',startdatetime,enddatetime from BPASession s join BPAProcess p
on s.processid = p.processid
join [dbo].[BPAResource] r on s.runningresourceid = r.resourceid
--select top 2* from BPAProcess
--select top 2* from BPASessionLog_NonUnicode
--select top 2* from BPASession
--select * from [dbo].[BPAResource]