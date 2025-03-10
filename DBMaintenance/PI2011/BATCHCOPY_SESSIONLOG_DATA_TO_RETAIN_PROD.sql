declare @endlogid bigint, @currentlogid bigint, @initlogid bigint = 60900126
select top 1 @endlogid = logid from [dbo].[BPASessionLog_NonUnicode] with (nolock)
order by logid desc
select @endlogid 'endlogid'
if exists (select 1 from [dbo].[BPASessionLog_NonUnicodeRetain])
begin
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeRetain]
order by logid desc 
end
else set @currentlogid = @initlogid - 1
select @endlogid'endlogid',@currentlogid'currentlogid'

while @currentlogid < @endlogid
begin
set identity_insert [dbo].[BPASessionLog_NonUnicodeRetain] ON
INSERT INTO [dbo].[BPASessionLog_NonUnicodeRetain]
           ([logid]
		   ,[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset])
 SELECT	TOP 1000	[logid]
		   ,[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset]
from [dbo].[BPASessionLog_NonUnicode] with (nolock)
where logid > @currentlogid 
		   order by logid 
set identity_insert [dbo].[BPASessionLog_NonUnicodeRetain] OFF
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeRetain]
order by logid desc  
end

--begin tran
--alter table [dbo].[BPASessionLog_NonUnicode] switch to [dbo].[BPASessionLog_NonUnicodeCopy]
--alter table [dbo].[BPASessionLog_NonUnicodeRetain] switch to [dbo].[BPASessionLog_NonUnicode]
--commit tran