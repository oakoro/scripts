declare @endlogid bigint, @currentlogid bigint
select top 1 @endlogid = logid from [dbo].[BPASessionLog_NonUnicodeReplica] with (nolock)
order by logid desc
select @endlogid
if exists (select 1 from [dbo].[BPASessionLog_NonUnicode])
begin
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicode]
order by logid desc 
end
else set @currentlogid = 136248906
select @endlogid'endlogid',@currentlogid'currentlogid'

while @currentlogid < @endlogid
begin
set identity_insert [dbo].[BPASessionLog_NonUnicodeCopy] ON
INSERT INTO [dbo].[BPASessionLog_NonUnicodeCopy]
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
from [dbo].[BPASessionLog_NonUnicodeReplica] with (nolock)
where logid > @currentlogid
		   order by logid 
set identity_insert [dbo].[BPASessionLog_NonUnicodeCopy] OFF
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeCopy]
order by logid desc  
end

