declare @endlogid bigint, @currentlogid bigint --= 95993480
select top 1 @endlogid = logid from [dbo].[BPASessionLog_NonUnicode] with (nolock)
order by logid desc
select @endlogid
if exists (select 1 from [dbo].[BPASessionLog_NonUnicodeCopy])
begin
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeCopy]
order by logid desc 
end
else set @currentlogid = @currentlogid - 1
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
 SELECT  [logid]
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
set identity_insert [dbo].[BPASessionLog_NonUnicodeCopy] OFF
select top 1 @currentlogid = logid from [dbo].[BPASessionLog_NonUnicodeCopy]
order by logid desc  
end

