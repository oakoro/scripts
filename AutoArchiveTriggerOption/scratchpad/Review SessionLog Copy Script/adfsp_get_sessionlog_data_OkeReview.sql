--CREATE PROCEDURE [BPC].[adfsp_get_sessionlog_data_OkeReview]
--(
--	@tableName nvarchar(30), --@minlogid bigint, @maxlogid bigint
--	@copiedMaxlogid bigint, @currentMaxlogid bigint,
--	@rowamt bigint,@targetCopymaxid bigint
--)
--AS
declare	@tableName nvarchar(30), --@minlogid bigint, @maxlogid bigint
	@copiedMaxlogid bigint, @currentMaxlogid bigint,
	@rowamt bigint,@targetCopymaxid bigint

set @rowamt = 2
 
set @tableName = 'BPASessionLog_NonUnicodeOATest'
select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
set @targetCopymaxid = @copiedMaxlogid + @rowamt
select top 1 @currentMaxlogid = logid from ARCH.BPASessionLog_NonUnicodeOATest with (nolock) order by logid desc

 
	declare @sqlCommand nvarchar(1000),
	@minlogid bigint, @maxlogid bigint

if @targetCopymaxid is not null and @targetCopymaxid < @currentMaxlogid
begin
set @minlogid = @copiedMaxlogid
set @maxlogid = @targetCopymaxid
set @sqlCommand = N'select logid, sessionnumber, stageid, stagename, stagetype, processname, pagename, objectname, actionname, result, resulttype, startdatetime, enddatetime, attributexml, automateworkingset ,targetappname, targetappworkingset, starttimezoneoffset, endtimezoneoffset, attributesize from dbo.' + @tableName + ' with (nolock) where logid between ' + CONVERT(nvarchar,@minlogid) + ' and ' + CONVERT(nvarchar,@maxlogid) + ' order by logid;';
print @sqlCommand
end
if @targetCopymaxid is not null and @targetCopymaxid >= @currentMaxlogid
begin
set @minlogid = @copiedMaxlogid
set @maxlogid = @currentMaxlogid
set @sqlCommand = N'select logid, sessionnumber, stageid, stagename, stagetype, processname, pagename, objectname, actionname, result, resulttype, startdatetime, enddatetime, attributexml, automateworkingset ,targetappname, targetappworkingset, starttimezoneoffset, endtimezoneoffset, attributesize from dbo.' + @tableName + ' with (nolock) where logid between ' + CONVERT(nvarchar,@minlogid) + ' and ' + CONVERT(nvarchar,@maxlogid) + ' order by logid;';
print @sqlCommand
end
--BEGIN
--    -- SET NOCOUNT ON added to prevent extra result sets from
--    -- interfering with SELECT statements.
--    SET NOCOUNT ON

--	declare @sqlCommand nvarchar(1000),@sqlCommandActual nvarchar(1000),
--	@ParmDefinition nvarchar(500),@minlogid bigint, @maxlogid bigint

--set @sqlCommand = N'select logid, sessionnumber, stageid, stagename, stagetype, processname, pagename, objectname, actionname, result, resulttype, startdatetime, enddatetime, attributexml, automateworkingset ,targetappname, targetappworkingset, starttimezoneoffset, endtimezoneoffset, attributesize from dbo.' + @tableName + ' with (nolock) where logid between ' + CONVERT(nvarchar,@minlogid) + ' and ' + CONVERT(nvarchar,@maxlogid) + ' order by logid;';
--set @ParmDefinition = N'@tableName nvarchar(255), @minlogid bigint, @maxlogid bigint';
----Exec sp_executesql @sqlCommand, @ParmDefinition, @tableName = @tableName, @minlogid = @minlogid, @maxlogid = @maxlogid
--print @sqlCommand
--END