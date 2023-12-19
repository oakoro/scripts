declare @endlogid bigint, @currentlogid bigint, @initlogid bigint = 23447524
select top 1 @endlogid = logid from [dbo].[BPASessionLog_Unicode] with (nolock)
order by logid desc
select @endlogid 'endlogid'
if exists (select 1 from [dbo].[BPASessionLog_UnicodeRetain])
begin
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_UnicodeRetain]
order by logid desc 
end
else set @currentlogid = @initlogid - 1
select @endlogid'endlogid',@currentlogid'currentlogid'

while @currentlogid < @endlogid
begin
set identity_insert [dbo].[BPASessionLog_UnicodeRetain] ON
INSERT INTO [dbo].[BPASessionLog_UnicodeRetain]
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
from [dbo].[BPASessionLog_Unicode] with (nolock)
where logid > @currentlogid
		   order by logid 
set identity_insert [dbo].[BPASessionLog_UnicodeRetain] OFF
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_UnicodeRetain]
order by logid desc  
end

