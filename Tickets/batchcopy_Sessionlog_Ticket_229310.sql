declare @endlogid bigint, @currentlogid bigint
select top 1 @endlogid = logid from [dbo].[BPASessionLog_NonUnicode] with (nolock)
order by logid desc
select @endlogid
if exists (select 1 from [dbo].[BPASessionLog_NonUnicodeReplica])
begin
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeReplica]
order by logid desc 
end
else set @currentlogid = 27748863
select @endlogid'endlogid',@currentlogid'currentlogid'

while @currentlogid < @endlogid
begin
set identity_insert [dbo].[BPASessionLog_NonUnicodeReplica] ON
INSERT INTO [dbo].[BPASessionLog_NonUnicodeReplica]
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
 SELECT TOP 1000 [logid]
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
set identity_insert [dbo].[BPASessionLog_NonUnicodeReplica] OFF
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeReplica]
order by logid desc  
end

