select * from dbo.BPASessionLog_NonUnicode with (nolock) 
where logid = 60900126
select *  from BPASessionLog_NonUnicodeCopy with (nolock)
where logid = 60900126

select top 100*  from [dbo].[BPASessionLog_NonUnicode] with (nolock) order by logid asc 
select top 1*  from [dbo].[BPASessionLog_NonUnicode] with (nolock) order by logid desc 

select top 1*  from BPASessionLog_NonUnicodeCopy with (nolock) order by logid desc
select top 1*  from BPASessionLog_NonUnicodeCopy with (nolock) order by logid asc


select *  from [dbo].[BPASessionLog_NonUnicode] with (nolock) 
where logid > 65396410
order by logid
go
select *  from BPASessionLog_NonUnicodeCopy with (nolock) 
where logid > 65396410
order by logid