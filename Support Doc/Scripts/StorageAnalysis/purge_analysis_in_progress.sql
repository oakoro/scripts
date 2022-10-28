
declare @startdate datetime = '2022-05-07 21:27:22.923'
declare @timeend datetime
declare @finishdate datetime = '2022-07-06 07:08:31.910'
if (object_id('tblstarttime','U')) is null
begin
create table dbo.tblstarttime (timestart datetime,timeend datetime)
end

set @timeend = dateadd(dd,10,@startdate)

select @timeend
while @timeend < @finishdate
begin 
set identity_insert [dbo].[BPASessionLog_NonUnicodeReplica] ON
insert [dbo].[BPASessionLog_NonUnicodeReplica]
select * from [dbo].[BPASessionLog_NonUnicode]
 
set identity_insert [dbo].[BPASessionLog_NonUnicodeReplica] OFF
end
--insert dbo.tblstarttime

--select * from dbo.tblstarttime
select top 1 logid from dbo.BPASessionLog_NonUnicode 
where startdatetime < '2022-05-07 21:27:22.923' --155865077
order by logid desc--199366633 -2022-07-04 14:47:39.867

--select * from dbo.BPASessionLog_NonUnicode where logid >= 155865077 and 199366633
--select getdate()
--select dateadd(dd,-60,getdate())
----2022-07-06 07:08:31.910