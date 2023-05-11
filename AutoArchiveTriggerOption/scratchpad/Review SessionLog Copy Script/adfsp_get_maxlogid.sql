


--CREATE PROCEDURE [BPC].[adfsp_get_maxlogid]

--declare	 @minlogid bigint, @rowamt bigint, @tableName varchar(255)



--	declare @sqlCommand nvarchar(1000),
--	@ParmDefinition nvarchar(500),
--	@logid bigint,
--	@logidOUT bigint

--	set @minlogid = 110000001
--	set @tableName = 'BPASessionlog_NonUnicode'
--	set @rowamt = 10000000
----SELECT logid as 'minlogid' FROM bpc.adf_watermark_sessionlog
----select * FROM bpc.adf_watermark_sessionlog
--update bpc.adf_watermark_sessionlog
--set logid = 2001
--insert bpc.adf_watermark_sessionlog
--values('BPASessionLog_NonUnicodeOATest',1,getdate(),getdate())

--set @sqlCommand = N'select distinct (' + CONVERT(nvarchar,@minlogid) + ' + ' + CONVERT(nvarchar,@rowamt) + ') as ''maxlogid'' FROM dbo. ' + @tableName + ';'
--set @ParmDefinition = N'@minlogid bigint, @rowamt bigint, @tableName varchar(255), @logidOUT bigint OUTPUT';
----Exec sp_executesql @sqlCommand, @ParmDefinition, @minlogid = @minlogid, @rowamt = @rowamt, @tableName = @tableName, @logidOUT = @logid OUTPUT;
--print @sqlCommand

declare @minlogid bigint, @copiedMaxlogid bigint, @rowamt bigint,@watermarklogid bigint
declare @currentMaxlogid bigint, @tableName varchar(255), @targetCopymaxid bigint
declare @sqlstrtarget nvarchar(max), @sqlstractual nvarchar(max),@updatewatermark nvarchar(400)




set @rowamt = 3000
 
set @tableName = 'BPASessionLog_NonUnicodeOATest'
select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
set @targetCopymaxid = @copiedMaxlogid + @rowamt
select top 1 @currentMaxlogid = logid from ARCH.BPASessionLog_NonUnicodeOATest with (nolock) order by logid desc

select @copiedMaxlogid'@copiedMaxlogid', @currentMaxlogid'@currentMaxlogid',
@rowamt'@rowamt',@targetCopymaxid'@targetCopymaxid'

set @sqlstrtarget = '
INSERT INTO [ARCH].[BPASessionLog_NonUnicodeTestCopy]
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
    
select [logid]
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
from [ARCH].[BPASessionLog_NonUnicodeOATest]
where logid between ' +convert(nvarchar(50),@copiedMaxlogid) +' AND '+ convert(nvarchar(50),@targetCopymaxid)+';'


set @sqlstractual = '
INSERT INTO [ARCH].[BPASessionLog_NonUnicodeTestCopy]
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
    
select [logid]
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
from [ARCH].[BPASessionLog_NonUnicodeOATest]
where logid between ' +convert(nvarchar(50),@copiedMaxlogid) +' AND '+ convert(nvarchar(50),@currentMaxlogid)+';'




if @targetCopymaxid is not null and @targetCopymaxid < @currentMaxlogid
begin
set @watermarklogid = @targetCopymaxid
print @sqlstrtarget
--exec (@sqlstrtarget)

set @updatewatermark ='
update bpc.adf_watermark_sessionlog 
set logid = '+convert(nvarchar(50),@watermarklogid)+',copiedDate = GETDATE(),capturedDate = GETDATE()'
print @updatewatermark
--exec (@updatewatermark)
end
if @targetCopymaxid is not null and @targetCopymaxid > @currentMaxlogid
begin
set @watermarklogid = @currentMaxlogid
print @sqlstractual
--exec (@sqlstractual)

set @updatewatermark ='
update bpc.adf_watermark_sessionlog 
set logid = '+convert(nvarchar(50),@watermarklogid)+',copiedDate = GETDATE(),capturedDate = GETDATE()'
print @updatewatermark
--exec (@updatewatermark)
end


/*
@pipeline().globalParameters.sessionlogTablename
@activity('Lookup_Last_Processed_Logid').output.firstRow.minlogid
@pipeline().globalParameters.chunkAmount = 10000000
@pipeline().globalParameters.sessionlogTablename
@activity('Lookup_Get_Max_Logid').output.firstRow.maxlogid
--100000001
--110000001
*/



