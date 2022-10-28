

select top 5* FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) --where logid <= 323368541
order by logid desc

select top 5* FROM [dbo].[BPASessionLog_NonUnicodeReplica] with (nolock) --where logid >= 323368541
order by logid desc

select top 5* FROM [dbo].[BPASessionLog_NonUnicode1] with (nolock) --where logid <= 323368541
order by logid 
go
select top 5* FROM [dbo].[BPASessionLog_NonUnicodeReplica] with (nolock) where logid >= 285703420
order by logid 

select top 1* from [dbo].[BPASessionLog_NonUnicodeReplica]
select top 1* from [dbo].[BPASessionLog_NonUnicode1]
select count(*) from [dbo].[BPASessionLog_NonUnicodeCopy]

--alter index [PK_BPASessionLog_NonUnicodeReplica] on [dbo].[BPASessionLog_NonUnicodeReplica] rebuild
--alter table [dbo].[BPASessionLog_NonUnicode1] switch to [dbo].[BPASessionLog_NonUnicodeReplica]
--alter table [dbo].[BPASessionLog_NonUnicodeCopy] switch to [dbo].[BPASessionLog_NonUnicode1]


select top 2* FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) --where logid <= 323368541
order by logid 

select top 2* FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) --where logid <= 323368541
order by logid desc

select DATEDIFF(dd,'2022-04-13 14:00:51.097','2022-08-12 17:53:47.397')