select top 2* from [dbo].[BPASessionLog_NonUnicodeReplica]
where logid >= 136248907
order by logid 
go


select top 2* from [dbo].[BPASessionLog_NonUnicode] with (nolock)
order by logid 
go
select top 2* from [dbo].[BPASessionLog_NonUnicode] with (nolock)
order by logid desc
go
select top 2* from [dbo].[BPASessionLog_NonUnicodeReplica]
where logid >= 136248907
order by logid desc
go

--139990104	139759906
