CREATE OR ALTER PROCEDURE [BPC].[adfsp_get_copyparameters]
@rowamt bigint,@tableName varchar(255),@tableSchema varchar(10)

AS

declare @minlogid bigint, @copiedMaxlogid bigint, @watermarklogid bigint,
 @currentMaxlogid bigint, @targetCopymaxid bigint, @strcommand nvarchar(400)
 





 

select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
set @targetCopymaxid = @copiedMaxlogid + @rowamt
set @strcommand = 'select top 1 '+convert(varchar(10),@currentMaxlogid) +' = logid from '+convert(varchar(5),@tableSchema)
+'.'+convert(varchar(5),@tableName) +' with (nolock) order by logid desc'
execute sp_executesql @strcommand
select @copiedMaxlogid'copiedMaxlogid', @currentMaxlogid'currentMaxlogid',
@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'

--ARCH.BPASessionLog_NonUnicodeOATest