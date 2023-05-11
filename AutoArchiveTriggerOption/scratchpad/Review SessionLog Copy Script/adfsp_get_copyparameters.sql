CREATE PROCEDURE [BPC].[adfsp_get_copyparameters]
@rowamt bigint,@tableName varchar(255)

AS

declare @minlogid bigint, @copiedMaxlogid bigint, @watermarklogid bigint,
 @currentMaxlogid bigint, @targetCopymaxid bigint
 





 

select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
set @targetCopymaxid = @copiedMaxlogid + @rowamt
select top 1 @currentMaxlogid = logid from ARCH.BPASessionLog_NonUnicodeOATest with (nolock) order by logid desc

select @copiedMaxlogid'copiedMaxlogid', @currentMaxlogid'currentMaxlogid',
@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'